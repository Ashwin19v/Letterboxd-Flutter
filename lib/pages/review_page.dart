import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:letterboxd/pages/movie_info_page.dart';
import 'package:letterboxd/store/auth/auth_controller.dart';
import 'package:letterboxd/store/firebase_service/firestore_service.dart';

class ReviewPage extends ConsumerWidget {
  final Map<String, dynamic> review;

  const ReviewPage({
    super.key,
    required this.review,
  });

  String _formatRating(double rating) {
    return '★' * rating.round() + '☆' * (5 - rating.round());
  }

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return "${_monthName(parsedDate.month)} ${parsedDate.day}, ${parsedDate.year}";
    } catch (e) {
      return date;
    }
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return (month >= 1 && month <= 12) ? months[month - 1] : '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firestoreService = FirestoreService();
    final currentUser = ref.watch(authControllerProvider);
    final isCurrentUserReview = currentUser?.uid == review['uid'];
    final double rating = (review['rating'] ?? 0).toDouble();
    final String reviewText = review['review'] ?? 'No review text';
    final String movieTitle = review['Title'] ?? 'Unknown Movie';
    // final String reviewerName = review['uid'] ?? 'Anonymous';
    final String year = review['Year'] ?? '';
    final String watchDate = review['watchedDate'] ?? 'Unknown date';
    final String reviewedBy = review['reviewBy'];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '$movieTitle ($year)',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          if (isCurrentUserReview) ...[
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final documentId = review['documentId'];
                if (documentId == null) return;

                final shouldDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Review'),
                    content: const Text(
                        'Are you sure you want to delete this review?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
                if (shouldDelete == true && context.mounted) {
                  try {
                    await firestoreService.deleteReview(documentId, ref);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Review deleted successfully')),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting review: $e')),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieInfoPage(movieDetails: review),
                      ),
                    );
                  },
                  child: Image.network(
                    review['Poster'] ?? '',
                    height: 300.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[800],
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie, size: 60, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            movieTitle,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Review Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Review by',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              reviewedBy,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Watched on',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatDate(watchDate),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Rating: ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _formatRating(rating),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.amber,
                            letterSpacing: 2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$rating/5.0',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      reviewText,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
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
