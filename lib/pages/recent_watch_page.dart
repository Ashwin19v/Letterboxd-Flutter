import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/components/movie_tile.dart';
import 'package:letterboxd/store/firebase_service/firestore_provider.dart';

class RecentWatchPage extends ConsumerStatefulWidget {
  const RecentWatchPage({super.key});

  @override
  ConsumerState<RecentWatchPage> createState() => _RecentWatchPageState();
}

class _RecentWatchPageState extends ConsumerState<RecentWatchPage> {
  String searchQuery = '';
  bool isSearching = false;

  List<Map<String, dynamic>> _filterMovies(List<Map<String, dynamic>> movies) {
    if (searchQuery.isEmpty) return movies;
    return movies.where((movie) {
      final title = (movie['Title'] ?? '').toString().toLowerCase();
      final year = (movie['Year'] ?? '').toString().toLowerCase();
      final query = searchQuery.toLowerCase();

      return title.contains(query) || year.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final recentWatchesAsync = ref.watch(recentWatchProvider);
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) => setState(() => searchQuery = value),
              )
            : const Text('Recent Watches'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: recentWatchesAsync.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'You have not watched any movies recently',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          final filteredMovies = _filterMovies(movies);

          if (filteredMovies.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Text(
                'No movies found for "$searchQuery"',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];
                return MovieTile(
                    movie: movie, listType: MovieListType.recentWatch);
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
