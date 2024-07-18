
class Banners {

  final int id;
  final String name;
  final String url;
  final int position;
  final String image;
  final String type;

  Banners({
    required this.id,
    required this.name,
    required this.url,
    required this.position,
    required this.image,
    required this.type,
  });

  Banners copyWith({
    int? id,
    String? name,
    String? url,
    int? position,
    String? image,
    String? type,
  }) {
    return Banners(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      position: position ?? this.position,
      image: image ?? this.image,
      type: type ?? this.type,
    );
  }


  @override
  String toString() {
    return 'Banner(id: $id, name: $name, url: $url, position: $position, image: $image, type: $type)';
  }

}