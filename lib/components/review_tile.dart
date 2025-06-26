import 'package:flutter/material.dart';
import 'package:letterboxd/pages/review_page.dart';

class ReviewTile extends StatelessWidget {
  final Map<String, dynamic> review;

  const ReviewTile({
    super.key,
    required this.review,
  });

  String _formatRating(double rating) {
    return '★' * rating.round() + '☆' * (5 - rating.round());
  }

  @override
  Widget build(BuildContext context) {
    final double rating = (review['rating'] ?? 0).toDouble();
    final String reviewText = review['review'] ?? 'No review text';
    final String movieTitle = review['Title'] ?? 'Unknown Movie';
    final String reviewerName = review['uid'] ?? 'Anonymous';

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(review['Poster'] ?? ''),
                onBackgroundImageError: (_, __) {
                  // Fallback for failed image load
                },
                child: review['Poster'] == null
                    ? const Icon(Icons.movie, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movieTitle,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      "Reviewed by: $reviewerName",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Review Text
          Text(
            reviewText.length > 100
                ? '${reviewText.substring(0, 100)}...'
                : reviewText,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white70,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12.0),

          // Rating and Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rating: ${_formatRating(rating)}',
                style: const TextStyle(color: Colors.yellowAccent),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(review: review),
                    ),
                  );
                },
                child: const Text(
                  'Read More',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
