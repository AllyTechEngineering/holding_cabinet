import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holding_cabinet/bloc/cubits/i2c_cubit/i2c_cubit.dart';
import 'package:holding_cabinet/utilities/data_container.dart';
import 'package:holding_cabinet/widgets/toggle_switch.dart';

class PressureOnOffWidget extends StatelessWidget {
  const PressureOnOffWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<I2cCubit, I2cState>(
          builder: (context, state) {
            if (state is I2cLoaded) {
              final pressure = state.sensorData.pressure.toStringAsFixed(1);
              return DataContainer(
                  label: 'Baro Pressure', value: '$pressure hPa');
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
    );
  }
}
