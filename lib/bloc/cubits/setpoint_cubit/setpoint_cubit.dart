import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/models/device_state_model.dart';
import 'package:holding_cabinet/services/heater_service.dart';
import 'package:holding_cabinet/services/humidifier_service.dart';

part 'setpoint_state.dart';

class SetpointCubit extends Cubit<SetpointState> {
  final DataRepository _dataRepository;
  final HeaterService _heaterService;
  final HumidifierService _humidifierService;
  late final StreamSubscription<DeviceStateModel> _repoSubscription;

  SetpointCubit(
      this._dataRepository, this._heaterService, this._humidifierService)
      : super(SetpointState(
          temperatureSetpoint: _dataRepository.deviceState.tempertureSetPoint,
          humiditySetpoint: _dataRepository.deviceState.humiditySetPoint,
        )) {
    // Subscribe to the repository's state stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newTemperatureSetpoint = deviceState.tempertureSetPoint;
      final newHumiditySetpoint = deviceState.humiditySetPoint;
      // Emit the new state so that the UI is updated.
      emit(SetpointState(
        temperatureSetpoint: newTemperatureSetpoint,
        humiditySetpoint: newHumiditySetpoint,
      ));
    });
  }
  void updateTempSetpoint(int value) {
    debugPrint('Temperature Setpoint: $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(tempertureSetPoint: value);
    _dataRepository.updateDeviceState(updatedState);
  }
  void updateHeaterTempSetpoint(double value) {
    debugPrint('Heater Setpoint: $value');
    _heaterService.updateHeaterTempSetpoint(value);
  }

  void updateHumiditySetpoint(int value) {
    debugPrint('Humidity Setpoint: $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(humiditySetPoint: value);
    _dataRepository.updateDeviceState(updatedState);
  }

    @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
