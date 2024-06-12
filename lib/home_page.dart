import 'dart:convert';
import 'dart:ffi';
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
  bool _isSearchlocation = false; // Variable to check if geolocation is viewed
  late double _currentLatitude; // Variable to store the current latitude
  late double _currentLongitude; // Variable to store the current longitude

  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";
  int _timezone = 0;
  int _weatherCondition = 0;
  String _weatherConditionIcon = '';

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

    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;

    _fetchWeather(_currentLatitude,
        _currentLongitude); // Fetch weather for given coordinates
    _fetchHourlyForecast(
        _currentLatitude, _currentLongitude); // Fetch hourly forecast

    setState(() {
      _isSearchlocation = false;
    });
  }

  // Method to fetch weather data from OpenWeather API given appropriate coordinates
  Future<void> _fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      // If the response is successful
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
        _weatherConditionIcon = data['weather'][0]['icon'];
        _weatherCondition = data['weather'][0]['id'];
      });
    } else {
      // If the response is unsuccessful
      setState(() {
        _weatherDescription = "Failed to fetch weather data.";
      });
    }
  }

  // Method to fetch hourly future forecast data given appropriate coordinates
  Future<void> _fetchHourlyForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) {
      // If the response is successful
      final Map<String, dynamic> data =
          json.decode(response.body); // Decode the response's body
      final List<dynamic> hourlyForecasts =
          data['list']; // Get the list of hourly forecasts from the response
      final double timezoneOffsetHours =
          data['city']['timezone'] / 3600; // Get the timezone offset in hours

      setState(() {
        final DateTime now =
            DateTime.now().toUtc(); // Get the current time in UTC
        final DateTime cutoff = now
            .add(const Duration(hours: 24)); // Get the time 24 hours from now

        _hourlyForecast = hourlyForecasts.where((forecast) {
          // Convert forecast time to DateTime and adjust for timezone
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
                  forecast['dt'] * 1000,
                  isUtc: true)
              .add(Duration(hours: timezoneOffsetHours.toInt()));

          // Filter forecasts to include only those within the next 24 hours
          return forecastTime.isBefore(cutoff);
        }).map((forecast) {
          // Convert forecast time to DateTime and adjust for timezone again for mapping
          final DateTime forecastTime = DateTime.fromMillisecondsSinceEpoch(
                  forecast['dt'] * 1000,
                  isUtc: true)
              .add(Duration(hours: timezoneOffsetHours.toInt()));

          // Map each forecast to a desired structure
          return {
            'time': forecastTime,
            'temperature': forecast['main']['temp'].toStringAsFixed(0),
            'weatherIcon': forecast['weather'][0]['icon'],
          };
        }).toList();
      });
    } else {
      // if the response is unsuccessful
      setState(() {
        _weatherDescription = "Failed to fetch hourly forecast data.";
      });
    }
  }

  // Method to fetch weather data for an inputted location
  Future<void> _fetchWeatherForSearch(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;

        final response = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          int weatherId = data['weather'][0]['id'];
          String weatherIconCode = data['weather'][0]['icon'];

          // Call getWeatcherCondtion function and update the state
          setState(() {
            upperImage = getWeatcherCondtion(weatherId, weatherIconCode, 1);
            lowerImage = getWeatcherCondtion(weatherId, weatherIconCode, 0);
          });

          _fetchWeather(latitude, longitude);
          _fetchHourlyForecast(latitude, longitude);

          setState(() {
            _location = location;
            _isSearchlocation = true;
          });
        }
  }
    } catch (e) {
      // If the location doesn't exist
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
            });
      });
    }
  }

  void switchToGeolocation() {
    _fetchWeather(_currentLatitude, _currentLongitude);
    _fetchHourlyForecast(_currentLatitude, _currentLongitude);

    setState(() {
      _isSearchlocation = false;
    });
  }

  String getWeatcherCondtion(
      int weatherId, String weatherIconCode, int upperOrLower) {
    // 1 is upper and 0 is lower
    if (weatherId >= 200 && weatherId <= 232) {
      // Thunderstorm
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rain/Trees(rainy).png';
    } else if (weatherId >= 300 && weatherId <= 321) {
      // Drizzle
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rain/Trees(rainy).png';
    } else if (weatherId >= 500 && weatherId <= 531) {
      // Rain
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rain/Trees(rainy).png';
    } else if (weatherId >= 600 && weatherId <= 622) {
      // Snow
      upperImage = 'images/Snowy/snow cloud.png';
      lowerImage = 'images/Snowy/snow mountains.png';
    } else if (weatherId >= 701 && weatherId <= 781) {
      // Atmosphere
      upperImage = 'images/Cloudy/sun cloudy.png';
      lowerImage = 'images/Cloudy/clouds (cloudy).png';
    } else if (weatherId == 800) {
      if (weatherIconCode == '01d') {
        // Clear sky (day)
        upperImage = 'images/Sunny/SUN.png';
        lowerImage = 'images/Sunny/Trees.png';
      } else if (weatherIconCode == '01n') {
        // Clear sky (night)
        upperImage = 'images/Night/Moon.png';
        lowerImage = 'images/Night/clouds (night).png';
      }
    } else if (weatherId >= 801 && weatherId <= 804) {
      // Clouds
      upperImage = 'images/Cloudy/sun cloudy.png';
      lowerImage = 'images/Cloudy/clouds (cloudy).png';
    }
    return upperOrLower == 1 ? upperImage : lowerImage;
  }

  // Method to get the right weather icon based on icon code
  String getWeatherIcon(String weatherIconCode) {
    switch (weatherIconCode) {
      case '01d': // clear sky (day)
        return 'images/Symbols/sun logo.png';
      case '02d' || '02n' || '03d' || '03n' || '04d' || '04n': // Cloudy
        return 'images/Symbols/cloud.png';
      case '09d' || '09n' || '10d' || '10n': // rain
        return 'images/Symbols/cloud-drizzle.png';
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


  bool isNight() {
    return (DateTime.now().toUtc().hour + _timezone / 3600) % 24 < 6 ||
        (DateTime.now().toUtc().hour + _timezone / 3600) % 24 > 18;
  }

  // Build method for the UI of the main screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isNight() ? const Color(0xFF2F3542) : const Color(0xFFDCE3EA),
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
                          image: AssetImage(getWeatcherCondtion(_weatherCondition, _weatherConditionIcon, 0)),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _toggleTextBox,
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: const BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  label: Text(
                                    'My Location',
                                    style: TextStyle(
                                      fontSize: 46,
                                      fontWeight: FontWeight.w500,
                                      color: isNight() ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10), // Add some space between the buttons
                                if (_isSearchlocation) // slow asf
                                  FloatingActionButton.small(
                                    onPressed: () {
                                      switchToGeolocation();
                                    },
                                    backgroundColor: const Color(0xFFDCE3EA),
                                    child: const Icon(Icons.refresh),
                                  ),
                              ],
                            ),
                            Center(
                              child: Text(
                                _location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: isNight()
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(getWeatcherCondtion(_weatherCondition, _weatherConditionIcon, 1)),
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
