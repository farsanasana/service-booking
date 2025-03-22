import 'package:flutter/material.dart';

enum NavigationTab {
  home,
  booking_details,
  payments,
  profile;

  String get label {
    switch (this) {
      case NavigationTab.home:
        return 'Home';
      case NavigationTab.booking_details:
        return 'booking_details';
      case NavigationTab.payments:
        return 'Payments';
      case NavigationTab.profile:
        return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case NavigationTab.home:
        return Icons.home;
      case NavigationTab.booking_details:
        return Icons.calendar_today;
      case NavigationTab.payments:
        return Icons.credit_card;
      case NavigationTab.profile:
        return Icons.person_outline;
    }
  }
}