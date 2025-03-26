
import 'package:flutter/material.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/presentation/pages/servicedetails/servicesdetailspage.dart';

Widget buildServicesList(List<Service> services, BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: services.map((service) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceDetailsPage(service: service),
              ),
            );
          },
          child: Container(
            width: 140, // Increased width
            height: 160, // Added fixed height for uniformity
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (service.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      service.imageUrl,
                      height: 90, // Increased image height
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 90,
                          color: Colors.grey[200],
                          child: Icon(Icons.image_not_supported, size: 40),
                        );
                      },
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    service.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Made font size slightly larger
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}