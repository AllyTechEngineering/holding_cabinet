part of 'i2c_cubit.dart';
// i2c_state.dart


abstract class I2cState extends Equatable {
  const I2cState();

  @override
  List<Object?> get props => [];
}

class I2cLoading extends I2cState {
  const I2cLoading();
}

class I2cLoaded extends I2cState {
  final I2cModel sensorData;
  const I2cLoaded(this.sensorData);

  @override
  List<Object?> get props => [sensorData];

  @override
  String toString() => 'I2cLoaded(sensorData: $sensorData)';
}

class I2cError extends I2cState {
  final String message;
  const I2cError(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => 'I2cError(message: $message)';
}
