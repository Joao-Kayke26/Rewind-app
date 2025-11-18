import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  double opacityPoster = 0;
  double opacityContent = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 150), () {
      setState(() => opacityPoster = 1);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() => opacityContent = 1);
    });
  }
  Color getAgeColor(String age) {
    switch (age) {
      case "L":
        return const Color(0xFF00C853);
      case "10":
        return const Color(0xFF2962FF);
      case "12":
        return const Color(0xFFFFD600);
      case "14":
        return const Color(0xFFFF6D00);
      case "16":
        return const Color(0xFFD50000);
      case "18":
        return const Color(0xFF424242);
      default:
        return Colors.white12;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Detalhes",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

      AnimatedOpacity(
      opacity: opacityPoster,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: Image.network(
          movie.url,
          width: double.infinity,
          height: 380,
          fit: BoxFit.cover,
    ),
    ),

    const SizedBox(height: 20),


    AnimatedOpacity(
    opacity: opacityContent,
    duration: const Duration(milliseconds: 700),
    curve: Curves.easeOut,
    child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Expanded(
    child: Text(
    movie.title,
    style: const TextStyle(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    Text(
    movie.release,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 18,
    ),
    ),
    ],
    ),

    const SizedBox(height: 10),


    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    movie.genre,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 16,
    ),
    ),

    Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
    color: getAgeColor(movie.age),
    borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
    movie.age,
    style: const TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    ],
    ),

    const SizedBox(height: 10),


    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    movie.duration,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 16,
    ),
    ),

    Row(
    children: List.generate(
    5,
    (i) => Icon(
    i < int.parse(movie.points)
    ? Icons.star
        : Icons.star_border,
    color: Colors.deepOrange,
    size: 22,
    ),
    ),
    ),
    ],
    ),

    const SizedBox(height: 20),


    Text(
    movie.description,
    style: const TextStyle(
    color: Colors.white70,
    fontSize: 16,
    height: 1.5,
    ),
    ),

    const SizedBox(height: 40),
    ],
    ),
    ),
    ),
    ],
    ),
    ),
    );
  }
}
