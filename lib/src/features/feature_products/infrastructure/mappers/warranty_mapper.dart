
import '../../domain/domain.dart';

class WarrantyMapper{

  static Warranty warrantyToJsonEntity(Map<String, dynamic> json){
    return Warranty(
      warrantyId: json["id"],
      warrantyProduct: json["warrantyProduct"],
      warrantyTime: json["days"],
    );
  }
}