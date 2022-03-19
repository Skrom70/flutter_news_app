import 'package:flutter/material.dart';
import '../../provider/auth_provider.dart';

class NewsFavoritesPage extends StatelessWidget {
  const NewsFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Center(child: Text('Favorites Newss')));
  }

  void _logout(BuildContext context) {
    AuthProvider().signOut().then((_) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    });
  }
}
