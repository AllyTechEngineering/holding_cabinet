import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_cabinet/bloc/cubits/i2c_cubit/i2c_cubit.dart';

class I2cData extends StatelessWidget {
  const I2cData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<I2cCubit, I2cState>(
      builder: (context, state) {
        // Format the sensor values to one decimal place.
        final temperature = state.temperature.toStringAsFixed(1);
        final humidity = state.humidity.toStringAsFixed(1);
        final pressure = state.pressure.toStringAsFixed(1);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Temperature: $temperature°C',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                'Humidity: $humidity%',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                'Pressure: $pressure hPa',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
