// presentation/cubits/export_cubit/export_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/services/pdf_export_service.dart';
import '../../../data/models/export_model.dart';
import '../../../data/models/expense_model.dart';
import '../../../data/models/income_model.dart';

part 'export_state.dart';

class ExportCubit extends Cubit<ExportState> {
  final PdfExportService _exportService;

  ExportCubit({required PdfExportService exportService})
      : _exportService = exportService,
        super(ExportInitial());

  Future<void> exportPdf({
    required DateTime startDate,
    required DateTime endDate,
    required List<ExpenseModel> allExpenses,
    required List<IncomeModel> allIncome,
    required String userName,
    required String userEmail,
  }) async {
    emit(ExportLoading());
    try {
      // Filter to selected date range.
      final expenses = allExpenses
          .where((e) =>
      !e.date.isBefore(startDate) && !e.date.isAfter(endDate))
          .toList();

      final income = allIncome
          .where((i) =>
      !i.date.isBefore(startDate) && !i.date.isAfter(endDate))
          .toList();

      final request = ExportRequest(
        startDate: startDate,
        endDate: endDate,
        expenses: expenses,
        income: income,
        userName: userName,
        userEmail: userEmail,
      );

      await _exportService.exportAndShare(request);
      emit(ExportSuccess());
    } catch (e) {
      emit(ExportError(e.toString()));
    }
  }

  void reset() => emit(ExportInitial());
}