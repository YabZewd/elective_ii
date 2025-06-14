class Review {
  final String id;
  final int rating;
  final String comment;
  final String createdAt;
  final String? username;
  final String email;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.username,
    required this.email,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
      username: json['customer']['username'] as String?,
      email: json['customer']['email'] as String,
    );
  }
}
