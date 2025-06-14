class Lots {
  final String id;
  final String name;
  final String? address;
  final double longitude;
  final double latitude;
  final String? description;
  final bool hasValet;
  // final double? rating;
  final double? distance;
  final List<dynamic> images;
  final bool isFavorite;

  Lots({
    required this.id,
    required this.name,
    this.address,
    required this.longitude,
    required this.latitude,
    this.description,
    required this.hasValet,
    // this.rating,
    this.distance,
    required this.images,
    this.isFavorite = false,
  });

  factory Lots.fromJson(Map<String, dynamic> json) {
    return Lots(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      longitude: (json['longitude'] ?? 0).toDouble(),
      latitude: (json['latitude'] ?? 0).toDouble(),
      description: json['description'] as String?,
      hasValet: json['hasValet'] as bool,
      // rating:
      //     json['rating'] == null ? null : (json['rating'] as num).toDouble(),
      distance: json['distance'] != null
          ? (json['distance'] as num).toDouble()
          : null,
      images: json['images'] as List<dynamic>,
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
