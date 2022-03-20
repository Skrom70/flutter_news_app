import 'package:flutter/material.dart';
import 'package:flutter_news_app/provider/database_provider.dart';
import 'package:flutter_news_app/provider/models/arctile.dart';

class NewsFavoriteProvider extends ChangeNotifier {
  final _databaseProvider = DatabaseProvider();

  Set<Article> articles = {};

  Future<void> load() async {
    try {
      this.articles = await _databaseProvider.getFavoriteNews();
      notifyListeners();
    } catch (e) {
      throw ErrorHint('An error has occurred');
    }
  }

  Future<void> remote(Article element) async {
    try {
      _databaseProvider.update(element);
      this.articles.remove(element);
      notifyListeners();
    } catch (e) {
      throw ErrorHint('An error occurred');
    }
  }
}
