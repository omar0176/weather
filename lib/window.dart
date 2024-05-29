import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/bookmarks_page.dart';
import 'package:weather/settings_page.dart';
import 'home_page.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({super.key});

  @override
  State<MainWindow> createState() => _MainWindowState();
}

int currentPageIndex = 0; // Index of the current page

class _MainWindowState extends State<MainWindow> {

  String _weather = "Fetching weather...";
  final String _apiKey = 'ca7125e0df61234bbfddef29c1ababde';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _weather = "Location services are disabled.";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _weather = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _weather = "Location permissions are permanently denied.";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _fetchWeather(position.latitude, position.longitude);
  }

  Future<void> _fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _weather = "Current temperature: ${data['main']['temp']}°C\n"
            "Weather: ${data['weather'][0]['description']}";
      });
    } else {
      setState(() {
        _weather = "Failed to fetch weather data.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text('Aeolus'), // App title
            ),
            backgroundColor:
            Colors.white.withOpacity(0.5), // Title background color
          ),
          backgroundColor: const Color(0xFFDCE3EA), // Page background color
          bottomNavigationBar: NavigationBar(
            indicatorColor: Colors.green, // Indicator color
            backgroundColor: Colors.white
                .withOpacity(0.5), // navigation bar background color
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index; // Sets the current page index
              });
            },
            destinations: const [
              // Navigation destinations
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(CupertinoIcons.bookmark),
                selectedIcon: Icon(Icons.bookmark),
                label: 'Bookmarks',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            selectedIndex: currentPageIndex, // Selected index
          ),
          body: IndexedStack(
            index: currentPageIndex,
            children: const [
              HomePage(),
              BookmarksPage(),
              SettingsPage(),
            ],
          ),
        ),
      ),
    );
  }
}