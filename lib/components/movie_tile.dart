import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/pages/movie_info_page.dart';

import 'package:letterboxd/store/firebase_service/firestore_service.dart';

enum MovieListType { watchlist, recentWatch, list }

class MovieTile extends ConsumerWidget {
  final Map<String, dynamic> movie;
  final MovieListType listType;
  final String? uid;
  final String? listname;

  const MovieTile({
    super.key,
    required this.movie,
    required this.listType,
    this.uid,
    this.listname,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = FirestoreService();

    Future<void> handleDelete() async {
      final documentId = movie['documentId'];
      // if (documentId == null) return;

      try {
        switch (listType) {
          case MovieListType.watchlist:
            await firestoreService.deleteFromWatchlist(documentId, ref);
            break;
          case MovieListType.recentWatch:
            await firestoreService.deleteFromRecentWatch(documentId, ref);
            break;
          case MovieListType.list:
            print("dvd");
            await firestoreService.deleteFromList(
              uid!,
              listname!,
              Map<String, dynamic>.from(movie),
              ref,
            );

            break;
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${movie['Title']} Error removing from list: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieInfoPage(movieDetails: movie),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: SizedBox(
            width: 50,
            child: Image.network(
              movie['Poster'] ?? '',
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.movie,
                size: 50,
              ),
            ),
          ),
          title: Text(
            movie['Title'] ?? 'Unknown Title',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            movie['Year'] ?? 'Unknown Year',
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete,
                color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: handleDelete,
          ),
        ),
      ),
    );
  }
}
