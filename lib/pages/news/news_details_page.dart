import 'package:flutter/material.dart';

class NewsDetailsPage extends StatelessWidget {
  const NewsDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Details'),
      ),
      body: Center(child: Text('News Details')),
    );
  }
}
