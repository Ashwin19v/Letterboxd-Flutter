import 'package:flutter/material.dart';
import 'package:letterboxd/pages/movie_info_page.dart';

class MoviePosterTile extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MoviePosterTile({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    if (movie['Title'] == null || movie['Poster'] == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieInfoPage(movieDetails: movie),
          ),
        );
      },
      child: SizedBox(
        width: 150,
        child: Card(
          color: Colors.white10,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                movie['Poster']!,
                fit: BoxFit.fill,
                height: 150,
                width: 150,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  width: 150,
                  color: Colors.grey[800],
                  child: const Icon(Icons.movie, color: Colors.white),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['Title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (movie['Year'] != null)
                      Text(
                        '(${movie['Year']})',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
