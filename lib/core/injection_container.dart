// core/di/injection_container.dart
import 'package:budgeto/core/services/notification_service.dart';
import 'package:budgeto/core/services/pdf_export_service.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../presentation/cubits/income_cubit/income_cubit.dart';
import '../../presentation/cubits/export_cubit/export_cubit.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/notification_repository.dart';
import '../data/repositories/transaction_repository.dart';
import '../presentation/cubits/auth_cubits/auth_cubit.dart';
import '../presentation/cubits/expense_cubits/expense_cubit.dart';
import '../presentation/cubits/notification_cubit/notification_cubit/notification_cubit.dart';


final sl = GetIt.instance;

Future<void> init() async {
  // ── Cubits ────────────────────────────────────────────────────────────────
  sl.registerFactory(() => AuthCubit(authRepository: sl()));

  sl.registerFactory(() => ExpenseCubit(
    transactionRepository: sl(),
    notificationService: sl(),
  ));

  sl.registerFactory(() => IncomeCubit(
    transactionRepository: sl(),
    notificationService: sl(),
  ));

  sl.registerFactory(() => NotificationCubit(repository: sl()));

  sl.registerFactory(() => ExportCubit(exportService: sl()));

  // ── Services ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => NotificationService(repository: sl()));
  sl.registerLazySingleton(() => PdfExportService());

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    authDataSource: sl(),
    firestoreDataSource: sl(),
  ));

  sl.registerLazySingleton<TransactionRepository>(
          () => TransactionRepositoryImpl(firestoreDataSource: sl()));

  sl.registerLazySingleton<NotificationRepository>(
          () => NotificationRepositoryImpl(dataSource: sl()));

  // ── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthDataSource());
  sl.registerLazySingleton(() => FirestoreDataSource());
  sl.registerLazySingleton(() => NotificationDataSource());
}