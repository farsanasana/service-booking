

  import 'package:flutter/material.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';
import 'package:secondproject/features/home_logout/presentation/pages/servicedetails/servicesdetailspage.dart';

Widget buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }