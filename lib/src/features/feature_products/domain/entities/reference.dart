
import '../domain.dart';

class Reference {
  final int referenceId;
  final String referenceName;
  final String skuReference;
  final String color;
  final String price;
  final String iva;
  final int stock;
  final List<MediaResourceReference> mediaResourcesReference;
  final List<CommentReference> commentsReference;

  Reference({
    required this.referenceId,
    required this.referenceName,
    required this.skuReference,
    required this.color,
    required this.price,
    required this.iva,
    required this.stock,
    required this.mediaResourcesReference,
    required this.commentsReference,
  });


}