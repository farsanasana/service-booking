


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';

class ServiceModel extends Service {
  ServiceModel({
    required String id,
    required String name,
    required String imageUrl,
    required String categoryid,
    required DateTime createdAt,
    required String description,
  })
 
  
   : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          categoryId: categoryid,
          createdAt: createdAt,
   
          description: description,
        
        );

  factory ServiceModel.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
   final data=doc.data();
    return ServiceModel(
  id: doc.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      categoryid: data['categoryid'] ?? '',

 description:data['description']??'',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'categoryid': categoryId,
      'createdAt': createdAt,

      'description':description,
    };
  }
}