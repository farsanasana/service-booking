import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';

class SearchQuery extends ServicesEvent {
  final String query;
  final bool isCategory;

  SearchQuery({required this.query, this.isCategory = true});
}

class ServiceSearchState extends ServicesState {
  final List<Service> filteredServices;
  final String searchQuery;
  
  ServiceSearchState(this.filteredServices, this.searchQuery);
}
