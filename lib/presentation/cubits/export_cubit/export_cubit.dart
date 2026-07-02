import 'dart:async';
import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../data/models/export_model.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/models/income_model.dart';
import '../../../data/repositories/transaction_repository.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final PdfExportService _exportService;
  final TransactionRepository _transactionRepository;

  ExportCubit({
    required PdfExportService exportService,
    required TransactionRepository transactionRepository,
  })  : _exportService = exportService,
        _transactionRepository = transactionRepository,
        super(ExportInitial());

  Future<void> exportPdf({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
    required String userName,
    required String userEmail,
    Rect? sharePositionOrigin,
  }) async {
    emit(ExportLoading());
    try {
      // 1. Fetch data in parallel with a timeout.
      // We use .first to get the current snapshot of data for the report range.
      final results = await Future.wait([
        _transactionRepository
            .getExpenses(userId, startDate: startDate, endDate: endDate)
            .first,
        _transactionRepository
            .getIncome(userId, startDate: startDate, endDate: endDate)
            .first,
      ]).timeout(const Duration(seconds: 15));

      final List<ExpenseModel> expenses = results[0] as List<ExpenseModel>;
      final List<IncomeModel> income = results[1] as List<IncomeModel>;

      // 2. Prepare the report request
      final request = ExportRequest(
        startDate: startDate,
        endDate: endDate,
        expenses: expenses,
        income: income,
        userName: userName,
        userEmail: userEmail,
      );

      // 3. Generate and trigger the native share sheet
      await _exportService.exportAndShare(request, sharePositionOrigin: sharePositionOrigin);
      
      emit(ExportSuccess());
    } on TimeoutException {
      emit(const ExportError('Export timed out. Please check your connection.'));
    } catch (e) {
      String errorMsg = e.toString();
      // Detect if Firestore is complaining about a missing composite index
      if (errorMsg.contains('index') || errorMsg.contains('FAILED_PRECONDITION')) {
        errorMsg = 'Database index required. Check the link in the Debug Console to create it.';
      }
      emit(ExportError(errorMsg));
    }
  }

  void reset() => emit(ExportInitial());
}
