import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _isDialogVisible = false;
  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";
  int _timezone = 0;
  final TextEditingController _searchController = TextEditingController();
  String upperImage = 'images/Sunny/SUN.png';
  String lowerImage = 'images/Sunny/Trees.png';

  List<Map<String, dynamic>> _hourlyForecast = [];

  final String _apiKeyOpenweather = 'ca7125e0df61234bbfddef29c1ababde';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
    _fetchHourlyForecast(position.latitude, position.longitude); // Call the _fetchHourlyForecast() method here
  }

  Future<void> _fetchHourlyForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> hourlyForecasts = data['list'];

      // Extracting the timezone offset in hours
      final double timezoneOffsetHours = data['city']['timezone']/3600;

      // Extracting the first 6 hours of forecast data
      setState(() {
        _hourlyForecast = hourlyForecasts.where((forecast) {
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
              forecast['dt'] * 1000,
              isUtc: true); // Ensure UTC time
          final DateTime adjustedForecastTime =
          forecastTime.add(Duration(hours: timezoneOffsetHours.toInt()));
          return adjustedForecastTime.isBefore(
              DateTime.now().add(const Duration(hours: 24)));
        }).map((forecast) {
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
              forecast['dt'] * 1000,
              isUtc: true); // Ensure UTC time
          final DateTime adjustedForecastTime =
          forecastTime.add(Duration(hours: timezoneOffsetHours.toInt()));
          return {
            'time': adjustedForecastTime,
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
        _timezone = data['timezone'];
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
        setState(() {
          _location = location;
        });
      }
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    bool isNight = (DateTime.now().toUtc().hour + _timezone / 3600) % 24 < 6 ||
        (DateTime.now().toUtc().hour + _timezone / 3600) % 24 > 18;

    return Scaffold(
      backgroundColor: isNight ? const Color(0xFF2F3542) : const Color(0xFFDCE3EA),
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
                              label: Text(
                                'My Location',
                                style: TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w500,
                                    color:
                                    isNight ? Colors.white : Colors.black),
                              ),
                            ),
                            Center(
                              child: Text(
                                _location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color:
                                    isNight ? Colors.white : Colors.black),
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text('$_temperature°',
                                          style: const TextStyle(fontSize: 80)),
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
                                borderRadius: BorderRadius.circular(20),
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
                              border:
                              Border.all(color: Colors.black, width: 1.0),
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