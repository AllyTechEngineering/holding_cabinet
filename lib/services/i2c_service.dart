import 'dart:async';

import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';

class I2CService {
  var i2c = I2C(1);
  Duration pollingInterval = const Duration(milliseconds: 2000);
  late Timer _pollingTimer;
  // ignore: prefer_typing_uninitialized_variables
  late final BME280 bme280;
  bool _isInitialized = false;

  void initializeBme280() {
    try {
      debugPrint('I2C info: ${i2c.getI2Cinfo()}');
      bme280 = BME280(i2c);
      _isInitialized = true;
    } catch (e) {
      disposeI2c();
      debugPrint('Error initializing I2C device: $e');
    }
  }

  void stopPolling() {
    _pollingTimer.cancel();
  }

  Future<Map<String, double>> readSensorData() async {
    if (!_isInitialized) {
      throw Exception('BME280 not initialized. Call initializeBme280() first.');
    }
    // ignore: prefer_typing_uninitialized_variables
    var getBme280Data;
    try {
      getBme280Data = bme280.getValues();
    } catch (e) {
      debugPrint('Error reading sensor data: $e');
      disposeI2c();
      return {
        'temperature': 0.0,
        'humidity': 0.0,
        'pressure': 0.0,
      };
    }
    final temperatureResults = getBme280Data.temperature.toDouble();
    final humidityResults = getBme280Data.humidity.toDouble();
    final pressureResults = getBme280Data.pressure.toDouble();

    return {
      'temperature': temperatureResults,
      'humidity': humidityResults,
      'pressure': pressureResults,
    };
  }

  void startPolling(Function(Map<String, double>) onData) {
    _pollingTimer = Timer.periodic(pollingInterval, (_) async {
      try {
        final data = await readSensorData();
        onData(data);
      } catch (e) {
        debugPrint('Error polling I2C device: $e');
        disposeI2c();
      }
    });
  }

  void disposeI2c() {
    stopPolling();
    i2c.dispose();
  }
}