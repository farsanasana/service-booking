

abstract class ServicesEvent {}

class LoadCategories extends ServicesEvent {}

class LoadServicesByCategory extends ServicesEvent {
  final String categoryId;

  LoadServicesByCategory(this.categoryId);
}