import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<Movie> _favorites = [];

  List<Movie> get favorites => _favorites;

  void toggleFavorite(Movie movie) {
    final exists = _favorites.any((m) => m.id == movie.id);

    if (exists) {
      _favorites.removeWhere((m) => m.id == movie.id);
    } else {
      _favorites.add(movie);
    }

    notifyListeners();
  }

  bool isFavorite(Movie movie) {
    return _favorites.any((m) => m.id == movie.id);
  }
}
