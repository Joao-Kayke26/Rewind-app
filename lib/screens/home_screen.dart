import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/movie_model.dart';
import 'movie_detail_screen.dart';
import 'movie_form_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _api = ApiService();
  final _auth = AuthService();

  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _refreshMovies();
  }

  void _refreshMovies() {
    setState(() {
      _moviesFuture = _api.fetchMovies();
    });
  }

  void _handleDelete(String movieId) async {
    final success = await _api.deleteMovie(movieId);
    if (success) {
      _refreshMovies();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Filme deletado com sucesso!"), backgroundColor: Colors.red),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao deletar filme."), backgroundColor: Colors.red),
        );
      }
    }
  }

  Widget _buildListItem(Movie movie) {
    final double rating = double.tryParse(movie.points) ?? 0;

    return Dismissible(
      key: Key(movie.id),
      direction: DismissDirection.endToStart,

      background: Container(
        color: Colors.red.shade900,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete_forever, color: Colors.white, size: 36),
      ),

      onDismissed: (direction) {
        _handleDelete(movie.id);
      },

      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MovieDetailScreen(movie: movie),
              ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  movie.url,
                  width: 70,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.red,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${movie.genre} - ${movie.duration}',
                      style: const TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    RatingBar.builder(
                      initialRating: rating,
                      minRating: 0,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      itemPadding: EdgeInsets.zero,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.red,
                      ),
                      onRatingUpdate: (v) {},
                      ignoreGestures: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text(
          "Filmes",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white, size: 30),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Equipe:"),
                      content: const Text(
                        "Ariel Lucas\n"
                            "Gabryel Araujo\n"
                            "Joao Kayke\n"
                            "Victor Albuquerque",
                        style: TextStyle(fontSize: 16, height: 1.5),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Erro ao carregar filmes. Verifique a API.',
                    style: const TextStyle(color: Colors.red)));
          }

          final movies = snapshot.data ?? [];

          if (movies.isEmpty) {
            return const Center(
              child: Text('Nenhum filme cadastrado.',
                  style: TextStyle(color: Colors.white70)),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _refreshMovies(),
            color: Colors.red,
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return _buildListItem(movies[index]);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MovieFormScreen(),
            ),
          );
          if (result == true) {
            _refreshMovies();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}