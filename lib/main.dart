import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:secondproject/features/Profile/data/repositories/firebase_user_repository.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/booking/data/repository/repository_booking.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:secondproject/features/google/google_sign_in/google_sign_in_bloc.dart';
import 'package:secondproject/features/google/repositories_google_services.dart';
import 'package:secondproject/features/home_logout/domain/repositories/auth_repository.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/data/models/datasources/services_repository_impl.dart';
import 'package:secondproject/features/home_logout/domain/usecases/logout.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth/auth_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/pages/home-page.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/login/data/repositories/auth_repository_impl.dart';
import 'package:secondproject/features/login/domain/usecases/Loginuse.dart';
import 'package:secondproject/features/login/presentation/bloc/login_bloc/login_bloc.dart';
import 'package:secondproject/features/login/presentation/pages/forgot_password.dart';
import 'package:secondproject/features/login/presentation/pages/login-page.dart';
import 'package:secondproject/features/onborading/presention/pages/onboarding_page.dart';
import 'package:secondproject/features/signup/data/repositories/firebase_signup_repository.dart';
import 'package:secondproject/features/signup/domain/entities/repositories/signup_repository.dart';
import 'package:secondproject/features/signup/domain/usecases/signup_user.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_bloc.dart';
import 'package:secondproject/features/signup/presentation/bloc/signup_bloc.dart';
import 'package:secondproject/features/signup/presentation/page/signup-page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // initProfileDependencies();

final firebaseAuth = FirebaseAuth.instance;
final firebaseStore=FirebaseFirestore.instance;

  // Initialize repositories
final authenticationRepository  = AuthenticationRepository(firebaseAuth); // Correct repository
final signUpRepository = FirebaseSignupRepository(firebaseAuth,firebaseStore);
final logoutRepository = LogoutRepository();
final userRepository = FirebaseUserRepository(firebaseStore);

 
  // Initialize use cases
final loginUseCase = LoginUseCase(authenticationRepository); // Use correct repository for login
final signupUseCase = SignupUser(signUpRepository);
final logoutUseCase = LogoutUseCase(logoutRepository);
final getUserProfile = GetUserProfile(userRepository); 
  
  runApp(MyApp(
   loginUseCase: loginUseCase,
   signupUseCase: signupUseCase,
   logoutUseCase: logoutUseCase,  
   getUserProfile:getUserProfile,
   firestore: firebaseStore,  
  ));
}

class MyApp extends StatelessWidget {
  final LoginUseCase loginUseCase;
  final SignupUser signupUseCase;
  final LogoutUseCase logoutUseCase;
  final GetUserProfile getUserProfile;
  final FirebaseFirestore firestore; 

  const MyApp({
    super.key,
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.getUserProfile, 
    required this. firestore,
    
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ServicesRepository>(create: (context)=>ServicesRepositoryImpl(firestore),)
      ],
      child: MultiBlocProvider(
        providers: [
          Provider<GetUserProfile>.value(value: getUserProfile),
         BlocProvider(
      create: (context) => BookingBloc(
        BookingRepository(),
      ),
    ),
      BlocProvider(create: (_) => OfferBannerBloc(firestore: FirebaseFirestore.instance)..add(const LoadBannerImages())),
          BlocProvider(create: (_) => LoginBloc(loginUseCase)),
               BlocProvider<BannerBloc>(
          create: (context) => BannerBloc()),
        
          
          BlocProvider(create: (_) => SignupBloc(signupUseCase)),   
          BlocProvider(create: (_) => LogoutBloc(logoutUseCase)),
          BlocProvider(create: (_) => GoogleSignInBloc(GoogleSignInService())),
          BlocProvider(create: (_)=>ProfileBloc(getUserProfile)),
        
          BlocProvider(
            create: (context) => ServicesBloc(context.read<ServicesRepository>())),
          
          BlocProvider(
            create: (context) => ImageBloc(),),
           
        
          BlocProvider(create: (_) => NavigationBloc()),
            // RepositoryProvider<HomeRepository>(create: (_) => HomeRepository()),
          
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/onboarding',
          routes: {
            '/onboarding': (context) => const OnboardingPage(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignupPage(),
            '/home': (context) => HomePage(),
            '/profile':(context)=>ProfilePage(),
            '/forget_pass':(context)=>ForgotPassword(),
          },
        ),
      ),
    );
  }
}
