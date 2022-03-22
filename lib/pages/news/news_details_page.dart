import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/provider/models/arctile.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Html(data: article.description ?? ''),
          ],
        ),
      )),
    );
  }
}
