import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/news/items/news_item.dart';
import 'package:flutter_news_app/pages/news/news_details_page.dart';
import 'package:flutter_news_app/provider/models/arctile.dart';
import 'package:flutter_news_app/reuse_widgets/simple_snackbar.dart';
import 'package:flutter_news_app/provider/auth_provider.dart';
import 'package:flutter_news_app/provider/news_provider.dart';
import 'package:provider/provider.dart';

class NewsPage extends StatelessWidget {
  NewsPage({Key? key}) : super(key: key);

  final _gridController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // DatabaseProvider().deleteAll();
    _fetchCachedArticles(context);
    _loadTopArticles(context);
    return Consumer<NewsProvider>(
        builder: ((ctx, provider, child) => Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: provider.getSearchingState
                    ? Icon(Icons.close)
                    : Icon(Icons.search),
                onPressed: () => _searchButtonTapped(ctx),
              ),
              title: provider.getSearchingState
                  ? _buildSearchField(ctx)
                  : Text('News App'),
              actions: [
                IconButton(
                    onPressed: () => _logout(ctx),
                    icon: Icon(Icons.exit_to_app_rounded)),
              ],
            ),
            body: _buildPageWidget(ctx, provider))));
  }

  Widget _buildPageWidget(BuildContext context, NewsProvider provider) {
    if (provider.articles.isNotEmpty) {
      final items = provider.articles
          .map<NewsItem>((e) => NewsItem(
                title: e.title ?? '',
                description: e.description ?? '',
                imageUrl: e.urlToImage ?? '',
                isFavorite: e.isFavorite,
                changeFavoriteState: () {
                  e.isFavorite = !e.isFavorite;
                  provider.updateArticle(e);
                },
                onTapped: () => _pushToDetails(context, e),
              ))
          .toList();

      if (_gridController.hasClients &&
          provider.newsQuery?.isNotEmpty == true) {
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

  Widget _buildSearchField(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: TextField(
          onSubmitted: (value) => _searchFieldSubmitted(context, value),
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              fillColor: Colors.white.withOpacity(0.2),
              filled: true,
              border: InputBorder.none,
              hintText: 'search',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)))),
    );
  }

  void _searchButtonTapped(BuildContext context) {
    Provider.of<NewsProvider>(context, listen: false).changeSearingState();
  }

  void _searchFieldSubmitted(BuildContext context, String value) {
    _loadSearchArticles(context, value);
  }

  void _loadTopArticles(BuildContext context) async {
    Provider.of<NewsProvider>(context, listen: false).loadTopArticles().onError(
        (error, stackTrace) =>
            showSnackBar(context, error.toString(), SnackBarType.error));
  }

  void _fetchCachedArticles(BuildContext context) async {
    Provider.of<NewsProvider>(context, listen: false)
        .fetchCachedArticles()
        .onError((error, stackTrace) =>
            showSnackBar(context, error.toString(), SnackBarType.error));
  }

  void _loadSearchArticles(BuildContext context, String query) {
    if (query.isNotEmpty) {
      Provider.of<NewsProvider>(context, listen: false)
          .loadSearchArticles(query)
          .onError((error, stackTrace) =>
              showSnackBar(context, error.toString(), SnackBarType.error));
    }
  }

  void _logout(BuildContext context) {
    AuthProvider()
        .signOut()
        .then((_) => Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false))
        .onError((error, stackTrace) =>
            showSnackBar(context, error.toString(), SnackBarType.error));
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
