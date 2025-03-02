import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/services/i2c_service.dart';

part 'i2c_state.dart';

class I2cCubit extends Cubit<I2cState> {
  final I2CService _i2cService;
  final DataRepository _dataRepository;

  I2cCubit(this._dataRepository, this._i2cService) : super(I2cState.initial()) {
    try {
      _i2cService.initializeBme280();
      // Start polling the sensor data.
      _i2cService.startPolling((data) {
        final temperature = data['temperature'] ?? 0.0;
        final humidity = data['humidity'] ?? 0.0;
        final pressure = data['pressure'] ?? 0.0;

        // Update the cubit state.
        emit(state.copyWith(
          temperature: temperature,
          humidity: humidity,
          pressure: pressure,
        ));

        // Update the DataRepository (single source of truth) with the new sensor values.
        final currentDeviceState = _dataRepository.deviceState;
        // Assumes DeviceStateModel has a copyWith method.
        final updatedDeviceState = currentDeviceState.copyWith(
          i2cTemperature: temperature,
          i2cHumidity: humidity,
          i2cPressure: pressure,
        );
        _dataRepository.updateDeviceState(updatedDeviceState);
      });
    } catch (e) {
      debugPrint('Error starting I2C: $e');
    }
  }

  @override
  Future<void> close() {
    // Stop polling if needed when the cubit is closed.
    _i2cService.stopPolling();
    return super.close();
  }
}
