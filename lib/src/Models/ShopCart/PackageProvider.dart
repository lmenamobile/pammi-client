import 'package:wawamko/src/Models/ShopCart/PackageCart.dart';
import 'package:wawamko/src/Models/ShopCart/ProductShopCart.dart';

import 'ProviderProduct.dart';


class PackagesProvider {
  PackagesProvider({
    this.provider,
    this.products,
    this.cart,
    this.shippingValue,
    this.freeShipping,
  });

  ProviderProduct? provider;
  List<ProductShopCart>? products;
  PackageCart? cart;
  num? shippingValue;
  num? freeShipping;

  factory PackagesProvider.fromJson(Map<String, dynamic> json) => PackagesProvider(
    provider: ProviderProduct.fromJson(json["provider"]),
    products: List<ProductShopCart>.from(json["products"].map((x) => ProductShopCart.fromJson(x))),
    cart: json["cart"] == null ? null : PackageCart.fromJson(json["cart"]),
    shippingValue: json["shippingValue"] == null ? null : json["shippingValue"],
    freeShipping: json["freeShipping"] == null ? null : json["freeShipping"],
  );

  Map<String, dynamic> toJson() => {
    "provider": provider!.toJson(),
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "cart": cart == null ? null : cart!.toJson(),
    "shippingValue": shippingValue == null ? null : shippingValue,
    "freeShipping": freeShipping == null ? null : freeShipping,
  };
}