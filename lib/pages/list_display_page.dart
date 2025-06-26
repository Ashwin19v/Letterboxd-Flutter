import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/components/movie_tile.dart';
import 'package:letterboxd/store/firebase_service/firestore_provider.dart';

class ListDisplayPage extends ConsumerStatefulWidget {
  final String listName;
  final String uid;

  const ListDisplayPage({
    super.key,
    required this.listName,
    required this.uid,
  });

  @override
  ConsumerState<ListDisplayPage> createState() => _ListDisplayPageState();
}

class _ListDisplayPageState extends ConsumerState<ListDisplayPage> {
  bool isSearching = false;
  String searchQuery = '';

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
    final listMovies = ref.watch(getListByName(widget.listName));

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
            : Text(widget.listName),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = ''; // Clear search when closing
                }
              });
            },
          ),
        ],
      ),
      body: listMovies.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies in this list yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final filteredMovies =
              _filterMovies(movies.cast<Map<String, dynamic>>());

          if (filteredMovies.isEmpty && searchQuery.isNotEmpty) {
            return Center(
              child: Text(
                'No movies found matching "$searchQuery"',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
              return MovieTile(
                movie: movie,
                listType: MovieListType.list,
                uid: widget.uid,
                listname: widget.listName,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child:
              Text('Error: $error', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
