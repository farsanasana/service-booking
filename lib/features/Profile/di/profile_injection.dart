// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:secondproject/features/Profile/data/repositories/profile_repository_impl.dart';
// // import 'package:secondproject/features/Profile/domain/repositories/profile_repository.dart';
// // import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
// // import 'package:secondproject/features/Profile/usecases/get_profile.dart';
// // import 'package:secondproject/features/Profile/usecases/sign_out.dart';
// // import 'package:secondproject/features/Profile/usecases/update_dispay_name.dart';
// // import 'package:get_it/get_it.dart';
// // final getIt = GetIt.instance;
// // void initProfileDependencies() {
// //   final firebaseAuth = FirebaseAuth.instance;
// //   final firestore = FirebaseFirestore.instance;

// //   // Register Firebase instances
// //   if (!getIt.isRegistered<FirebaseAuth>()) {
// //     getIt.registerLazySingleton(() => firebaseAuth);
// //   }
  
// //   if (!getIt.isRegistered<FirebaseFirestore>()) {
// //     getIt.registerLazySingleton(() => firestore);
// //   }

// //   // Repository
// //   if (!getIt.isRegistered<ProfileRepository>()) {
// //     getIt.registerLazySingleton<ProfileRepository>(
// //       () => ProfileRepositoryImpl(
// //         getIt<FirebaseAuth>(),
// //         getIt<FirebaseFirestore>(),
// //       ),
// //     );
// //   }

// //   // Use Cases
// //   if (!getIt.isRegistered<GetProfile>()) {
// //     getIt.registerLazySingleton(() => GetProfile(getIt<ProfileRepository>()));
// //   }
  
// //   if (!getIt.isRegistered<UpdateDisplayName>()) {
// //     getIt.registerLazySingleton(() => UpdateDisplayName(getIt<ProfileRepository>()));
// //   }
  
// //   if (!getIt.isRegistered<SignOut>()) {
// //     getIt.registerLazySingleton(() => SignOut(getIt<ProfileRepository>()));
// //   }

// //   // BLoC
// //   if (!getIt.isRegistered<ProfileBloc>()) {
// //     getIt.registerFactory(
// //       () => ProfileBloc(
// //         getProfile: getIt<GetProfile>(),
// //         updateDisplayName: getIt<UpdateDisplayName>(),
// //         signOut: getIt<SignOut>(),
// //         auth: getIt<FirebaseAuth>(),
// //       ),
// //     );
// //   }
// // }
// import 'package:get_it/get_it.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';

// final getIt = GetIt.instance;

// void initProfileDependencies() {
//   // Firebase Auth
//   if (!getIt.isRegistered<FirebaseAuth>()) {
//     getIt.registerLazySingleton(() => FirebaseAuth.instance);
//   }

//   // BLoC
//   if (!getIt.isRegistered<ProfileBloc>()) {
//     getIt.registerFactory(() => ProfileBloc(auth: getIt<FirebaseAuth>()));
//   }
// }





