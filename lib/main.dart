import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:secondproject/core/constand/api.dart';
import 'package:secondproject/core/injection/injections_container.dart';
import 'package:secondproject/core/network/network_info.dart';
import 'package:secondproject/features/Profile/data/repositories/firebase_user_repository.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:secondproject/features/auth/data/datasources/profile_image_data_source.dart';
import 'package:secondproject/features/auth/data/repositories/auth_repository_imp.dart';
import 'package:secondproject/features/auth/data/repositories/profile_image_repository_imp.dart';
import 'package:secondproject/features/auth/domain/usercase/signup_user.dart';
import 'package:secondproject/features/auth/domain/usercase/uplod_image.dart';
import 'package:secondproject/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:secondproject/features/auth/presentation/pages/signup.dart';
import 'package:secondproject/features/booking/data/model/booking_model.dart';
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/booking_detailed_screen.dart';
import 'package:secondproject/features/booking/presentation/page/paymentconfirmation_screen.dart';
import 'package:secondproject/features/booking/presentation/page/timeselection_screen.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/repositories_google_services.dart';
import 'package:secondproject/features/home_logout/domain/repositories/auth_repository.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/data/models/datasources/services_repository_impl.dart';
import 'package:secondproject/features/home_logout/domain/usecases/logout.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth/auth_bloc.dart' as home_logout;
import 'package:secondproject/features/home_logout/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/pages/home-page.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/login/data/datasources/log_remote_data_source.dart';
import 'package:secondproject/features/login/data/repositories/login_repository_imp.dart';
import 'package:secondproject/features/login/domain/usecase/login_usecase.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/pages/login-page.dart';
import 'package:secondproject/features/login/presentation/widgets/forget_password.dart';
import 'package:secondproject/features/onborading/presention/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  // Initialize Stripe
  Stripe.publishableKey = stripePublishKey;
  await Stripe.instance.applySettings();
 
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseStore = FirebaseFirestore.instance;

  // Initialize data sources
  final profileImageDataSource = CloudinaryImageDataSourceImpl();
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    firebaseAuth: firebaseAuth,
    firestore: firebaseStore,
  );
  
  // Initialize repositories
  final profileImageRepository = ProfileImageRepositoryImpl(dataSource: profileImageDataSource);
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    firebaseAuth: firebaseAuth,
  );
  final loginRepository = LoginRepositoryImp(
    LogRemoteDataSourceImpl(firebaseAuth, GoogleSignIn()),
  );
  final logoutRepository = LogoutRepository();
  final userRepository = FirebaseUserRepository(firebaseStore);
  
  // Initialize use cases
  final loginUseCase = LoginUseCase(loginRepository);
  final signupUseCase = SignupUser(authRepository);
  final logoutUseCase = LogoutUseCase(logoutRepository);
  final getUserProfile = GetUserProfile(userRepository);
  final uploadImageUseCase = UploadImage(profileImageRepository);

  // **Fix Applied Here: Define before usage**
  final resetPasswordUseCase = ResetPasswordUseCase(loginRepository);
  final googleSignInUseCase = GoogleSignInUseCase(loginRepository);
  
  runApp(MyApp(
    loginUseCase: loginUseCase,
    signupUseCase: signupUseCase,
    logoutUseCase: logoutUseCase,  
    getUserProfile: getUserProfile,
    firestore: firebaseStore,  
    uploadImageUseCase: uploadImageUseCase,
    resetPasswordUseCase: resetPasswordUseCase,
    googleSignInUseCase: googleSignInUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final SignupUser signupUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserProfile getUserProfile;
  final FirebaseFirestore firestore; 
  final UploadImage uploadImageUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GoogleSignInUseCase googleSignInUseCase;

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.getUserProfile, 
    required this.firestore,
    required this.uploadImageUseCase,
    required this.resetPasswordUseCase,
    required this.googleSignInUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServicesRepository>(
          create: (context) => ServicesRepositoryImpl(firestore),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          Provider<GetUserProfile>.value(value: getUserProfile),
          BlocProvider(create: (_) => BookingBloc(BookingRepository())),
          BlocProvider(create: (_) => OfferBannerBloc(firestore: firestore)..add(const LoadBannerImages())),
          BlocProvider(create: (_) => LoginBloc(
            loginUseCase: loginUseCase,
            resetPasswordUseCase: resetPasswordUseCase,
            googleSignInUseCase: googleSignInUseCase,
          )),
          
          BlocProvider(create: (_) => AuthBloc(signupUseCase)),
          BlocProvider(create: (_) => LogoutBloc(logoutUseCase)),
          BlocProvider(create: (_) => GoogleSignInBloc(GoogleSignInService())),
          BlocProvider(create: (_) => ProfileBloc(getUserProfile)),
          BlocProvider(create: (context) => ServicesBloc(context.read<ServicesRepository>())),
           BlocProvider(
            create: (context) => ProfileImageBloc(uploadImageUseCase),
          ),
          BlocProvider(create: (_) => NavigationBloc()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/onboarding',
          routes: {
            '/onboarding': (context) => const OnboardingPage(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/home': (context) => HomePage(),
            '/profile': (context) => ProfilePage(),
            '/forget_pass': (context) => ForgotPasswordLink(),
            '/booking/confirmation': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
              return BookingConfirmationScreen(
                bookingId: args?['bookingId'] ?? '',
                totalAmount: args?['totalAmount'] ?? 0.0,
                serviceName: args?['serviceName'] ?? '',
              );
            },
          
          },
        ),
      ),
    );
  }
}
