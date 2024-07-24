
class Warranty {
  final int warrantyId;
  final String warrantyProduct;
  final int warrantyTime;

  Warranty({
    required this.warrantyId,
    required this.warrantyProduct,
    required this.warrantyTime
  });

  @override
  String toString() {
    return 'Warranty(id: $warrantyId, warrantyProduct: $warrantyProduct, warrantyTime: $warrantyTime)';
  }

}