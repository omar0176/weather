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
    // part of the saving and loading bookmarks
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    // loads bookmarks from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedBookmarks = prefs.getStringList('bookmarks');
    if (savedBookmarks != null) {
      setState(() {
        _bookmarks.addAll(savedBookmarks);
      });
    }
  }

  Future<void> _saveBookmarks() async {
    // saves bookmarks to shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('bookmarks', _bookmarks);
  }

  void _modifyBookmark(int index, bool add) {
    // adds or removes bookmarks
    setState(() {
      if (add && _bookmarks.length < 20) {
        _bookmarks.add('Bookmark ${_bookmarks.length + 1}');
      } else if (!add) {
        _bookmarks.removeAt(index);
      }
      _saveBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
            // builds the list of bookmarks
            itemCount: _bookmarks.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  // bookmark design
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFB2E4FA),
                      offset: Offset(0, 4),
                      blurRadius: 1,
                      spreadRadius: 0,
                    ),
                  ],
                  color: Colors.white.withOpacity(0.3), // bookmark color
                  borderRadius:
                  BorderRadius.circular(20), // bookmark corner radius
                ),
                padding: const EdgeInsets.all(5), // bookmark padding
                margin: const EdgeInsets.all(3),
                child: ListTile(
                  title: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('<city_name>'),
                      Text('[temp]°')
                    ], // city name and temperature
                  ),
                  subtitle: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('<country_name>'),
                      Text('L:XX°  H:XX° ')
                    ], // country name and high/low temperature
                  ),
                  onLongPress: () {
                    // deletes bookmark on long press
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          // alert for deleting bookmark
                          title: const Text('Delete Bookmark'),
                          content: const Text(
                            'Are you sure you want to delete this bookmark?',
                            style: TextStyle(fontSize: 16),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text(
                                'Cancel',
                                style: TextStyle(color: Colors.black),
                              ), // cancel button
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Delete', // delete button
                                style: TextStyle(color: Colors.red),
                              ), // delete button
                              onPressed: () {
                                _modifyBookmark(index, false);
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _modifyBookmark(0, true),
        tooltip: 'Add Bookmark',
        child: const Icon(Icons.add),
      ), //ONLY FOR DEMONSTRATION
    );
  }
}