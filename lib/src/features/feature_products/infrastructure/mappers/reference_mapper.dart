
import 'package:wawamko/src/features/feature_products/domain/domain.dart';

import '../infrastructure.dart';

class ReferenceMapper {

  static Reference referenceToJsonEntity(Map<String, dynamic> json) {
    return Reference(
      referenceId: json["id"],
      referenceName: json["reference"],
      skuReference: json["sku"],
      color: json["color"],
      price: json["price"].toString(),
      iva: json["iva"].toString(),
      stock: json["qty"],
      isPrincipal: json["major"],
      rating: json["rating"],
      mediaResourcesReference: (json["images"] as List<dynamic>?)
          ?.map((x) => MediaResourceMapper.mediaResourceFromJsonToEntity(x))
          .toList() ?? [],
      commentsReference: (json["comments"] as List<dynamic>?)
          ?.map((x) => CommentMapper.commentFromJsonEntity(x))
          .toList() ?? [],
    );
  }
}