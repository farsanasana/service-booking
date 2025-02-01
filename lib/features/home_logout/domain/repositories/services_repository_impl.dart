import 'package:cloud_firestore/cloud_firestore.dart';
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
      
        if (snapshot.docs.isEmpty) {
        return [];
      }
      return snapshot.docs.map((doc) => Category(
        id: doc.id,
        name: doc['name'],
        imageUrl: doc['imageUrl'],
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories');
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('services')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      return snapshot.docs.map((doc) => Service(
        id: doc.id,
        name: doc['name'],
        imageUrl: doc['imageUrl'],
        categoryId: doc['categoryId'],
              description: doc['description'],
         createdAt: (doc['createdAt'] as Timestamp).toDate()
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch services');
    }
  }
}