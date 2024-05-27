import 'package:flutter/material.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      shadowColor: Colors.transparent,
      margin: EdgeInsets.all(5.0),
      child: SizedBox.expand(
        child: Center(
          child: Text('Bookmarks page'),
        ),
      ),
    );
  }
}
