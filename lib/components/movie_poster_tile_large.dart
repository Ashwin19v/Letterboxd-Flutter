import 'package:flutter/material.dart';
import 'package:letterboxd/pages/movie_info_page.dart';

class MoviePosterTileLarge extends StatelessWidget {
  const MoviePosterTileLarge({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/movie-info');
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Card(
          color: Colors.white10,
          margin: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('lib/assets/images/poster1.jpg'),
                  fit: BoxFit.fitWidth,
                  height: 250,
                  width: 390,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
