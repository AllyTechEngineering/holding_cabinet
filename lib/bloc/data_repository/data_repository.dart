import 'dart:async';
// import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/models/device_state_model.dart';
import 'package:holding_cabinet/services/mqtt_service.dart';
import 'package:holding_cabinet/services/firebase_service.dart';

class DataRepository {
  DeviceStateModel _deviceState = DeviceStateModel(
    i2cTemperature: 0.0,
    i2cHumidity: 0.0,
    i2cPressure: 0.0,
    tempertureSetPoint: 20,
    humiditySetPoint: 0,
    pwmDutyCycle: 0.0,
    pwmOn: true,
    flashRate: 0,
    flashOn: true,
    timerStart: DateTime.now(),
    timerEnd: DateTime.now().add(const Duration(minutes: 1)),
    gpioSensorState: false,
    toggleDeviceState: false,
  );
  // Firebase service instance for database operations.
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> initialize() async {
    await _firebaseService.initialize();
  }

  Future<void> updateDeviceTemp(double value) {
    return _firebaseService.writeData('devices/pi5/temp', value);
  }

  Future<dynamic> fetchDeviceTemp() {
    return _firebaseService.readData('devices/pi5/temp');
  }

  late MqttService mqttService;

  // Broadcast stream controller so multiple listeners (cubits) can subscribe.
  final _stateController = StreamController<DeviceStateModel>.broadcast();

  DataRepository() {
    _initializeMqttService();
  }

  void _initializeMqttService() {
    mqttService = MqttService(this);
    mqttService.connect();
  }

  // Expose the device state as a stream.
  Stream<DeviceStateModel> get deviceStateStream => _stateController.stream;

  // Getter for the current device state.
  DeviceStateModel get deviceState => _deviceState;

  // Update the state and add the new state to the stream.
  void updateDeviceState(DeviceStateModel newState, {bool publish = true}) {
    // Prevent unnecessary updates.
    if (_deviceState == newState) return;
    _deviceState = newState;
    // debugPrint(
    //     'DataRepository: updateDeviceState called with new state: $newState');
    if (publish) {
      mqttService.publishDeviceState(newState);
    }

    // Emit the new state so all subscribers get updated.
    _stateController.add(newState);
  }

  // Dispose the stream when no longer needed.
  void dispose() {
    _stateController.close();
  }
}
