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
  required this.url,
  required this.title,
  required this.release,
  required this.genre,
  required this.duration,
  required this.age,
  required this.points,
  required this.description,
});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      url: json['url'],
      title: json['title'],
      genre: json['genre'],
      age: json['age'],
      duration: json['duration'],
      points: json['points'],
      description: json['description'],
      release: json['release']
    );
  }
}
