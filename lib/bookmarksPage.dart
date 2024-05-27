import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  final List<String> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedBookmarks = prefs.getStringList('bookmarks');
    if (savedBookmarks != null) {
      setState(() {
        _bookmarks.addAll(savedBookmarks);
      });
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarks', _bookmarks);
  }

  void _addBookmark() {
    setState(() {
      if (_bookmarks.length < 20) {
        _bookmarks.add('Bookmark ${_bookmarks.length + 1}');
        _saveBookmarks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cannot add more than 20 bookmarks')),
        );
      }
    });
  }

  void _removeBookmark(int index) {
    setState(() {
      _bookmarks.removeAt(index);
      _saveBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: _bookmarks.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFFB2E4FA),
                    offset: Offset(0, 4),
                    blurRadius: 1,
                    spreadRadius: 0,
                  ),
                ],
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(3),
              child: ListTile(
                title: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('<city_name>'), Text('[temp]°')],
                ),
                subtitle: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('<country_name>'), Text('L:XX°  H:XX° ')],
                ),
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Bookmark'),
                        content: const Text(
                            'Are you sure you want to delete this bookmark?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              _removeBookmark(index);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }, //20
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBookmark,
        tooltip: 'Add Bookmark',
        child: const Icon(Icons.add),
      ), //ONLY FOR DEMONSTRATION
    );
  }
}