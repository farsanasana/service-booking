import 'package:flutter/material.dart';

enum NavigationTab {
  home,
  bookings,
  
  profile;

  String get label {
    switch (this) {
      case NavigationTab.home:
        return 'Home';
      case NavigationTab.bookings:
        return 'bookings';
      
      case NavigationTab.profile:
        return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home;
      case NavigationTab.bookings:
        return Icons.calendar_today;
      
      case NavigationTab.profile:
        return Icons.person_outline;
    }
  }
}