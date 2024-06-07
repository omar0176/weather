import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class Bookmark {
  final String location;
  final String temperature;
  final String highTemp;
  final String lowTemp;

  Bookmark({
    required this.location,
    required this.temperature,
    required this.highTemp,
    required this.lowTemp,
  });
}

class _BookmarksPageState extends State<BookmarksPage> {
  final List<Bookmark> _bookmarks = [];

  bool _isDialogVisible = false; // Variable to toggle the dialog box
  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";
  TextEditingController _searchController = TextEditingController();
  String upperImage = 'images/Sunny/SUN.png';
  String lowerImage = 'images/Sunny/Trees.png';

  List<Map<String, dynamic>> _hourlyForecast = [];

  final String _apiKeyOpenweather = 'ca7125e0df61234bbfddef29c1ababde';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedBookmarks = prefs.getString('bookmarks');
    if (encodedBookmarks != null) {
      final List<dynamic> decodedBookmarks = json.decode(encodedBookmarks);
      setState(() {
        _bookmarks.addAll(decodedBookmarks.map((bookmark) {
          return Bookmark(
            location: bookmark['location'],
            temperature: bookmark['temperature'],
            highTemp: bookmark['highTemp'],
            lowTemp: bookmark['lowTemp'],
          );
        }).toList());
      });
    }
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, String>> bookmarks = _bookmarks.map((bookmark) {
      return {
        'location': bookmark.location,
        'temperature': bookmark.temperature,
        'highTemp': bookmark.highTemp,
        'lowTemp': bookmark.lowTemp,
      };
    }).toList();
    final encodedBookmarks = json.encode(bookmarks);
    prefs.setString('bookmarks', encodedBookmarks);
  }

  void _modifyBookmark(
      String location, String temperature, String highTemp, String lowTemp) {
    setState(() {
      if (_bookmarks.length < 20) {
        if (_bookmarks.any((bookmark) => bookmark.location == location)) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Duplicate Bookmark'),
                content:
                const Text('A bookmark with this location already exists.'),
                actions: <Widget>[
                  Center(
                    child: SizedBox(
                      width: 100,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(child: Text('OK')),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          return;
        } else {
          final bookmark = Bookmark(
            location: location,
            temperature: temperature,
            highTemp: highTemp,
            lowTemp: lowTemp,
          );

          _bookmarks.add(bookmark);
          _saveBookmarks();
        }
      }
    });
  }

  void _deleteBookmark(int index) {
    setState(() {
      _bookmarks.removeAt(index);
      _saveBookmarks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListView.builder(
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = _bookmarks[index];
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(bookmark
                            .location), // Use bookmark.location instead of _location
                        Text(
                            '${bookmark.temperature}°'), // Use bookmark.temperature instead of _temperature
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('country name'),
                        Text(
                            'L:${bookmark.lowTemp}°  H:${bookmark.highTemp}°'), // Use bookmark.lowTemp and bookmark.highTemp
                      ],
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
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
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  _deleteBookmark(
                                      index); // Call a method to delete the bookmark
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (_isDialogVisible)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z,\s]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Berlin, Germany',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 12.0,
                            ),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              _fetchWeatherForSearch(value);
                              _toggleTextBox();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _toggleTextBox();
        },
        tooltip: 'Add Bookmark',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _toggleTextBox() {
    setState(() {
      _isDialogVisible = !_isDialogVisible;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _weatherDescription = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _weatherDescription = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _weatherDescription = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _fetchWeather(position.latitude, position.longitude);
    _fetchHourlyForecast(position.latitude, position.longitude);
  }

  Future<void> _fetchHourlyForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hourlyForecasts = data['list'];

      setState(() {
        _hourlyForecast = hourlyForecasts.where((forecast) {
          final DateTime forecastTime =
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          return forecastTime
              .isBefore(DateTime.now().add(const Duration(hours: 24)));
        }).map((forecast) {
          final DateTime forecastTime =
          DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          return {
            'time': forecastTime,
            'temperature': forecast['main']['temp'].toStringAsFixed(0),
            'weatherIcon': forecast['weather'][0]['icon'],
          };
        }).toList();
      });
    } else {
      setState(() {
        _weatherDescription = "Failed to fetch hourly forecast data.";
      });
    }
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _location = data['name'];
        _temperature =
            double.parse(data['main']['temp'].toString()).toStringAsFixed(0);
        _weatherDescription = data['weather'][0]['description'];
        _highTemp = double.parse(data['main']['temp_max'].toString())
            .toStringAsFixed(0);
        _lowTemp = double.parse(data['main']['temp_min'].toString())
            .toStringAsFixed(0);
        _modifyBookmark(_location, _temperature, _highTemp,
            _lowTemp); // Call _modifyBookmark here
      });
    } else {
      setState(() {
        _weatherDescription = "Failed to fetch weather data.";
      });
    }
  }

  Future<void> _fetchWeatherForSearch(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;
        _fetchWeather(latitude, longitude);
        _fetchHourlyForecast(latitude, longitude);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Location doesn't exist"),
            content: const Text("Please enter a valid location."),
            actions: [
              Center(
                child: SizedBox(
                  width: 100,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Center(child: Text('OK')),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}