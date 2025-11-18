class Movie {
  final String id;
  final String url;
  final String title;
  final String genre;
  final String age;
  final String duration;
  final String? points;
  final String description;
  final String release;

  Movie({
    required this.id,
    required this.url,
    required this.title,
    required this.genre,
    required this.age,
    required this.duration,
    this.points,
    required this.description,
    required this.release,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      url: json['url'],
      title: json['title'],
      genre: json['genre'],
      age: json['age'],
      duration: json['duration'],
      points: json['points'],
      description: json['description'],
      release: json['release'],
    );
  }
}
