
abstract class ServicesEvent {}

class LoadCategoriesAndServices extends ServicesEvent {}

class LoadCategories extends ServicesEvent {}

class LoadServicesByCategory extends ServicesEvent {
  final String categoryId;
  LoadServicesByCategory(this.categoryId);
}

class LoadAllServices extends ServicesEvent {}

class SearchQuery extends ServicesEvent {
  final String query;
  SearchQuery({required this.query});
}
