class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String category;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image'],
      category: json['category'],
    );
  }
}
