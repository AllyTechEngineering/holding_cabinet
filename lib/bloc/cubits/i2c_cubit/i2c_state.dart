part of 'i2c_cubit.dart';

class I2cState extends Equatable {
  final double temperature;
  final double humidity;
  final double pressure;

  const I2cState({
    required this.temperature,
    required this.humidity,
    required this.pressure,
  });
  factory I2cState.initial() {
    return const I2cState(
      temperature: 0.0,
      humidity: 0.0,
      pressure: 0.0,
    );
  }

  @override
  List<Object> get props => [temperature, humidity, pressure];

  I2cState copyWith({
    double? temperature,
    double? humidity,
    double? pressure,
  }) {
    return I2cState(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
    );
  }

  @override
  String toString() => 'I2cState(temperature: $temperature, humidity: $humidity, pressure: $pressure)';
}
