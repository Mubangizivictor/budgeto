// core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';

import '../../presentation/cubits/income_cubit/income_cubit.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../presentation/cubits/expense_cubits/expense_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(() => AuthCubit(authRepository: sl()));
  sl.registerFactory(() => ExpenseCubit(transactionRepository: sl()));
  sl.registerFactory(() => IncomeCubit(transactionRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    authDataSource: sl(),
    firestoreDataSource: sl(),
  ));
  sl.registerLazySingleton<TransactionRepository>(() => TransactionRepositoryImpl(
    firestoreDataSource: sl(),
  ));

  // Data Sources
  sl.registerLazySingleton(() => AuthDataSource());
  sl.registerLazySingleton(() => FirestoreDataSource());
}