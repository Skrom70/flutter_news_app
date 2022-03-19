import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'models/arctile.dart';

class NewsProvider {
  final _apiKey = 'e564c593029346468ef219c9efbfe372';

  Future<dynamic> fetchSearchArticles(String q) async {
    final parameters = {'q': q};
    final headers = {'X-Api-Key': _apiKey};
    final response = await http.get(
        Uri.https('newsapi.org', '/v2/everything', parameters),
        headers: headers);
    if (response.statusCode == 200) {
      return EverythingNews.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }

  Future<dynamic> fetchTopArticles() async {
    final parameters = {'country': 'ua'};
    final headers = {'X-Api-Key': _apiKey};
    final response = await http.get(
        Uri.https('newsapi.org', '/v2/top-headlines', parameters),
        headers: headers);
    if (response.statusCode == 200) {
      return EverythingNews.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
