import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/models/device_state_model.dart';
import 'package:holding_cabinet/services/gpio_services.dart';
import 'package:holding_cabinet/services/heater_service.dart';
import 'package:holding_cabinet/services/humidifier_service.dart';
import 'package:holding_cabinet/services/pwm_services.dart';

part 'toggle_state.dart';

class ToggleCubit extends Cubit<ToggleState> {
  final DataRepository _dataRepository;
  final GpioService _gpioService;
  final HeaterService _heaterService;
  final HumidifierService _humidifierService;
  final PwmService _pwmService;

  late final StreamSubscription<DeviceStateModel> _repoSubscription;

  ToggleCubit(this._dataRepository, this._gpioService, this._heaterService,
      this._humidifierService,this._pwmService)
      : super(ToggleState(
          toggleDeviceState: _dataRepository.deviceState.toggleDeviceState,
        )) {
    // Subscribe to the repository's stream.
    _repoSubscription = _dataRepository.deviceStateStream.listen((deviceState) {
      final newToggleState = deviceState.toggleDeviceState;
      // Only update hardware if the toggle state has actually changed.
      if (newToggleState != state.toggleDeviceState) {
        debugPrint(
            'ToggleCubit: deviceStateStream received new toggle state: $newToggleState');
        _heaterService.heaterSystemOnOff(newToggleState);
        _humidifierService.humidifierSystemOnOff(newToggleState);
        _gpioService.newToggleDeviceState();
        _pwmService.pwmSystemOnOff(newToggleState);
        emit(ToggleState(toggleDeviceState: newToggleState));
      }
    });
  }

  // Called when the UI toggle switch is used.
  // This method only updates the repository; the stream subscription will then
  // propagate the updated state and update the hardware.
  void updateDeviceState() {
    // debugPrint('ToggleCubit: updateDeviceState');
    final currentState = _dataRepository.deviceState.toggleDeviceState;
    final newState = !currentState;
    final updatedState =
        _dataRepository.deviceState.copyWith(toggleDeviceState: newState);
    _dataRepository.updateDeviceState(updatedState);
  }

  @override
  Future<void> close() {
    _repoSubscription.cancel();
    return super.close();
  }
}
