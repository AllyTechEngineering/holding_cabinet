import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class HumidifierService {
  final double onHysteresis = 1.0;
  final double offHysteresis = 0.5;
  bool _humidifierState = false;
  static bool systemOnOffState = false;
  static double? _setpointHumidity = 0.0;
  static double? _currentHumidity;
  late GPIO gpio21;
  static final HumidifierService _instance = HumidifierService._internal();
  factory HumidifierService() {
    return _instance;
  }
  HumidifierService._internal() {
    initializeHumidifierService();
  }

  void initializeHumidifierService() {
    // debugPrint('in initializeHumidifierService');
    try {
      gpio21 = GPIO(21, GPIOdirection.gpioDirOut, 0);
      debugPrint('GPIO 21 Infor: ${gpio21.getGPIOinfo()}');
      gpio21.write(true); // Turn off the humidifier initially
    } catch (e) {
      gpio21.dispose();
      debugPrint('Init GPIO 21 as output Error: $e');
    }
  }

  void updateHumidifierSetpoint(double setpoint) {
    _setpointHumidity = setpoint;
    // debugPrint(
    //     'in HumidifierService class: Humidity setpoint updated to: $_setpointHumidity');
  }

  void updateI2cHumidity(double currentHumidity) {
    _currentHumidity = currentHumidity;
    updateHumdifierValue();
  }

  // Method to update the heater state
  void updateHumdifierValue() {
    if (systemOnOffState) {
      if (_currentHumidity! < _setpointHumidity! - onHysteresis) {
        _humidifierState = false; // Relay is active low
        debugPrint(
            'Humidifier is On active low (false): $_humidifierState\n current Humidity: $_currentHumidity\n setpoint Humidity: $_setpointHumidity');
        gpio21.write(_humidifierState); // Relay is active low
      } else if (_currentHumidity! > _setpointHumidity! - offHysteresis) {
        _humidifierState = true; //Relay is active low
        debugPrint(
            'Humidifier is Off (true): $_humidifierState\n current Humidity: $_currentHumidity\n setpoint Humidity: $_setpointHumidity');
        debugPrint('System On Off State: $systemOnOffState');
        gpio21.write(_humidifierState);
      }
    }
  }

  void humidifierSystemOnOff(bool newSystemOnOffState) {
    systemOnOffState = newSystemOnOffState;
    // debugPrint(
    //     'in heaterSystemOnOff method System On/Off State: $systemOnOffState');
    if (systemOnOffState == false) {
      gpio21.write(true); //Relay is active low
    }
  }

  void dispose() {
    try {
      gpio21.write(true); // Turn off the humidifier
      gpio21.dispose();
    } on Exception catch (e) {
      debugPrint('Error disposing GPIO 21: $e');
    }
    debugPrint('HumidifierService resources released');
  }
}
