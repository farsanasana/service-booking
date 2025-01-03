import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/Profile/di/new.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/auth_state.dart';
import 'package:secondproject/features/home_navigation/domain/entities/navigation_tab.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_event.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
      listener: (context, state) {
        if(state is LogoutSuccess){
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Welcome'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<LogoutBloc>().add(LogoutRequested());
                },
              ),
            ],
          ),
          body: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              switch (state.selectedTab) {
                case NavigationTab.home:
                  return const Center(child: Text('Home Page'));
                case NavigationTab.profile:
                  return const ProfilePage();
                case NavigationTab.settings:
                  return const Center(child: Text('Settings Page'));
              }
            },
          ),
          bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              return BottomNavigationBar(
                currentIndex: NavigationTab.values.indexOf(state.selectedTab),
                onTap: (index) {
                  context.read<NavigationBloc>().add(
                    TabChanged(NavigationTab.values[index]),
                  );
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
              );
            },
          ),
        ),
    );
  }
}
