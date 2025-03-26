import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:secondproject/core/network/network_info.dart';
import 'package:secondproject/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:secondproject/features/auth/data/datasources/profile_image_data_source.dart';
import 'package:secondproject/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:secondproject/features/auth/data/repositories/profile_image_repository_imp.dart';
import 'package:secondproject/features/auth/domain/usercase/signup_user.dart';
import 'package:secondproject/features/auth/domain/usercase/uplod_image.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:secondproject/features/login/domain/usecase/login_usecase.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External Dependencies
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => InternetConnectionChecker); // Fixed instantiation

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // Repositories
  sl.registerLazySingleton(() => AuthRepositoryImpl(
        remoteDataSource: sl(),
        firebaseAuth: sl(),
      ));
  sl.registerLazySingleton(() => ProfileImageRepositoryImpl(dataSource: sl()));

  // Data Sources
  sl.registerLazySingleton(() => AuthRemoteDataSourceImpl(
        firebaseAuth: sl(),
        firestore: sl(),
      ));
  sl.registerLazySingleton(() => CloudinaryImageDataSourceImpl());

  // Use Cases
  sl.registerLazySingleton(() => SignupUser(sl()));
  sl.registerLazySingleton(() => UploadImage(sl()));
  sl.registerLazySingleton(() => LoginUseCase(sl())); // Added login
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl())); // Added reset password

  // BLoCs
  sl.registerFactory(() => AuthBloc(sl()));
  sl.registerFactory(() => ProfileImageBloc(sl()));
  sl.registerFactory(() => LoginBloc(
        loginUseCase: sl(),
        resetPasswordUseCase: sl(), googleSignInUseCase: sl(),
      )); // Added LoginBloc
}
