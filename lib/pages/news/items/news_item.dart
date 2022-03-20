import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsItem extends StatefulWidget {
  NewsItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.isFavorite,
      required this.changeFavoriteState})
      : super(key: key);

  final String title;
  final String description;
  final String imageUrl;
  bool isFavorite;
  final Function changeFavoriteState;

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
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
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
                      widget.title,
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
                      onPressed: _changeFavoriteState,
                      icon: Icon(widget.isFavorite
                          ? Icons.favorite_outlined
                          : Icons.favorite_border_outlined)),
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
                  child: widget.imageUrl == ''
                      ? NewsItem._failedImagePlaceholder
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
      imageUrl: widget.imageUrl,
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => NewsItem._failedImagePlaceholder,
    );
  }

  void _changeFavoriteState() {
    widget.changeFavoriteState();
    setState(() {
      widget.isFavorite = !widget.isFavorite;
    });
  }
}
