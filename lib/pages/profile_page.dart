import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/store/firebase_service/firestore_provider.dart';
import 'package:letterboxd/components/movie_poster_tile.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    print('User: $user');
    final userReviewsAsync = ref.watch(userReviewProvider);
    final userWatchlist = ref.watch(watchlistProvider);
    final userRecent = ref.watch(recentWatchProvider);
    final userList = ref.watch(getUserLists);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                ref.read(authControllerProvider.notifier).logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
                Navigator.pushReplacementNamed(context, '/login');
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $error')),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null &&
                            user?.displayName?.isNotEmpty == true
                        ? Text(
                            user!.displayName![0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? " ",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user?.email ?? 'No Email',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      '${userReviewsAsync.asData?.value.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text('Reviews'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${userList.asData?.value.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text('Lists'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${userWatchlist.asData?.value.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text('Watchlist'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${userRecent.asData?.value.length ?? 0}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text('Watched'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Movies You Rated  ⭐',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 230,
              child: userReviewsAsync.when(
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return const Center(
                      child: Text(
                        'No rated movies yet',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      if (review['Title'] == null || review['Poster'] == null) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: MoviePosterTile(movie: review),
                      );
                    },
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
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: const EdgeInsets.all(20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 40.0, horizontal: 30.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.movie_creation_rounded,
                                color: Colors.white,
                                size: 100,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'New Update Arriving Soon...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(
                                      'lib/assets/images/poster1.jpg'),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'About Us',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'This app is developed by movie enthusiasts for movie lovers. '
                              'Discover, rate, and share your favorite films with the community!',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Row(
                              children: [
                                Icon(Icons.upcoming, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Future Enhancements',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              '• AI-based movie recommendations\n'
                              '• Real-time chat rooms for discussions\n'
                              '• Personalized watchlists and reminders\n'
                              '• Offline mode support\n'
                              '• Dark/light theme toggle\n'
                              '• Integration with IMDB and TMDB APIs\n'
                              '• User-generated movie quizzes',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  height: 1.5),
                            ),
                          ],
                        ),
                      ),
                    ),
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
