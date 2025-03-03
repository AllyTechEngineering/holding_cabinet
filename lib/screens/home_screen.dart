import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_cabinet/bloc/cubits/i2c_cubit/i2c_cubit.dart';
import 'package:holding_cabinet/widgets/humidity_setpoint_slider.dart';
import 'package:holding_cabinet/widgets/temp_setpoint_slider.dart';
import 'package:holding_cabinet/widgets/toggle_switch.dart';

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<I2cCubit, I2cState>(
                  builder: (context, state) {
                    if (state is I2cLoaded) {
                      final temp =
                          state.sensorData.temperature.toStringAsFixed(1);
                      return Text(
                        textAlign: TextAlign.center,
                        'Current Temperature:\n$temp°C',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } else if (state is I2cLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is I2cError) {
                      return Text('Error: ${state.message}');
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                const TempSetpointSlider(),
              ],
            ),
          ),
          // Middle Column: Humidity display above HumiditySetpointSlider.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<I2cCubit, I2cState>(
                  builder: (context, state) {
                    if (state is I2cLoaded) {
                      final humidity =
                          state.sensorData.humidity.toStringAsFixed(1);
                      return Text(
                        textAlign: TextAlign.center,
                        'Current Humidity:\n$humidity%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } else if (state is I2cLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is I2cError) {
                      return Text('Error: ${state.message}');
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                const HumiditySetpointSlider(),
              ],
            ),
          ),
          // Right Column: Pressure display above ToggleSwitch.
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<I2cCubit, I2cState>(
                  builder: (context, state) {
                    if (state is I2cLoaded) {
                      final pressure =
                          state.sensorData.pressure.toStringAsFixed(1);
                      return Text(
                        textAlign: TextAlign.center,
                        'Current Pressure:\n$pressure hPa',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      );
                    } else if (state is I2cLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is I2cError) {
                      return Text('Error: ${state.message}');
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 20),
                const ToggleSwitch(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
