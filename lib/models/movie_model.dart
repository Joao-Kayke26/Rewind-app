class Movie {
  final int id;
  final String title;
  final String url;
  final String release;
  final String genre;
  final String duration;
  final String age;
  final String points;
  final String description;

  Movie({
    required this.id,
    required this.title,
    required this.url,
    required this.release,
    required this.genre,
    required this.duration,
    required this.age,
    required this.points,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      url: json['image'] ?? '',
      release: json['release'] ?? '',
      genre: json['genre'] ?? '',
      duration: json['duration'] ?? '',
      age: json['age']?.toString() ?? '',
      points: json['points']?.toString() ?? '',
      description: json['description'] ?? '',
    );
  }
}
