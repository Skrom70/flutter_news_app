import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/news/items/news_item.dart';
import 'package:flutter_news_app/pages/news/news_details_page.dart';
import 'package:flutter_news_app/provider/models/arctile.dart';
import 'package:flutter_news_app/provider/news_favorite_provider.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';

class NewsFavoritePage extends StatelessWidget {
  NewsFavoritePage({Key? key}) : super(key: key);

  final _gridController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _loadArticles(context);
    return Consumer<NewsFavoriteProvider>(
        builder: ((ctx, provider, child) => Scaffold(
            appBar: AppBar(
              title: Text('Favorites'),
              actions: [
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(Icons.exit_to_app),
                  ),
                ),
              ],
            ),
            body: _buildPageWidget(ctx, provider))));
  }

  void _logout(BuildContext context) {
    AuthProvider().signOut().then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }

  Widget _buildPageWidget(BuildContext context, NewsFavoriteProvider provider) {
    if (provider.articles.isNotEmpty) {
      final items = provider.articles
          .map<NewsItem>((e) => NewsItem(
                title: e.title ?? '',
                description: e.description ?? '',
                imageUrl: e.urlToImage ?? '',
                isFavorite: e.isFavorite,
                changeFavoriteState: () {
                  e.isFavorite = !e.isFavorite;
                  provider.remote(e);
                },
                onTapped: () => _pushToDetails(context, e),
              ))
          .toList();

      if (_gridController.hasClients) {
        _gridController.jumpTo(0.0);
      }

      return GridView.builder(
          controller: _gridController,
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
  }

  void _loadArticles(BuildContext context) {
    Provider.of<NewsFavoriteProvider>(context, listen: false).load();
  }

  void _pushToDetails(BuildContext context, Article element) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NewsDetailsPage(
                article: element,
              )),
    );
  }
}
