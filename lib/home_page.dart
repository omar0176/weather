import 'dart:convert'; // JSON encoding and decoding package
import 'dart:ui'; // Image filter package
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Input formatting package
import 'package:geolocator/geolocator.dart'; // Geolocation package
import 'package:http/http.dart' as http; // HTTP package
import 'package:intl/intl.dart'; // Date and time formatting package
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:weather/utils.dart'; // Geocoding package

// Stateful Widget for the main screen of the app.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  //State variables
  final String _apiKeyOpenweather = 'ca7125e0df61234bbfddef29c1ababde'; // API key for OpenWeather

  bool _isDialogVisible = false; // Variable to toggle the dialog box
  bool _isSearchlocation = false; // Variable to check if geolocation is viewed
  late double _currentLatitude; // Variable to store the current latitude
  late double _currentLongitude; // Variable to store the current longitude


  // Variables to store weather data on the screen
  String _weatherDescription = "Loading weather...";
  String _temperature = "--";
  String _location = "";
  String _highTemp = "--";
  String _lowTemp = "--";

  // Variables for functionality
  int _timezone = 0;
  int _weatherCondition = 0;
  String _weatherConditionIcon = '';

  // Variables to store images
  String upperImage = 'images/Sunny/SUN.png';
  String lowerImage = 'images/Sunny/Trees.png';

  // Controller for the search text box
  final TextEditingController _searchController = TextEditingController();

  // Focus node for the search text box
  final FocusNode _searchFocusNode = FocusNode();

  // List to store hourly forecast data
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
      if(_isDialogVisible){
        _searchController.clear(); // Clear the search text box
        _searchFocusNode.requestFocus(); // Focus on the search text box to open keyboard
      }
    });
  }

  // Method to get the current location as coordinates
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission; // Variable to store location permissions

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
    // Checks if location permissions are permanently denied
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _weatherDescription = "Location permissions are permanently denied.";
      });
      return;
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // stores the current latitude and longitude
    _currentLatitude = position.latitude;
    _currentLongitude = position.longitude;

    _fetchWeather(_currentLatitude,
        _currentLongitude); // Fetch weather for given coordinates
    _fetchHourlyForecast(
        _currentLatitude, _currentLongitude); // Fetch hourly forecast

    setState(() {
      _isSearchlocation = false; // lets the app know that the location is not viewed
    });
  }

  // Method to fetch weather data from OpenWeather API given appropriate coordinates
  Future<void> _fetchWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

    if (response.statusCode == 200) { // 200 = successful response
      // If the response is successful
      final Map<String, dynamic> data = json.decode(response.body); // Decode the response's body

      setState(() { // collects the weather data from the json response
        _location = data['name']; // Gets the location name
        //gets the temp, converts it to a string, then rounds it to the nearest whole number
        _temperature = double.parse(data['main']['temp'].toString()).toStringAsFixed(0);
        // gets weather description for the first element
        _weatherDescription = data['weather'][0]['description'];
        // gets high and low temp, converts it to a string, then rounds it to the nearest whole number
        _highTemp = double.parse(data['main']['temp_max'].toString()).toStringAsFixed(0);
        _lowTemp = double.parse(data['main']['temp_min'].toString()).toStringAsFixed(0);
        _timezone = data['timezone']; // gets the timezone
        _weatherConditionIcon = data['weather'][0]['icon']; // gets the weather condition icon
        _weatherCondition = data['weather'][0]['id']; // gets the weather condition id
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
      final DateTime now = DateTime.now().toUtc().add(Duration(hours: timezoneOffsetHours.toInt())); // Adjusts for timezone
      final DateTime cutoff = now.add(const Duration(hours: 24)); // Get the time 24 hours from now

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
      List<Location> locations = await locationFromAddress(location); // Get the location from the input
      if (locations.isNotEmpty) { // If the location exists, it gets the lat. and long.
        double latitude = locations[0].latitude;
        double longitude = locations[0].longitude;

        final response = await http.get(Uri.parse( // Fetches weather data for the location
            'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKeyOpenweather'));

        if (response.statusCode == 200) { // 200 = successful response
          final Map<String, dynamic> data = json.decode(response.body);
          int weatherId = data['weather'][0]['id']; // gets the weather condition id
          String weatherIconCode = data['weather'][0]['icon']; // gets the weather condition icon

          // Updates the images based on the weather condition
          setState(() {
            upperImage = getWeatherCondition(weatherId, weatherIconCode, 1);
            lowerImage = getWeatherCondition(weatherId, weatherIconCode, 0);
          });

          _fetchWeather(latitude, longitude); // Fetches weather data for the location
          _fetchHourlyForecast(latitude, longitude); // Fetches hourly forecast for the location

          setState(() { // lets the app know whether the searched location is viewed
            _location = location;
            _isSearchlocation = true;
          });
        }
  }
    } catch (e) {
      // If the location doesn't exist
      setState(() { // shows a pop-up related to the error
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

  void switchToGeolocation() { // Switches to geolocation without calling it again
    _fetchWeather(_currentLatitude, _currentLongitude);
    _fetchHourlyForecast(_currentLatitude, _currentLongitude);

    setState(() {
      _isSearchlocation = false; // lets the app know that the search location is not viewed
    });
  }

  // updates weather condition images and symbols based on the weather condition
  String getWeatherCondition(
      int weatherId, String weatherIconCode, int upperOrLower) {
    // 1 is upper and 0 is lower

    // gets the corresponding image based on the weather condition
    if (weatherId >= 200 && weatherId <= 232) {
      // Thunderstorm
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rainy/Trees(rainy).png';
    } else if (weatherId >= 300 && weatherId <= 321) {
      // Drizzle
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rainy/Trees(rainy).png';
    } else if (weatherId >= 500 && weatherId <= 531) {
      // Rain
      upperImage = 'images/Rainy/Rainy cloud.png';
      lowerImage = 'images/Rainy/Trees(rainy).png';
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


  bool isNight() { // checks if it is night time
    return (DateTime.now().toUtc().hour + _timezone / 3600) % 24 < 6 ||
        (DateTime.now().toUtc().hour + _timezone / 3600) % 24 > 18;
  }

  // Build method for the UI of the main screen
  @override
  Widget build(BuildContext context) {
    Utils unit = Provider.of<Utils>(context);
    return Scaffold(
      backgroundColor:
          isNight() ? const Color(0xFF2F3542) : const Color(0xFFDCE3EA),
      body: GestureDetector( // to detect if you're trying to click away from the search box
        onTap: () {
          if (_isDialogVisible) {
            _toggleTextBox();
          }
        },
        child: Stack( // stacks all the content of the page
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox( // constrains the content to the size of the screen
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight, // sets the minimum height of the content
                    ),
                    child: Container( // container for the upper image
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(getWeatherCondition(_weatherCondition, _weatherConditionIcon, 0)),
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      child: Padding( // padding for the content
                        padding: const EdgeInsets.all(16.0),
                        child: Column( // column for the content
                          children: [
                            const SizedBox(height: 20),
                            Center(
                              child: Wrap(  // Wrap location button
                                alignment: WrapAlignment.center,
                                children: [
                                  OutlinedButton.icon(// creates the button with an icon
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
                                    label: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(_isSearchlocation? _location :'My Location',
                                        style: TextStyle(
                                          fontSize: 46,
                                          fontWeight: FontWeight.w500,
                                          color: isNight() ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10), // Add some space between the buttons
                                  if (_isSearchlocation) // if the search location is viewed, show the refresh button
                                    Align(
                                      child: FloatingActionButton.small( // back to current_position button
                                        onPressed: () {
                                          switchToGeolocation();
                                        },
                                        backgroundColor: const Color(0xFFDCE3EA),
                                        child: const Icon(Icons.refresh),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Center( // location
                              child: Text(_isSearchlocation? '':_location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: isNight() ? Colors.white : Colors.black),
                              ),
                            ),
                            const SizedBox(height: 20), // spacing
                            Column( // column for the weather data
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min, // sets the size of the column
                              children: [
                                Image.asset(getWeatherCondition(_weatherCondition, _weatherConditionIcon, 1)), // lower image
                                const SizedBox(height: 10),
                                ClipRRect( // used to limit the blur effect
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Container( //container for the current weather data
                                      decoration: BoxDecoration( // Container styling
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
                                      child: Column( // to keep data under each other
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(unit.convertToFahrenheit(_temperature),
                                              style: const TextStyle(fontSize: 80)),
                                          Text(_weatherDescription),
                                          Text('H:${unit.convertToFahrenheit(_highTemp)}    L:${unit.convertToFahrenheit(_lowTemp)}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            ClipRRect( // used to limit the blur effect
                              borderRadius: BorderRadius.circular(20),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
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
                                  child: SingleChildScrollView( // to scroll through the hourly forecast
                                    scrollDirection: Axis.horizontal,
                                    child: Row( // row for the hourly forecast
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: _hourlyForecast.map((forecast) {
                                        // maps the forecast data with the structure given below
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
                                                  '${unit.convertToFahrenheit(forecast['temperature'])}',
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
            if (_isDialogVisible) // if the search box is visible, show the search box
              BackdropFilter( // used to blur the background
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
                          decoration: BoxDecoration( // style of search box
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            focusNode: _searchFocusNode, // assigns the focus node
                            controller: _searchController, //assigns the controller
                            inputFormatters: [ // to limit the text input to letters, commas, and spaces
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z,\s]'))
                            ],
                            decoration: const InputDecoration( // styling of the search box
                              hintText: 'Berlin, Germany',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 12.0),
                            ),
                            onSubmitted: (value) {
                              _fetchWeatherForSearch(value); // fetches weather data for the inputted location
                              _toggleTextBox(); // toggles the search box

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
