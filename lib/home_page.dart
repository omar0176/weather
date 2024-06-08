import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';

// Stateful Widget for the main screen of the app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //State variables
  final String _apiKeyOpenweather = 'ca7125e0df61234bbfddef29c1ababde';

  bool _isDialogVisible = false; // Variable to toggle the dialog box

  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";
  int _timezone = 0;

  String upperImage = 'images/Sunny/SUN.png';
  String lowerImage = 'images/Sunny/Trees.png';

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _hourlyForecast = [];

  // Obtains location of user as soon as the app is opened
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Method to toggle the text box for searching
  void _toggleTextBox() {
    setState(() {
      _isDialogVisible = !_isDialogVisible;
    });
  }

  // Method to get the current location as coordinates
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _weatherDescription = "Location services are disabled.";
      });
      return;
    }

    // Check for location permissions
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

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _fetchWeather(position.latitude, position.longitude); // Fetch weather for given coordinates
    _fetchHourlyForecast(position.latitude, position.longitude); // Fetch hourly forecast
  }

  // Method to fetch weather data from OpenWeather API given appropriate coordinates
  Future<void> _fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) { // If the response is successful
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _location = data['name'];
        _temperature = double.parse(data['main']['temp'].toString()).toStringAsFixed(0);
        _weatherDescription = data['weather'][0]['description'];
        _highTemp = double.parse(data['main']['temp_max'].toString())
            .toStringAsFixed(0);
        _lowTemp = double.parse(data['main']['temp_min'].toString())
            .toStringAsFixed(0);
        _timezone = data['timezone'];
      });
    } else { // If the response is unsuccessful
      setState(() {
        _weatherDescription = "Failed to fetch weather data.";
      });
    }
  }

  // Method to fetch hourly future forecast data given appropriate coordinates
  Future<void> _fetchHourlyForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) { // If the response is successful
      final Map<String, dynamic> data = json.decode(response.body); // Decode the response's body
      final List<dynamic> hourlyForecasts = data['list']; // Get the list of hourly forecasts from the response
      final double timezoneOffsetHours = data['city']['timezone'] / 3600; // Get the timezone offset in hours

      setState(() {
        final DateTime now = DateTime.now().toUtc(); // Get the current time in UTC
        final DateTime cutoff = now.add(const Duration(hours: 24)); // Get the time 24 hours from now

        _hourlyForecast = hourlyForecasts.where((forecast) {
          // Convert forecast time to DateTime and adjust for timezone
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
              forecast['dt'] * 1000,
              isUtc: true
          ).add(Duration(hours: timezoneOffsetHours.toInt()));

          // Filter forecasts to include only those within the next 24 hours
          return forecastTime.isBefore(cutoff);
        }).map((forecast) {
          // Convert forecast time to DateTime and adjust for timezone again for mapping
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
              forecast['dt'] * 1000,
              isUtc: true
          ).add(Duration(hours: timezoneOffsetHours.toInt()));

          // Map each forecast to a desired structure
          return {
            'time': forecastTime,
            'temperature': forecast['main']['temp'].toStringAsFixed(0),
            'weatherIcon': forecast['weather'][0]['icon'],
          };
        }).toList();
      });
    } else { // if the response is unsuccessful
      setState(() {
        _weatherDescription = "Failed to fetch hourly forecast data.";
      });
    }
  }

  // Method to fetch weather data for an inputted location
  Future<void> _fetchWeatherForSearch(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location); // Get the location from the inputted location
      if (locations.isNotEmpty) { // If the location exists
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;

        _fetchWeather(latitude, longitude);
        _fetchHourlyForecast(latitude, longitude);

        setState(() {
          _location = location;
        });
      }
    } catch (e) { // If the location doesn't exist
      setState(() {
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
            }
        );
      });
    }
  }

  // Method to get the right weather icon based on icon code
  String getWeatherIcon(String weatherIconCode) {
    switch (weatherIconCode) {
      case '01d': // clear sky (day)
        upperImage = 'images/Sunny/SUN.png';
        lowerImage = 'images/Sunny/Trees.png';
        return 'images/Symbols/sun logo.png';
      case '02d' || '02n' || '03d' || '03n' || '04d' || '04n': // Cloudy
        upperImage = 'images/Cloudy/sun cloudy.png';
        lowerImage = 'images/Cloudy/clouds (cloudy).png';
        return 'images/Symbols/cloud.png';
      case '09d' || '09n' || '10d' || '10n': // rain
        upperImage = 'images/Rain/Rainy cloud.png';
        lowerImage = 'images/Rain/Trees(rainy).png';
        return 'images/Symbols/cloud-drizzle.png';
      case '11d' || '11n': // clear thunderstorm
        upperImage = 'images/Rain/Rainy cloud.png';
        lowerImage = 'images/Rain/Trees(rainy).png';
        return 'images/Symbols/thunderstorm.png';
      case '13d' || '13n': // snow
        upperImage = 'images/Snow/snow cloud.png';
        lowerImage = 'images/Snow/snow mountains.png';
        return 'images/Symbols/snow.png';
      case '01n':
        upperImage = 'images/Night/Moon.png';
        lowerImage = 'images/Night/clouds (night).png';
        return 'images/Symbols/Moon-logo.png'; // clear sky (night)
      default:

        return 'images/Symbols/cloud.png';
    }
  }

  // Build method for the UI of the main screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_isDialogVisible) {
            _toggleTextBox();
          }
        },
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(lowerImage),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            OutlinedButton.icon(
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
                            const SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(upperImage),
                                const SizedBox(height: 10),
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
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
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
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: _searchController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z,\s]'))
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Berlin, Germany',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                            ),
                            onSubmitted: (value) {
                              _fetchWeatherForSearch(value);
                              _toggleTextBox();
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
      ),
    );
  }
}
