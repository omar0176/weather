import 'package:flutter/cupertino.dart';

// Utils class extends ChangeNotifier to manage state and notify listeners of changes
class Utils extends ChangeNotifier {
  // checks if current unit is Celsius
  bool isCelsius = true;

  // Constructor 
  Utils();

  // Getter 
  bool getIsCelsius() {
    return isCelsius;
  }

  // Setter that notifies listeners of the change
  void setIsCelsius(bool value) {
    isCelsius = value;
    notifyListeners();
  }

  // Convert a temperature from Celsius to Fahrenheit if isCelsius is false
  String convertToFahrenheit(String celsius) {
    return isCelsius
        ? '$celsius°' 
        : '${(double.parse(celsius) * 9 / 5 + 32).round().toString()}°';
  }
}
