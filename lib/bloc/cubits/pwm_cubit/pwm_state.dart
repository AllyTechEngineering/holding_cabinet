part of 'pwm_cubit.dart';

class PwmState extends Equatable {
  final double dutyCycle;
  final bool isPwmOn;
  
  const PwmState({required this.dutyCycle, required this.isPwmOn});

  @override
  List<Object> get props => [dutyCycle, isPwmOn];

  PwmState copyWith({
    double? dutyCycle,
    bool? isPwmOn,
  }) {
    return PwmState(
      dutyCycle: dutyCycle ?? this.dutyCycle,
      isPwmOn: isPwmOn ?? this.isPwmOn,
    );
  }

  @override
  String toString() => 'PwmState(dutyCycle: $dutyCycle, isPwmOn: $isPwmOn)';
}
