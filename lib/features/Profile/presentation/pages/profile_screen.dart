/*

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: user != null
            ? FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error fetching profile data.'),
                    );
                  }
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const Center(
                      child: Text('User data not found.'),
                    );
                  }

                  final userData = snapshot.data!;
                  final String name = userData['username'] ?? 'Not Available';
                  final String email = userData['email'] ?? 'Not Available';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      itemProfile('Name', name, Icons.person),
                      const SizedBox(height: 10),
                      itemProfile('Email', email, Icons.email),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorSys.secoundry,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          child: const Text('Logout'),
                        ),
                      ),
                    ],
                  );
                },
              )
            : const Center(
                child: Text(
                  'No user logged in.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: ColorSys.secoundry,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: ColorSys.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
      ),
    );
  }
}




asdfghjklasdfghjkASDFGH

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_event.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('No user logged in.', style: TextStyle(fontSize: 16)),
      );
    }

    return Scaffold(
      body: BlocProvider(
        create: (_) => ProfileBloc(context.read<GetUserProfile>())
          ..add(LoadProfile(user.uid)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is ProfileError) {
                return Center(
                  child: Text('Error: ${state.message}'),
                );
              }
              if (state is ProfileLoaded) {
                final user = state.user;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    itemProfile('Name', user.username, Icons.person),
                    const SizedBox(height: 10),
                    itemProfile('Email', user.email, Icons.email),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorSys.secoundry,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                  ],
                );
              }
              return const Center(child: Text('No data available.'));
            },
          ),
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: ColorSys.secoundry,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: ColorSys.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
      ),
    );
  }}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/core/constand/ColorsSys.dart';
import 'package:secondproject/features/Profile/domain/usecases/get_user_profile.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_bloc.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_event.dart';
import 'package:secondproject/features/Profile/presentation/bloc/profile_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(
        child: Text('No user logged in.', style: TextStyle(fontSize: 16)),
      );
    }
context.read<ProfileBloc>().add(LoadProfile(user.uid));

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ProfileError) {
              return Center(
                child: Text('Error: ${state.message}'),
              );
            }
            if (state is ProfileLoaded) {
              final user = state.user;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  itemProfile('Name', user.username, Icons.person),
                  const SizedBox(height: 10),
                  itemProfile('Email', user.email, Icons.email),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorSys.secoundry,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              );
            }
            return const Center(child: Text('No data available.'));
          },
        ),
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: ColorSys.secoundry,
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(iconData, color: ColorSys.primary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(Icons.edit, color: Colors.grey),
      ),
    );
  }
}
