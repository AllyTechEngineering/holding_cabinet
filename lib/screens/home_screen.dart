import 'package:flutter/material.dart';
import 'package:holding_cabinet/widgets/humidifier_widget.dart';
import 'package:holding_cabinet/widgets/pressure_on_off_widget.dart';
import 'package:holding_cabinet/widgets/pwm_slider.dart';
import 'package:holding_cabinet/widgets/temperature_widget.dart';
import 'package:firebase_dart/firebase_dart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/auth');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text('Holding Cabinet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
            onPressed: () => _logout(context),
          ),
        ],
      ),
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
