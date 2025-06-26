import 'dart:convert';
import 'package:flutter/services.dart';

class MovieDataService {
  Future<Map<String, dynamic>> loadMovieData() async {
    final String jsonString =
        await rootBundle.loadString('lib/utils/data.json');
    return json.decode(jsonString);
  }
}
