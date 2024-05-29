import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isDialogVisible = false; // Variable to toggle the dialog box
  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";

  List<Map<String, dynamic>> _hourlyForecast = [];

  final String _apiKeyOpenweather = 'ca7125e0df61234bbfddef29c1ababde';

  String getWeatherIcon(String weatherIconCode) {
    switch (weatherIconCode) {
      case '01d': // clear sky (day)
        return 'images/Symbols/sun logo.png';
      case '02d' || '02n' || '03d' || '03n' || '04d' || '04n': // Cloudy
        return 'images/Symbols/cloud.png';
      case '09d' || '09n' || '10d' || '10n': // rain
        return 'images/Symbols/rain.png';
      case '11d' || '11n': // clear thunderstorm
        return 'images/Symbols/thunderstorm.png';
      case '13d' || '13n': // snow
        return 'images/Symbols/snow.png';
      case '01n':
        return 'images/Symbols/Moon-logo.png'; // clear sky (night)
      default:
        return 'images/Symbols/cloud.png';
    }
  }

  @override
  void initState() {
    // geolocator
    super.initState();
    _getCurrentLocation();
  }

  void _toggleTextBox() {
    // Function to toggle the dialog box on and off
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
    _fetchHourlyForecast(position.latitude,
        position.longitude); // Call the _fetchHourlyForecast() method here
  }

  Future<void> _fetchHourlyForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hourlyForecasts = data['list'];

      // Extracting the first 6 hours of forecast data
      setState(() {
        _hourlyForecast = hourlyForecasts.where((forecast) {
          final DateTime forecastTime =
              DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
          return forecastTime.isBefore(DateTime.now().add(Duration(hours: 24)));
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
      });
    } else {
      setState(() {
        _weatherDescription = "Failed to fetch weather data.";
      });
    }
  }

  Future<DateTime> getCurrentTimeForLocation(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timeZoneOffset = data['timezone'];
      return DateTime.now().add(Duration(seconds: timeZoneOffset));
    } else {
      throw Exception('Failed to get current time for location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // Gesture Detector to disable searchbar when tapped
        onTap: () {
          if (_isDialogVisible) {
            _toggleTextBox();
          }
        },
        child: Stack(
          // Stack to overlay the Searchbar on the main page
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  // Scrollable widget
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'images/Sunny/Trees.png'), // Background image
                          fit: BoxFit.fitWidth, // Image fit the width
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            16.0), // Padding around the main content
                        child: Column(
                          children: [
                            const SizedBox(height: 20), // spacing
                            OutlinedButton.icon(
                              // Button to toggle the search bar
                              onPressed: _toggleTextBox,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: const BorderSide(
                                      width: 1, color: Colors.grey)),
                              label: const Text(
                                'My Location',
                                style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            Center(
                              child: Text(
                                _location,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 24),
                              ),
                            ),
                            const SizedBox(height: 20), //spacing
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center, // centering the content
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset('images/Sunny/SUN.png'), // Image of the sun
                                const SizedBox(height: 10), // spacing
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFB2E4FA)
                                            .withOpacity(0.3),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('$_temperature°', style: const TextStyle(fontSize: 80)),
                                      Text(_weatherDescription),
                                      Text('H:$_highTemp    L:$_lowTemp'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              // widget design for the today's weather forecast
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFB2E4FA)
                                        .withOpacity(0.3), //shadow color
                                    offset: const Offset(0, 4), // offset
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                                color: Colors.white
                                    .withOpacity(0.3), // background color
                                borderRadius:
                                    BorderRadius.circular(20), // border corners
                              ),
                              // hourly forecast widget
                              padding: const EdgeInsets.all(16),
                              margin: const EdgeInsets.all(16),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: _hourlyForecast.map((forecast) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Column(
                                        children: [
                                          Center(
                                            child: Text(
                                              DateFormat('HH:mm')
                                                  .format(forecast['time']),
                                            ),
                                          ),
                                          Image.asset(getWeatherIcon(
                                              forecast['weatherIcon'])),
                                          Center(
                                            child: Text(
                                              '${forecast['temperature']}°',
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_isDialogVisible) // to display the search bar
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // blur effect
                child: Container(
                  color: Colors.black.withOpacity(0.5), // blur darkening effect
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 40), // spacing
                      Container(
                        height: 50,
                        width: 300,
                        decoration: BoxDecoration(
                            // search bar design
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          // search bar text field
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[a-zA-Z,\s]'))
                          ], // Restrict to alphabets and whitespaces

                          decoration: const InputDecoration(
                            // Text field design
                            hintText: 'Berlin, Germany',
                            prefixIcon: Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 12.0),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ),
          ],
        ),
      ),
    );
  }
}
