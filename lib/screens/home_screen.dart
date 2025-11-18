import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/movie_model.dart';
import 'movie_detail_screen.dart';

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
    _moviesFuture = _loadMockMovies();
  }


  Future<List<Movie>> _loadMockMovies() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Movie(
        id: 1,
        url: "https://picsum.photos/200/300?random=1",
        title: "Interstellar",
        genre: "Ficção Científica",
        age: "12",
        duration: "2h30",
        points: "5",
        description: "Uma jornada épica através do espaço e do tempo.",
        release: "2014",
      ),
      Movie(
        id: 2,
        url: "https://picsum.photos/200/300?random=2",
        title: "Vingadores",
        genre: "Ação",
        age: "12",
        duration: "2h15",
        points: "4",
        description: "Os heróis mais poderosos da Terra enfrentam Loki.",
        release: "2012",
      ),
      Movie(
        id: 3,
        url: "https://picsum.photos/200/300?random=3",
        title: "O Rei Leão",
        genre: "Animação",
        age: "L",
        duration: "1h50",
        points: "5",
        description: "A jornada de Simba para se tornar o rei.",
        release: "1994",
      ),
      Movie(
        id: 4,
        url: "https://picsum.photos/200/300?random=4",
        title: "Duna 2",
        genre: "Ficção Científica",
        age: "14",
        duration: "2h40",
        points: "5",
        description: "A continuação épica baseada no livro clássico.",
        release: "2024",
      ),
      Movie(
        id: 5,
        url: "https://picsum.photos/200/300?random=5",
        title: "Avatar",
        genre: "Fantasia",
        age: "12",
        duration: "2h42",
        points: "4",
        description: "Jake Sully precisa defender Pandora mais uma vez.",
        release: "2009",
      ),
    ];
  }


  void _logout() async {
    await _auth.logout();
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Catálogo de Filmes",
          style: TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.account_circle,
              color: Colors.deepOrange,
              size: 32,
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepOrange),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erro ao carregar filmes: ${snapshot.error}",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final movies = snapshot.data ?? [];

          final categories = movies.map((m) => m.genre).toSet();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((genre) {
                final filtered = movies
                    .where((m) => m.genre == genre)
                    .toList();
                return _buildMovieSection(genre, filtered);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMovieSection(String category, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.deepOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                  child: Container(
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            movie.url,
                            fit: BoxFit.cover,
                            width: 130,
                            height: 160,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                                  Icons.broken_image,
                                  color: Colors.deepOrange,
                                  size: 60,
                                ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
