import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      children: [
        Image.asset("assets/images/abban_logo.png", height: 32),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                context.read<ServicesBloc>().add(SearchQuery(query: query));
              },
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
      ],
    ),
    backgroundColor: Colors.white,
    elevation: 0,
  );
}
