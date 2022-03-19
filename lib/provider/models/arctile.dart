class Article {
  late final int? id;
  final String? author;
  final String? title;
  final String? description;
  final String? urlToImage;
  final String? content;
  final String? publishedAt;
  bool isLastLoaded;
  bool isFavorite;

  Article(
      {this.id = null,
      required this.author,
      required this.title,
      required this.description,
      required this.urlToImage,
      required this.content,
      required this.publishedAt,
      this.isLastLoaded = false,
      this.isFavorite = false});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'author': author,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'publishedAt': publishedAt,
      'isLastLoaded': isLastLoaded ? 1 : 0,
      'isFavorite': isFavorite ? 1 : 0
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Article.fromMap(Map<dynamic, dynamic> map) {
    return Article(
        id: map['id'],
        author: map['author'],
        title: map['title'],
        description: map['description'],
        urlToImage: map['urlToImage'],
        content: map['author'],
        publishedAt: map['author'],
        isLastLoaded: map['isLastLoaded'] == 1 ? true : false,
        isFavorite: map['isFavorite'] == 1 ? true : false);
  }
}

class EverythingNews {
  final String status;
  final List<Article> articles;

  const EverythingNews({
    required this.status,
    required this.articles,
  });

  factory EverythingNews.fromJson(Map<String, dynamic> json) {
    final articles = (json['articles'] as List<dynamic>)
        .map<Article>((e) => Article(
            author: e['author'],
            title: e['title'],
            description: e['description'],
            urlToImage: e['urlToImage'],
            content: e['content'],
            publishedAt: e['publishedAt']))
        .toList();
    return EverythingNews(
      status: json['status'],
      articles: articles,
    );
  }
}
