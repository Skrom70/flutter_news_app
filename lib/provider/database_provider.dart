import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'models/arctile.dart';

class DatabaseProvider {
  late Database db;

  final tableName = 'Articles';

  Future<void> open() async {
    db = await openDatabase('news_app.db', version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      author TEXT,
      title TEXT,
      description TEXT,
      urlToImage TEXT,
      content TEXT,
      publishedAt TEXT,
      isLastLoaded INTEGER,
      isFavorite INTEGER)''');
    });
  }

  Future<Set<Article>> getAll() async {
    await open();
    List<Map> maps = await db.query(tableName, columns: [
      'id',
      'author',
      'title',
      'description',
      'urlToImage',
      'content',
      'publishedAt',
      'isLastLoaded',
      'isFavorite'
    ]);
    Set<Article> records = maps.map((e) => Article.fromMap(e)).toSet();
    return records;
  }

  Future<Set<Article>> getFavoriteNews() async {
    await open();
    List<Map> maps = await db.query(tableName,
        columns: [
          'id',
          'author',
          'title',
          'description',
          'urlToImage',
          'content',
          'publishedAt',
          'isLastLoaded',
          'isFavorite'
        ],
        where: 'isFavorite = 1');
    Set<Article> records = maps.map((e) => Article.fromMap(e)).toSet();
    return records;
  }

  Future<Article?> getItembyId(int id) async {
    await open();
    List<Map> maps = await db.query(tableName,
        columns: [
          'id',
          'author',
          'title',
          'description',
          'urlToImage',
          'content',
          'publishedAt',
          'isLastLoaded',
          'isFavorite'
        ],
        where: 'id = $id');
    if (maps.isNotEmpty) {
      return maps.map((e) => Article.fromMap(e)).toList().first;
    } else {
      return null;
    }
  }

  Future<Article> insert(Article article) async {
    await open();

    article.id = await db.insert(tableName, article.toMap());
    return article;
  }

  Future<Article> update(Article article) async {
    if (article.id != null) {
      await open();

      article.id = await db.update(tableName, article.toMap(),
          where: 'id = ${article.id ?? 0}');
    }
    return article;
  }

  Future<Article> delete(Article article) async {
    if (article.id != null) {
      await open();
      article.id = await db.delete(tableName, where: 'id = ${article.id ?? 0}');
    }
    return article;
  }

  Future<void> deleteAll() async {
    try {
      await open();
      await db.execute('DELETE FROM $tableName');
    } catch (e) {
      ErrorHint('An error has occurred');
    }
  }

  Future<void> close() async {
    await db.close();
  }
}
