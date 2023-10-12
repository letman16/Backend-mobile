import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:latihan_praktek/http_helper.dart';

class Screen1 extends StatefulWidget {
  const Screen1({Key? key}) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  late String result;
  late HttpHelper helper;
  String selectedCategory = 'now_playing';

  List<Map<String, dynamic>> movies = [];

  @override
  void initState() {
    super.initState();
    helper = HttpHelper();
    result = "";

    fetchMovies(selectedCategory);
  }

  Future<void> fetchMovies(String category) async {
    final String movieData = await helper.getMoviesByCategory(category);
    setState(() {
      result = movieData;
      final Map<String, dynamic> data = json.decode(result);
      final List<dynamic> movieResults = data['results'];

      // Mengisi list movies dengan data film dari JSON
      movies = List<Map<String, dynamic>>.from(movieResults);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Movie'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          DropdownButton<String>(
            value: selectedCategory,
            items: [
              'latest',
              'now_playing',
              'popular',
              'top_rated',
              'upcoming',
            ].map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedCategory = newValue;
                });
                fetchMovies(newValue);
              }
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(
                    movie['title'].toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(movie['overview'].toString()),
                      Row(
                        children: [
                          Text(movie['release_date'].toString()),
                          const Text("  |  "),
                          Text(movie['vote_average'].toString())
                        ],
                      )
                    ],
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
