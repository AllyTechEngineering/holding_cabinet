import 'package:flutter/material.dart';
import 'package:holding_cabinet/widgets/humidifier_widget.dart';
import 'package:holding_cabinet/widgets/pressure_on_off_widget.dart';
import 'package:holding_cabinet/widgets/pwm_slider.dart';
import 'package:holding_cabinet/widgets/temperature_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Left Column: Temperature display above TempSetpointSlider.
          Expanded(
            child: PwmSlider(),
          ),
          Expanded(
            child: TemperatureWidget(),
          ),
          // Middle Column: Humidity display above HumiditySetpointSlider.
          Expanded(
            child: HumidifierWidget(),
          ),
          // Right Column: Pressure display above ToggleSwitch.
          Expanded(
            child: PressureOnOffWidget(),
          ),
        ],
      ),
    );
  }
}
