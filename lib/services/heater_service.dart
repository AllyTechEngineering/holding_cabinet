import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HeaterService {
  final double _onHysteresis = 1.0;
  final double _offHysteresis = 0.5;
  bool _heaterState = false;
  static double? _setpointTemperature = 0.0;
  static double? _currentTemperature;
  static bool _systemOnOffState = false;
  late GPIO _gpio20;
  static final HeaterService _instance = HeaterService._internal();
  factory HeaterService() {
    return _instance;
  }
  HeaterService._internal() {
    _initializeHeaterService();
  }

  void _initializeHeaterService() {
    debugPrint('in _initializeHeaterService');
    try {
      _gpio20 = GPIO(20, GPIOdirection.gpioDirOut, 0);
      debugPrint('GPIO 20 Infor: ${_gpio20.getGPIOinfo()}');
      _gpio20.write(true); // Turn off the heater initially
    } catch (e) {
      _gpio20.dispose();
      debugPrint('Init GPIO 20 as output Error: $e');
    }
  }

  void updateHeaterTempSetpoint(double setpoint) {
    _setpointTemperature = setpoint;
    // debugPrint(
    //     'in HeaterService class: Heater setpoint updated to: $_setpointTemperature');
  }

  void updateI2cTemp(double currentTemperature) {
    _currentTemperature = currentTemperature;
    // debugPrint(
    //     'in HeaterService class: Current temperature updated to: $_currentTemperature');
    _updateHeaterState();
  }

  // Method to update the heater state
  void _updateHeaterState() {
    //debugPrint(
    // 'Before If: Setpoint Temperature: $_setpointTemperature\nCurrent Temperature: $_currentTemperature');
    if (_systemOnOffState) {
      debugPrint('_systemOnOffState: $_systemOnOffState');
      if (_currentTemperature! < _setpointTemperature! - _onHysteresis) {
        _heaterState = false; //Relay is active low
        //debugPrint('Turn Heater on: _heaterState False: $_heaterState');
        //debugPrint(
        // 'On If: Setpoint Temperature: $_setpointTemperature\nCurrent Temperature: $_currentTemperature');
        _gpio20.write(_heaterState);
      } else if (_currentTemperature! >
          _setpointTemperature! - _offHysteresis) {
        _heaterState = true; //Relay is active low
        //debugPrint('Turn heater off: _heaterState True: $_heaterState');
        //debugPrint(
        // 'Off If: Setpoint Temperature: $_setpointTemperature\nCurrent Temperature: $_currentTemperature');
        _gpio20.write(_heaterState);
      }
    }
  }

  void heaterSystemOnOff(bool newSystemOnOffState) {
    _systemOnOffState = newSystemOnOffState;
    // debugPrint(
    //     'in heaterSystemOnOff method System On/Off State: $_systemOnOffState');
    if (_systemOnOffState == false) {
      _gpio20.write(true); //Relay is active low
    }
  }

  void dispose() {
    try {
      _gpio20.write(true); // Turn off the heater
      _gpio20.dispose();
    } on Exception catch (e) {
      debugPrint('Error disposing GPIO 20: $e');
    }
    debugPrint('HeaterService resources released');
  }
}
