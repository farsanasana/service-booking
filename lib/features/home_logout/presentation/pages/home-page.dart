import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_bloc.dart';
import 'package:secondproject/features/booking/presentation/bloc/booking/booking_state.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/booking_detailed_screen.dart';
import 'package:secondproject/features/booking/presentation/page/bookingss/booking_section.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';
import 'package:secondproject/features/home_logout/presentation/pages/offer.dart';
import 'package:secondproject/features/home_logout/presentation/pages/promotionbanner.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';
import 'package:secondproject/features/home_logout/presentation/pages/servicedetails/servicesdetailspage.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/app_bar.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/bodycontent.dart';
import 'package:secondproject/features/home_navigation/domain/entities/navigation_tab.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_event.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = ServicesBloc(context.read<ServicesRepository>());
            bloc.add(LoadCategoriesAndServices());
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        
        ),
        BlocProvider(
  create: (context) => BannerBloc(),
  child: PromotionBanner(),
)
      ],
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: buildAppBar(context),
            body: buildBody(context, state),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              currentIndex: state.selectedTab.index,
              onTap: (index) {
                context.read<NavigationBloc>().add(
                  TabChanged(NavigationTab.values[index]),
                );
              },
              items: NavigationTab.values.map((tab) {
                return BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

}