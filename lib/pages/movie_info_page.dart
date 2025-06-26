import 'package:flutter/material.dart';
import 'package:letterboxd/pages/add_review_page.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';
import 'package:letterboxd/store/firebase_service/firestore_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../store/firebase_service/firestore_provider.dart';

class MovieInfoPage extends ConsumerWidget {
  final Map<String, dynamic> movieDetails;
  MovieInfoPage({
    super.key,
    required this.movieDetails,
  });
  final firebaseService = FirestoreService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authControllerProvider);
    final String? uid = currentUser?.uid;
    return Scaffold(
      appBar: AppBar(
        title: Text(movieDetails['Title'] ?? 'Movie Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  movieDetails['Poster'] ?? '',
                  height: 150,
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: 100,
                    color: Colors.grey,
                    child: const Icon(Icons.movie, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${movieDetails['Title']} (${movieDetails['Year']})',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movieDetails['Director'] ?? 'Unknown Director',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movieDetails['Genre']} ',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${movieDetails['Runtime']} | ${movieDetails['Rated']}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Synopsis:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              style: const TextStyle(fontSize: 16, color: Colors.white70),
              movieDetails['Plot'] ?? 'No synopsis available.',
            ),
            const SizedBox(height: 20),
            const Text(
              'Cast:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              movieDetails['Actors'] ?? 'No cast information available.',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Release Date:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movieDetails['Released'] ?? 'Unknown Release Date',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'IMDB Ratings:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          movieDetails['imdbRating'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                            fontWeight: FontWeight.w900),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                          double rating = 0.0;
                          try {
                            rating = double.parse(movieDetails['imdbRating'] ?? '0') / 2;
                          } catch (_) {}
                          if (rating >= index + 1) {
                            return const Icon(Icons.star, color: Colors.yellow);
                          } else if (rating > index && rating < index + 1) {
                            return const Icon(Icons.star_half, color: Colors.yellow);
                          } else {
                            return const Icon(Icons.star_border, color: Colors.yellow);
                          }
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFFB300), // Muted Amber
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (uid != null) {
                            firebaseService.addToWatchlist(
                                uid, movieDetails, ref);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Added to Watchlist!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User not logged in.')),
                            );
                          }
                        },
                        child: const SizedBox(
                          width: 160,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add to Watchlist',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF00C853), // Emerald Green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (uid != null) {
                            firebaseService.addToRecentWatch(
                                uid, movieDetails, ref);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Added to recent watches!')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User not logged in.')),
                            );
                          }
                        },
                        child: const SizedBox(
                          width: 160,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Mark as Watched',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF40C4FF), // Steel Blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        // Replace the existing onPressed with this:
                        onPressed: () async {
                          if (uid == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('User not logged in.')),
                            );
                            return;
                          }

                          final userLists = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: const Color(0xFF1F1F1F),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            builder: (BuildContext context) {
                              return Consumer(
                                builder: (context, ref, child) {
                                  final listsAsync = ref.watch(getUserLists);

                                  return listsAsync.when(
                                    data: (lists) {
                                      if (lists.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'No lists found',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Show dialog to create new list
                                                  final TextEditingController
                                                      controller =
                                                      TextEditingController();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          const Color(
                                                              0xFF2F2F2F),
                                                      title: const Text(
                                                          'Create New List',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                      content: TextField(
                                                        controller: controller,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              'Enter list name',
                                                          hintStyle: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (controller.text
                                                                .isNotEmpty) {
                                                              Navigator.pop(
                                                                  context);
                                                              Navigator.pop(
                                                                  context,
                                                                  controller
                                                                      .text);
                                                            }
                                                          },
                                                          child: const Text(
                                                              'Create'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                    'Create New List'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: lists.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == lists.length) {
                                            return ListTile(
                                              leading: const Icon(Icons.add,
                                                  color: Colors.blue),
                                              title: const Text(
                                                'Create New List',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              onTap: () {
                                                final TextEditingController
                                                    controller =
                                                    TextEditingController();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        const Color(0xFF2F2F2F),
                                                    title: const Text(
                                                        'Create New List',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    content: TextField(
                                                      controller: controller,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            'Enter list name',
                                                        hintStyle: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (controller.text
                                                              .isNotEmpty) {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.pop(
                                                                context,
                                                                controller
                                                                    .text);
                                                          }
                                                        },
                                                        child: const Text(
                                                            'Create'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          }

                                          final list = lists[index];
                                          return ListTile(
                                            leading: const Icon(Icons.list,
                                                color: Colors.white),
                                            title: Text(
                                              list['listName'] ??
                                                  'Untitled List',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () => Navigator.pop(
                                                context, list['listName']),
                                          );
                                        },
                                      );
                                    },
                                    loading: () => const Center(
                                        child: CircularProgressIndicator()),
                                    error: (error, stack) => Center(
                                      child: Text('Error: $error',
                                          style: const TextStyle(
                                              color: Colors.red)),
                                    ),
                                  );
                                },
                              );
                            },
                          );

                          if (userLists != null) {
                            try {
                              await firebaseService.addToList(
                                  uid, userLists, movieDetails, ref);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Added to $userLists')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          }
                        },
                        child: const SizedBox(
                          width: 160,
                          child: Row(
                            children: [
                              Icon(
                                Icons.collections,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add to Collection',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFFF6D6D), // Coral/Salmon
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddReviewPage(movieDetails: movieDetails),
                            ),
                          );
                        },
                        child: const SizedBox(
                          width: 160,
                          child: Row(
                            children: [
                              Icon(
                                Icons.rate_review,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Rate or Review',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
