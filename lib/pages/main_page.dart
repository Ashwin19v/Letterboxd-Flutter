import 'package:flutter/material.dart';
import 'package:letterboxd/pages/movie_info_page.dart';
import 'package:letterboxd/store/omdb_service/omdb_service.dart';
import 'package:letterboxd/utils/movie_data.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MovieDataService _movieDataService = MovieDataService();
  final _omdbService = OmdbService();
  Map<String, dynamic>? _movieData;
  bool _isLoading = true;

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

  Widget _buildMovieList(String title, List<dynamic> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 191, 191, 191),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            wordSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              if (movie == null || movie['imdb_id'] == null) {
                return const SizedBox.shrink();
              }
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _navigateToMovieInfo(movie['imdb_id']);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            movie['poster_url'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(Icons.movie, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie['title'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      movie['release_year'].toString(),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome to Letterboxd!',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(179, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        wordSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_movieData != null) ...[
                      _buildMovieList(
                          'Popular Movies', _movieData!['popular_movies']),
                      const SizedBox(height: 30),
                      _buildMovieList("Marvel's Avengers",
                          _movieData!["Marvel's Avengers"]),
                      const SizedBox(height: 30),
                      _buildMovieList('Go back to Childhood',
                          _movieData!['Go back to Childhood']),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
