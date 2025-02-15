
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/home_logout/data/models/service_model.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final FirebaseFirestore _firestore;

  ServicesRepositoryImpl(this._firestore);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      
     
      return snapshot.docs.map((doc) {
        final data = doc.data();
       
        
        return Category(
          id: doc.id,
          name: data['name'] as String? ?? '',
          createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e, stackTrace) {
      log('Error fetching categories', error: e, stackTrace: stackTrace);
      throw Exception('Failed to fetch categories: $e');
    }
  }

  @override

  Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Service(
          id: doc.id,
          categoryId: categoryId,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: $e');
    }
  }
@override
Future<List<Service>> getAllServices() async {
  try {
    log('Fetching all services from Firestore');

    // Step 1: Get all categories
    final categorySnapshot = await _firestore.collection('categories').get();
    
    List<Service> allServices = [];

    // Step 2: Loop through each category and get its services
    for (var categoryDoc in categorySnapshot.docs) {
      final categoryId = categoryDoc.id;
      
      final serviceSnapshot = await _firestore
          .collection('categories')
          .doc(categoryId)
          .collection('services')
          .get();
      
      final services = serviceSnapshot.docs.map((doc) {
        log('Processing document ${doc.id}: ${doc.data()}');
        return ServiceModel.fromFirestore(doc);
      }).toList();
      
      allServices.addAll(services);
    }

    log('Successfully fetched ${allServices.length} services');
    return allServices;
  } catch (e, stackTrace) {
    log('Error fetching all services', error: e, stackTrace: stackTrace);
    throw Exception('Failed to fetch all services: $e');
  }
}

}
