// i2c_model.dart
import 'package:equatable/equatable.dart';

class I2cModel extends Equatable {
  final double temperature;
  final double humidity;
  final double pressure;

  const I2cModel({
    required this.temperature,
    required this.humidity,
    required this.pressure,
  });

  factory I2cModel.initial() => const I2cModel(
        temperature: 0.0,
        humidity: 0.0,
        pressure: 0.0,
      );

  @override
  List<Object> get props => [temperature, humidity, pressure];

  I2cModel copyWith({
    double? temperature,
    double? humidity,
    double? pressure,
  }) {
    return I2cModel(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
    );
  }

  @override
  String toString() =>
      'I2cModel(temperature: $temperature, humidity: $humidity, pressure: $pressure)';
}
