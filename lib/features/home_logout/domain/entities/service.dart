class Service {
  final String id;
  final String name;
  final String imageUrl;
  final String ?categoryId;
  final String description;
  final DateTime createdAt;
  final double price;

  Service({
    required this.id,
    required this.name,
    required this.imageUrl,
     this.categoryId,
    required this.description,
    required this.createdAt,
    required this.price,
  });
}