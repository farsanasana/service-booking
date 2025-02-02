
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:secondproject/features/home_logout/presentation/bloc/category/category_event.dart';
// import 'package:secondproject/features/home_logout/presentation/bloc/category/category_state.dart';

// class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
//   ServiceBloc() : super(ServiceLoading()) {
//     on<FetchServices>((event, emit) async {
//       final services = await _fetchServices();
//       emit(ServiceLoaded(services));
//     });
//     on<SearchService>((event, emit) async {
//       final services = await _fetchServices(query: event.query);
//       emit(ServiceLoaded(services));
//     });
//   }

//   Future<List<Map<String, dynamic>>> _fetchServices({String query = ""}) async {
//     final snapshot = await FirebaseFirestore.instance.collection('services').get();
//     final services = snapshot.docs.map((doc) => doc.data()).toList();
//     if (query.isNotEmpty) {
//       return services.where((service) => service['name'].toLowerCase().contains(query.toLowerCase())).toList();
//     }
//     return services;
//   }
// }