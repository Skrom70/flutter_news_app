import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/news/items/news_item.dart';
import 'package:flutter_news_app/provider/news_provider.dart';
import '../../provider/auth_provider.dart';
import '../../provider/models/arctile.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<dynamic> futureNews;
  bool _isSearching = false;
  String? _newsQuery = null;
  final _searchFieldController = TextEditingController();
  final _gridController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureNews = NewsProvider().fetchTopArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: _isSearching ? Icon(Icons.close) : Icon(Icons.search),
          onPressed: _searchButtonTapped,
        ),
        title: _isSearching
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: TextField(
                    controller: _searchFieldController,
                    onSubmitted: _searchFieldSubmitted,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        fillColor: Colors.white.withOpacity(0.2),
                        filled: true,
                        border: InputBorder.none,
                        hintText: 'search',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)))),
              )
            : Text('News App'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: FutureBuilder<dynamic>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data is EverythingNews) {
              final items = (snapshot.data as EverythingNews)
                  .articles
                  .map<NewsItem>((e) => NewsItem(
                        title: e.title ?? '',
                        description: e.description ?? '',
                        imageUrl: e.urlToImage ?? '',
                      ))
                  .toList();
              if (items.isNotEmpty) {
                return GridView.builder(
                    // controller: _gridController,
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.2,
                      crossAxisCount: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return items[index];
                    });
              } else {
                return Center(
                    child: Text(
                  'No results found',
                  style: TextStyle(color: Colors.grey),
                ));
              }
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            // By default, show a loading spinner.
            return Center(child: const CircularProgressIndicator());
          }),
    );
  }

  void _searchButtonTapped() {
    setState(() {
      _isSearching = !_isSearching;
      _searchFieldController.text = '';
      if (!_isSearching && _newsQuery?.isNotEmpty == true) {
        _newsQuery = null;
        _fetchArticles(updateState: false);
      }
    });
  }

  void _searchFieldSubmitted(String value) {
    if (value.isNotEmpty && value != _newsQuery) {
      _newsQuery = value;
      _fetchArticles();
    }
  }

  void _logout() {
    AuthProvider().signOut().then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }

  void _fetchArticles({bool updateState = true}) {
    if (updateState) {
      setState(() {
        if (_newsQuery != null && _newsQuery?.isNotEmpty == true) {
          futureNews = NewsProvider().fetchSearchArticles(_newsQuery ?? '');
        } else {
          futureNews = NewsProvider().fetchTopArticles();
        }
        _gridController.jumpTo(0.0);
      });
    } else {
      if (_newsQuery != null && _newsQuery?.isNotEmpty == true) {
        futureNews = NewsProvider().fetchSearchArticles(_newsQuery ?? '');
      } else {
        futureNews = NewsProvider().fetchTopArticles();
      }
      _gridController.jumpTo(0.0);
    }
  }
}
