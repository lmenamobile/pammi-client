
class Warranty {
  final int id;
  final String warrantyProduct;
  final int warrantyTime;

  Warranty({
    required this.id,
    required this.warrantyProduct,
    required this.warrantyTime
  });

  @override
  String toString() {
    return 'Warranty(id: $id, warrantyProduct: $warrantyProduct, warrantyTime: $warrantyTime)';
  }

}