class Favorites {
  final String id;
  final String name;
  final int capacity;
  final String? description;
  final bool hasValet;
  final List<dynamic> images;
  final String location;

  Favorites({
    required this.id,
    required this.name,
    required this.capacity,
    required this.description,
    required this.hasValet,
    required this.images,
    required this.location,
  });

  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      id: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      description: json['description'],
      hasValet: json['hasValet'],
      images: List<dynamic>.from(json['images'] ?? []),
      location: json['location'] ?? '',
    );
  }
}
