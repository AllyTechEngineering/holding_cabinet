import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/models/i2c_model.dart';
import 'package:holding_cabinet/services/heater_service.dart';
import 'package:holding_cabinet/services/humidifier_service.dart';
import 'package:holding_cabinet/services/i2c_service.dart';

part 'i2c_state.dart';

class I2cCubit extends Cubit<I2cState> {
  final I2CService _i2cService;
  final HeaterService _heaterService;
  final HumidifierService _humidifierService;
  final DataRepository _dataRepository;

  I2cCubit(this._dataRepository, this._i2cService, this._heaterService, this._humidifierService)
      : super(const I2cLoading()) {
    try {
      _i2cService.startPolling((sensorModel) {
        // When new sensor data is received, emit the loaded state.
        emit(I2cLoaded(sensorModel));

        // Update the DataRepository with new sensor values.
        final currentDeviceState = _dataRepository.deviceState;
        final updatedDeviceState = currentDeviceState.copyWith(
          i2cTemperature: sensorModel.temperature,
          i2cHumidity: sensorModel.humidity,
          i2cPressure: sensorModel.pressure,
        );
        _dataRepository.updateDeviceState(updatedDeviceState);
        _heaterService.updateI2cTemp(sensorModel.temperature);
        _humidifierService.updateI2cHumidity(sensorModel.humidity);
      }, onError: (error) {
        // In case of errors, emit an error state.
        emit(I2cError(error.toString()));
      });
    } catch (e) {
      debugPrint('Error starting I2C: $e');
      emit(I2cError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _i2cService.stopPolling();
    return super.close();
  }
}