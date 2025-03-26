import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_navigation/domain/entities/navigation_tab.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_event.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_state.dart';

Widget buildBottomNavigation(BuildContext context, NavigationState state) {
  return BottomNavigationBar(
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
  );
}
