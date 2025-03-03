import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/models/i2c_model.dart';

class I2CService {
  var i2c = I2C(1);
  // Polling interval is set to 1000ms.
  Duration pollingInterval = const Duration(milliseconds: 1000);
  late Timer _pollingTimer;
  late final BME280 bme280;
  bool _isInitialized = false;

  I2CService() {
    initializeBme280();
  }

  void initializeBme280() {
    try {
      debugPrint('I2C info: ${i2c.getI2Cinfo()}');
      bme280 = BME280(i2c);
      _isInitialized = true;
    } catch (e) {
      dispose();
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
    dynamic sensorValues;
    try {
      sensorValues = bme280.getValues();
    } catch (e) {
      debugPrint('Error reading sensor data: $e');
      dispose();
      return {
        'temperature': 0.0,
        'humidity': 0.0,
        'pressure': 0.0,
      };
    }
    return {
      'temperature': sensorValues.temperature.toDouble(),
      'humidity': sensorValues.humidity.toDouble(),
      'pressure': sensorValues.pressure.toDouble(),
    };
  }

  // startPolling now does an immediate read, then polls every 1000ms.
  void startPolling(Function(I2cModel) onData,
      {Function(Object error)? onError}) async {
    // Perform an immediate read to update the UI right away.
    try {
      final initialData = await readSensorData();
      final sensorModel = I2cModel(
        temperature: initialData['temperature'] ?? 0.0,
        humidity: initialData['humidity'] ?? 0.0,
        pressure: initialData['pressure'] ?? 0.0,
      );
      onData(sensorModel);
    } catch (e) {
      debugPrint('Error during initial sensor read: $e');
      onError?.call(e);
    }

    // Set up the periodic polling.
    _pollingTimer = Timer.periodic(pollingInterval, (_) async {
      try {
        final data = await readSensorData();
        final sensorModel = I2cModel(
          temperature: data['temperature'] ?? 0.0,
          humidity: data['humidity'] ?? 0.0,
          pressure: data['pressure'] ?? 0.0,
        );
        onData(sensorModel);
        // debugPrint('I2C data: $sensorModel');
      } catch (e) {
        debugPrint('Error polling I2C device: $e');
        onError?.call(e);
        dispose();
      }
    });
  }

  void dispose() {
    stopPolling();
    i2c.dispose();
  }
}
