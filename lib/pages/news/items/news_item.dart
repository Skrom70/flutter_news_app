import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsItem extends StatelessWidget {
  const NewsItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.imageUrl})
      : super(key: key);

  final String title;
  final String description;
  final String imageUrl;

  static final Widget _failedImagePlaceholder = Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.grey.withOpacity(0.3),
    child: Icon(
      Icons.error,
      size: 100.0,
      color: Colors.white.withOpacity(0.8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 3,
                      style: TextStyle(fontSize: 20.0, shadows: [
                        Shadow(
                            color: Colors.grey,
                            offset: Offset(1.0, 1.0),
                            blurRadius: 2.0)
                      ]),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border_outlined)),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border_outlined)),
                ],
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    offset: Offset(0.0, -25.0),
                    blurRadius: 25.0)
              ]),
              child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8.0)),
                  child: imageUrl == ''
                      ? _failedImagePlaceholder
                      : _loadNewsImage()),
            ))
          ],
        ),
      ),
    );
  }

  Widget _loadNewsImage() {
    return CachedNetworkImage(
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      imageUrl: imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => _failedImagePlaceholder,
    );
  }
}
