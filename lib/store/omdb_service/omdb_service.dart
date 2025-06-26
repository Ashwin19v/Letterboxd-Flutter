import 'package:http/http.dart' as http;
import 'dart:convert';

class OmdbService {
  final String apiKey = 'c8d70e4d';
  Future<Map<String, dynamic>> fetchMovieByTitle(String query) async {
    if (query.isEmpty) {
      return {'Search': []};
    }

    try {
      final response = await http.get(
        Uri.parse('https://www.omdbapi.com/?s=$query&apikey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }

  Future<Map<String, dynamic>> fetchMovieById(String query) async {
    if (query.isEmpty) {
      return {'Search': []};
    }

    try {
      final response = await http.get(
        Uri.parse('https://www.omdbapi.com/?i=$query&apikey=$apiKey'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      throw Exception('Error fetching movies: $e');
    }
  }
}
