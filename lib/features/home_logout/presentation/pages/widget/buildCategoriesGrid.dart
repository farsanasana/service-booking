
import 'package:flutter/material.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';

Widget buildCategoriesGrid(List<Category> categories, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: categories.map((category) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ServiceListPage(category: category),
              ),
            );
          },
          child: Container(
            width: 120, // Increased width
            height: 100, // Added height for better alignment
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14, // Increased font size
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}