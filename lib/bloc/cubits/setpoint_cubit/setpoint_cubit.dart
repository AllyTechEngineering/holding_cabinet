import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/services/heater_service.dart';
import 'package:holding_cabinet/services/humidifier_service.dart';

part 'setpoint_state.dart';

class SetpointCubit extends Cubit<SetpointState> {
  final DataRepository _dataRepository;
  final HeaterService _heaterService;
  final HumidifierService _humidifierService;

  SetpointCubit(
      this._dataRepository, this._heaterService, this._humidifierService)
      : super(SetpointState.initial()) {
    // Initialize the heater and humidifier services
  }
  void updateTempSetpoint(int value) {
    debugPrint('Temperature Setpoint: $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(tempertureSetPoint: value);
    _dataRepository.updateDeviceState(updatedState);
  }
    void updateHumiditySetpoint(int value) {
    debugPrint('Humidity Setpoint: $value');
    final updatedState =
        _dataRepository.deviceState.copyWith(humiditySetPoint: value);
    _dataRepository.updateDeviceState(updatedState);
  }
}
