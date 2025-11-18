import 'package:flutter/material.dart';

/// ------------------------------------------------------------
/// MOCK DOS MODELOS
/// ------------------------------------------------------------
class Movie {
  final String id;
  final String url;
  final String title;
  final String genre;
  final String age;
  final String duration;
  final String points;
  final String description;
  final String release;

  Movie({
    required this.id,
    required this.url,
    required this.title,
    required this.genre,
    required this.age,
    required this.duration,
    required this.points,
    required this.description,
    required this.release,
  });
}

/// ------------------------------------------------------------
/// MOCK DO SERVIÇO (NÃO PRECISA DE API)
/// ------------------------------------------------------------
class MovieService {
  Future<List<Movie>> getMovies() async {
    await Future.delayed(const Duration(milliseconds: 700));

    return [
      Movie(
        id: "1",
        url: "https://i.imgur.com/8QZ7e5O.jpeg",
        title: "Interestelar",
        genre: "Ficção",
        age: "12",
        duration: "2h 49m",
        points: "9.0",
        description:
        "Um grupo de astronautas viaja pelo espaço em busca de um novo lar para a humanidade.",
        release: "2014",
      ),
      Movie(
        id: "2",
        url: "https://i.imgur.com/Abd9W6g.jpeg",
        title: "Batman: O Cavaleiro das Trevas",
        genre: "Ação",
        age: "14",
        duration: "2h 32m",
        points: "9.1",
        description:
        "Batman enfrenta o Coringa em uma guerra psicológica mortal.",
        release: "2008",
      ),
      Movie(
        id: "3",
        url: "https://i.imgur.com/K9g5R8f.jpeg",
        title: "Duna",
        genre: "Ficção",
        age: "12",
        duration: "2h 35m",
        points: "8.4",
        description:
        "Uma jornada épica no planeta deserto Arrakis, onde há o recurso mais valioso do universo.",
        release: "2021",
      ),
    ];
  }
}

/// ------------------------------------------------------------
/// TELA DE DETALHES
/// ------------------------------------------------------------
class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(movie.url),
            ),
            const SizedBox(height: 20),

            Text(
              movie.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "${movie.genre} • ${movie.duration} • ${movie.age}+",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.star, color: Colors.amber[300], size: 26),
                const SizedBox(width: 6),
                Text(
                  movie.points,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Descrição",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              movie.description,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Lançamento: ${movie.release}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// TELA PRINCIPAL (HOME)
// 100% FUNCIONAL
/// ------------------------------------------------------------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadMovies();
  }

  Future<void> loadMovies() async {
    final result = await MovieService().getMovies();
    setState(() {
      movies = result;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Rewind",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.search, color: Colors.white, size: 28),
          ),
        ],
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: loadMovies,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //    ⭐ CARROSSEL
              SizedBox(
                height: 240,
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
                            builder: (_) => MovieDetailPage(movie: movie),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(movie.url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Todos os filmes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ⭐ GRID
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailPage(movie: movie),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            movie.url,
                            height: 140,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
