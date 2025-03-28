import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';


class ServiceModel extends Service {
  ServiceModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required String super.categoryId,
    required super.description,
    required super.createdAt,
    required super.price,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ServiceModel(
      
      id: doc.id,
      name: data['name']?.toString() ?? '',
      imageUrl: data['imageUrl']?.toString() ?? '',
      categoryId: data['categoryId']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'price': price,
    };
  }
}