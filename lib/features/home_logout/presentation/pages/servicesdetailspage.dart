import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';

class ServiceDetailsPage extends StatelessWidget {
  
  final Service service;

  const ServiceDetailsPage({
    Key? key, 
  
    required this.service,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Details'),
        backgroundColor: Colors.white,
        elevation: 0,  leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
        ],
      ),
      body: BlocBuilder<ServicesBloc, ServicesState>(
        builder: (context, state) {
          if (state is ServicesLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ServicesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ServicesBloc>()
                        .add(LoadServicesByCategory(service.categoryId!));
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceImage(),
                _buildServiceInfo(context),
                _buildServiceDescription(),
                _buildPriceAndBooking(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceImage() {
    return Container(
      height: 250,
      width: double.infinity,
      child: service.imageUrl.isNotEmpty
          ? Image.network(
              service.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                );
              },
            )
          : Container(
              color: Colors.grey[200],
              child: Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 48,
                  color: Colors.grey[400],
                ),
              ),
            ),
    );
  }

  Widget _buildServiceInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.name,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 20, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Category: ${service.categoryId}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            service.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 24),
          // Add any additional service details here
        ],
      ),
    );
  }

  Widget _buildPriceAndBooking(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Price',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'AED ${service.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _showBookingConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 48),
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Book Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Booking',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'You are about to book:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              service.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'AED ${service.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement booking logic
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Booking confirmed!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                    ),
                    child: Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}