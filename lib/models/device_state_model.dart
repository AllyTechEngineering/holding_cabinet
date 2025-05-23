import 'package:equatable/equatable.dart';

class DeviceStateModel extends Equatable {
  final double i2cTemperature;
  final double i2cHumidity;
  final double i2cPressure;
  final double tempertureSetPoint;
  final double humiditySetPoint;
  final double pwmDutyCycle;
  final bool pwmOn;
  final int flashRate;
  final bool flashOn;
  final DateTime timerStart;
  final DateTime timerEnd;
  final bool gpioSensorState;
  final bool toggleDeviceState;

  const DeviceStateModel({
    required this.i2cTemperature,
    required this.i2cHumidity,
    required this.i2cPressure,
    required this.tempertureSetPoint,
    required this.humiditySetPoint,
    required this.pwmDutyCycle,
    required this.pwmOn,
    required this.flashRate,
    required this.flashOn,
    required this.timerStart,
    required this.timerEnd,
    required this.gpioSensorState,
    required this.toggleDeviceState,
  });

  // Create a copy of the model with optional changes
  DeviceStateModel copyWith({
    double? i2cTemperature,
    double? i2cHumidity,
    double? i2cPressure,
    double? tempertureSetPoint,
    double? humiditySetPoint,
    double? pwmDutyCycle,
    bool? pwmOn,
    int? flashRate,
    bool? flashOn,
    DateTime? timerStart,
    DateTime? timerEnd,
    bool? gpioSensorState,
    bool? toggleDeviceState,
  }) {
    return DeviceStateModel(
      i2cTemperature: i2cTemperature ?? this.i2cTemperature,
      i2cHumidity: i2cHumidity ?? this.i2cHumidity,
      i2cPressure: i2cPressure ?? this.i2cPressure,
      tempertureSetPoint: tempertureSetPoint ?? this.tempertureSetPoint,
      humiditySetPoint: humiditySetPoint ?? this.humiditySetPoint,
      pwmDutyCycle: pwmDutyCycle ?? this.pwmDutyCycle,
      pwmOn: pwmOn ?? this.pwmOn,
      flashRate: flashRate ?? this.flashRate,
      flashOn: flashOn ?? this.flashOn,
      timerStart: timerStart ?? this.timerStart,
      timerEnd: timerEnd ?? this.timerEnd,
      gpioSensorState: gpioSensorState ?? this.gpioSensorState,
      toggleDeviceState: toggleDeviceState ?? this.toggleDeviceState,
    );
  }

  // Convert to JSON for MQTT integration
  Map<String, dynamic> toJson() {
    return {
      "i2cTemperature": i2cTemperature,
      "i2cHumidity": i2cHumidity,
      "i2cPressure": i2cPressure,
      "tempertureSetPoint": tempertureSetPoint,
      "humiditySetPoint": humiditySetPoint,
      "pwmDutyCycle": pwmDutyCycle,
      "pwmOn": pwmOn,
      "flashRate": flashRate,
      "flashOn": flashOn,
      "timerStart": timerStart.toIso8601String(),
      "timerEnd": timerEnd.toIso8601String(),
      "gpioSensorState": gpioSensorState,
      "toggleDeviceState": toggleDeviceState,
    };
  }

  // Create from JSON (for MQTT receiving)
  factory DeviceStateModel.fromJson(Map<String, dynamic> json) {
    return DeviceStateModel(
      i2cTemperature: json["i2cTemperature"] ?? 0.0, // Default to 0.0 if null
      i2cHumidity: json["i2cHumidity"] ?? 0.0, // Default to 0.0 if null
      i2cPressure: json["i2cPressure"] ?? 0.0, // Default to 0.0 if null
      tempertureSetPoint:
          json["tempertureSetPoint"] ?? 20, // Default to 0 if null
      humiditySetPoint: json["humiditySetPoint"] ?? 0, // Default to 0 if null
      pwmDutyCycle: json["pwmDutyCycle"] ?? 0, // Default to 0 if null
      pwmOn: json["pwmOn"] ?? false, // Default to false if null
      flashRate: json["flashRate"] ?? 0, // Default to 0 if null
      flashOn: json["flashOn"] ?? false, // Default to false if null
      timerStart: json["timerStart"] != null
          ? DateTime.parse(json["timerStart"])
          : DateTime.now(), // Default to current time if null
      timerEnd: json["timerEnd"] != null
          ? DateTime.parse(json["timerEnd"])
          : DateTime.now().add(const Duration(minutes: 1)), // Default +1 min
      gpioSensorState: json["gpioSensorState"] ?? false, // Default to false
      toggleDeviceState: json["toggleDeviceState"] ?? false, // Default to false
    );
  }

  // factory DeviceStateModel.fromJson(Map<String, dynamic> json) {
  //   return DeviceStateModel(
  //     pwmDutyCycle: json["pwmDutyCycle"],
  //     pwmOn: json["pwmOn"],
  //     flashRate: json["flashRate"],
  //     flashOn: json["flashOn"],
  //     timerStart: DateTime.parse(json["timerStart"]),
  //     timerEnd: DateTime.parse(json["timerEnd"]),
  //     gpioSensorState: json["gpioSensorState"],
  //     toggleDeviceState: json["toggleDeviceState"],
  //   );
  // }

  @override
  List<Object> get props => [
        i2cTemperature,
        i2cHumidity,
        i2cPressure,
        tempertureSetPoint,
        humiditySetPoint,
        pwmDutyCycle,
        pwmOn,
        flashRate,
        flashOn,
        timerStart,
        timerEnd,
        gpioSensorState,
        toggleDeviceState,
      ];
}
