import 'package:flutter/material.dart';

class ServiceImage extends StatelessWidget {
  final String imageUrl;

  const ServiceImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorPlaceholder();
              },
            )
          : _buildErrorPlaceholder(),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.image_not_supported, size: 48, color: Colors.grey[400]),
      ),
    );
  }
}
