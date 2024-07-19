import 'package:flutter/material.dart';

import '../../../feature_views_shared/domain/domain.dart';

class ItemBrand extends StatelessWidget {
  final Brand brand;
  final double size;

  const ItemBrand({
    Key? key,
    required this.brand,
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey, // Color de fondo en caso de error
      ),
      child: ClipOval(
        child: Image.network(
          brand.image ?? "",
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.error,
              color: Colors.white,
              size: size * 0.5,
            );
          },
        ),
      ),
    );
  }
}