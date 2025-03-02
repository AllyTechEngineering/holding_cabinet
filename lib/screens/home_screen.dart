import 'package:flutter/material.dart';
import 'package:holding_cabinet/widgets/flash_slider.dart';
import 'package:holding_cabinet/widgets/flash_toggle_switch.dart';
import 'package:holding_cabinet/widgets/i2c_data.dart';
import 'package:holding_cabinet/widgets/pwm_slider.dart';
import 'package:holding_cabinet/widgets/pwm_toggle_switch.dart';
import 'package:holding_cabinet/widgets/sensor_state_widget.dart';
// import 'package:udemy_mqtt_demo/widgets/timer_widget.dart';
import 'package:holding_cabinet/widgets/toggle_switch.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // const Expanded(
          //   child: TimerWidget(),
          // ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlashSlider(),
                SizedBox(height: 20),
                FlashToggleSwitch(),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PwmSlider(),
                SizedBox(height: 20),
                PwmToggleSwitch(),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                I2cData(),
                SizedBox(height: 20),
                ToggleSwitch(),
                SizedBox(height: 20),
                SensorStateWidget(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
