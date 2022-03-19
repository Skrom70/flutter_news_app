import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/news/news_favorites_page.dart';
import 'package:flutter_news_app/pages/news/news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _bottomNavigationBarSelectedIndex = 0;
  final List<Widget> _bottomNavigationBarItems = [
    NewsPage(),
    NewsFavoritesPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavigationBarItems[_bottomNavigationBarSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomNavigationBarSelectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.blur_circular_outlined),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
          ]),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index < _bottomNavigationBarItems.length && index >= 0) {
        _bottomNavigationBarSelectedIndex = index;
      }
    });
  }
}
