// core/di/injection_container.dart
import 'package:budgeto/core/local_storage/hive_service.dart';
import 'package:budgeto/core/notifications/notification_manager.dart';
import 'package:budgeto/core/services/notification_service.dart';
import 'package:budgeto/core/services/pdf_export_service.dart';
import 'package:get_it/get_it.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/firestore_datasource.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/datasources/storage_datasource.dart';
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
  sl.registerLazySingleton(
      () => NotificationManager(firestoreDataSource: sl()));
  sl.registerLazySingleton(() => NotificationService(
    repository: sl(),
    notificationManager: sl(),
    transactionRepository: sl(),
  ));
  sl.registerLazySingleton(() => PdfExportService());
  sl.registerLazySingleton(() => HiveService());

  // ── Repositories ──────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
    authDataSource: sl(),
    firestoreDataSource: sl(),
    storageDataSource: sl(),
  ));

  sl.registerLazySingleton<TransactionRepository>(
          () => TransactionRepositoryImpl(firestoreDataSource: sl()));

  sl.registerLazySingleton<NotificationRepository>(
          () => NotificationRepositoryImpl(dataSource: sl()));

  // ── Data Sources ──────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => AuthDataSource());
  sl.registerLazySingleton(() => FirestoreDataSource());
  sl.registerLazySingleton(() => NotificationDataSource());
  sl.registerLazySingleton(() => StorageDataSource());
}
