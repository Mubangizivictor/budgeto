// presentation/cubits/income_cubit/income_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/income_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/services/notification_service.dart';

part 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final TransactionRepository _transactionRepository;
  final NotificationService _notificationService;
  StreamSubscription<List<IncomeModel>>? _incomeSubscription;

  IncomeCubit({
    required TransactionRepository transactionRepository,
    required NotificationService notificationService,
  })  : _transactionRepository = transactionRepository,
        _notificationService = notificationService,
        super(IncomeInitial());

  void getIncome(String userId) {
    if (userId.isEmpty) {
      emit(const IncomeError('User ID is empty'));
      return;
    }

    _incomeSubscription?.cancel();
    emit(IncomeLoading());

    _incomeSubscription = _transactionRepository
        .getIncome(userId)
        .listen(
          (income) {
        if (!isClosed) {
          final total =
          income.fold(0.0, (sum, item) => sum + item.amount);
          emit(IncomeLoaded(income: income, totalIncome: total));
        }
      },
      onError: (error) {
        if (!isClosed) emit(IncomeError(error.toString()));
      },
    );
  }

  Future<void> addIncome({
    required String userId,
    required double amount,
    required String source,
    required String note,
    required DateTime date,
  }) async {
    try {
      await _transactionRepository.addIncome(
        userId: userId,
        amount: amount,
        source: source,
        note: note,
        date: date,
      );

      final newIncome = IncomeModel(
        id: '',
        userId: userId,
        amount: amount,
        source: source,
        note: note,
        date: date,
        createdAt: DateTime.now(),
      );

      await _notificationService.onIncomeAdded(
        userId: userId,
        income: newIncome,
      );
    } catch (e) {
      if (!isClosed) emit(IncomeError(e.toString()));
    }
  }

  Future<void> deleteIncome(String incomeId, String userId) async {
    try {
      await _transactionRepository.deleteIncome(incomeId);
    } catch (e) {
      if (!isClosed) emit(IncomeError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _incomeSubscription?.cancel();
    return super.close();
  }
}