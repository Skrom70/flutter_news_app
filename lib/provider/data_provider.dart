import 'package:sqflite/sqflite.dart';
import 'models/arctile.dart';

class DataProvider {
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

  Future<List<Article>> getAll() async {
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
    List<Article> records = maps.map((e) => Article.fromMap(e)).toList();
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

  Future<List<Article>> getFavoriteItems() async {
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

    return maps.map((e) => Article.fromMap(e)).toList();
  }

  // Future<List[Article]> getLastLoadedItems() async {
  //   await open();
  // }

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

  Future<void> close() async {
    await db.close();
  }
}
