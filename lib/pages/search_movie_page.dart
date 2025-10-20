import 'package:flutter/material.dart';

import 'package:letterboxd/pages/movie_info_page.dart';

import 'package:letterboxd/store/omdb_service/omdb_service.dart';
import 'package:letterboxd/utils/movie_data.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({super.key});

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  final _omdbService = OmdbService();
  final MovieDataService _movieDataService = MovieDataService();
  Map<String, dynamic>? _movieData;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    try {
      final data = await _movieDataService.loadMovieData();
      setState(() {
        _movieData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error loading movies: $e');
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _omdbService.fetchMovieByTitle(query);
      setState(() {
        _searchResults = result['Search'] ?? [];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching movies: $e')),
        );
      }
    }
  }

  Future<void> _navigateToMovieInfo(String imdbId) async {
    setState(() => _isLoading = true);

    try {
      final movieDetails = await _omdbService.fetchMovieById(imdbId);
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MovieInfoPage(movieDetails: movieDetails),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading movie details: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                searchMovies(value);
              },
              decoration: const InputDecoration(
                labelText: 'Search for movies',
                labelStyle: TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(96, 117, 116, 116)),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : _searchController.text.isNotEmpty && _searchResults.isEmpty
                      ? const Center(
                          child: Text(
                            'No results found',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.7,
                          children: _searchController.text.isEmpty
                              ? List.generate(
                                  _movieData!['popular_movies'].length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _navigateToMovieInfo(
                                          _movieData!['popular_movies'][index]
                                              ['imdb_id']);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _movieData!['popular_movies'][index]
                                                ['poster_url'] ??
                                            '',
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: Colors.grey,
                                          child: const Center(
                                            child: Text(
                                              'No Poster',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : List.generate(
                                  _searchResults.length,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      _navigateToMovieInfo(
                                          _searchResults[index]['imdbID']);
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        _searchResults[index]['Poster'] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                          color: Colors.grey,
                                          child: const Center(
                                            child: Text(
                                              'No Poster',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
