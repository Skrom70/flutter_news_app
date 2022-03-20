import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/provider/database_provider.dart';
import 'package:http/http.dart' as http;
import 'models/arctile.dart';

class NewsProvider extends ChangeNotifier {
  final _apiKey = 'e564c593029346468ef219c9efbfe372';

  final _databaseProvider = DatabaseProvider();

  List<Article> articles = [];
  Set<Article> cachedArticles = {};

  String? get newsQuery => _newsQuery;
  String? _newsQuery = '';

  bool get getSearchingState => _isSearching;
  void changeSearingState({bool? value = null}) {
    _isSearching = value == null ? !_isSearching : value;
    _newsQuery = !_isSearching ? '' : _newsQuery;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<void> loadSearchArticles(String q) async {
    if (q != _newsQuery) {
      try {
        _newsQuery = q;
        final parameters = {'q': _newsQuery ?? ''};
        final headers = {'X-Api-Key': _apiKey};
        final response = await http.get(
            Uri.https('newsapi.org', '/v2/everything', parameters),
            headers: headers);
        if (response.statusCode == 200) {
          final respondeData =
              EverythingNews.fromJson(jsonDecode(response.body));
          this.articles = respondeData.articles;
          this._mergeCachedArticlesIntoLoaded();
          notifyListeners();
        } else {
          throw ErrorHint('Failed to load articles');
        }
      } catch (e) {
        throw ErrorHint('An error has occurred');
      }
    }
  }

  Future<void> loadTopArticles() async {
    try {
      final parameters = {'country': 'ua'};
      final headers = {'X-Api-Key': _apiKey};
      final response = await http.get(
          Uri.https('newsapi.org', '/v2/top-headlines', parameters),
          headers: headers);
      if (response.statusCode == 200) {
        final responseData = EverythingNews.fromJson(jsonDecode(response.body));
        this.articles = responseData.articles;
        this._mergeCachedArticlesIntoLoaded();
        notifyListeners();
      } else {
        throw ErrorHint('Failed to load articles');
      }
    } catch (e) {
      throw ErrorHint('An error has occurred');
    }
  }

  Future<void> fetchCachedArticles() async {
    try {
      this.cachedArticles = await _databaseProvider.getAll();
    } catch (e) {
      throw ErrorHint('An error has occurred');
    }
  }

  Future<void> updateArticle(Article element) async {
    try {
      if (element.id != null) {
        await _databaseProvider.update(element);
      } else {
        final newCachedItem = await _databaseProvider.insert(element);
        cachedArticles.add(newCachedItem);
        _mergeCachedArticlesIntoLoaded(cacheSet: {newCachedItem});
      }
    } catch (e) {
      throw ErrorHint('An error has occurred');
    }
  }

  void _mergeCachedArticlesIntoLoaded({Set<Article>? cacheSet = null}) {
    final Set<Article> chached =
        cacheSet != null ? cacheSet : this.cachedArticles;
    this.articles.forEach((loadedElement) {
      chached.forEach((cachedElement) {
        if (loadedElement == cachedElement) {
          loadedElement.id = cachedElement.id;
          loadedElement.isFavorite = cachedElement.isFavorite;
          loadedElement.isLastLoaded = cachedElement.isLastLoaded;
        }
      });
    });
  }
}
