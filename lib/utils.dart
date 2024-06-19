import 'package:flutter/cupertino.dart';

class Utils extends ChangeNotifier{

  bool isCelsius = true;

  Utils();

  getIsCelsius(){
    return isCelsius;
  }

  setIsCelsius(bool value){
    isCelsius = value;
    notifyListeners();
  }
  convertToFahrenheit(String celsius){
    return isCelsius? '$celsius°' : '${(double.parse(celsius) * 9 / 5 + 32).round().toString()}°';
  }
}