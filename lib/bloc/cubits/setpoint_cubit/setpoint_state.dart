part of 'setpoint_cubit.dart';

 class SetpointState extends Equatable {
  final int temperatureSetpoint;
  final int humiditySetpoint;
  const SetpointState({
    required this.temperatureSetpoint,
    required this.humiditySetpoint,
  });
  factory SetpointState.initial() {
    return const SetpointState(
      temperatureSetpoint: 0,
      humiditySetpoint: 0,
    );
  }
@override
  List<Object> get props => [temperatureSetpoint, humiditySetpoint];

  SetpointState copyWith({
    int? temperatureSetpoint,
    int? humiditySetpoint,
  }) {
    return SetpointState(
      temperatureSetpoint: temperatureSetpoint ?? this.temperatureSetpoint,
      humiditySetpoint: humiditySetpoint ?? this.humiditySetpoint,
    );
  }

  @override
  String toString() =>
      'SetpointState(temperatureSetpoint: $temperatureSetpoint, humiditySetpoint: $humiditySetpoint)';
}

