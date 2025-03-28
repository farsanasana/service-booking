import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/booking/presentation/page/booking_details_page/booking_detailed_screen.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/build_content.dart';
import 'package:secondproject/features/home_navigation/domain/entities/navigation_tab.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_state.dart';

Widget buildBody(BuildContext context, NavigationState navigationState) {
  switch (navigationState.selectedTab) {
    case NavigationTab.home:
      return buildHomeContent(context);

    case NavigationTab.bookings:
    // Get the current user's ID dynamically
    final userId = FirebaseAuth.instance.currentUser?.uid;
    // If user is not logged in, show login page or a message
    if (userId == null) {
      return Center(child: Text('Please log in to view your bookings'));
      // Or navigate to login: return LoginPage();
    }
    return BookingDetailedScreen(userId: userId);
   

    case NavigationTab.profile:
      return ProfilePage();
  }
}