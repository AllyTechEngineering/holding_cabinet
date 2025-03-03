import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holding_cabinet/bloc/cubits/flash_cubit/flash_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/i2c_cubit/i2c_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/pwm_cubit/pwm_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/sensor_cubit/sensor_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/setpoint_cubit/setpoint_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/timer_cubit/timer_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/toggle_cubit/toggle_cubit.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/screens/home_screen.dart';
import 'package:holding_cabinet/services/gpio_services.dart';
import 'package:holding_cabinet/services/heater_service.dart';
import 'package:holding_cabinet/services/humidifier_service.dart';
import 'package:holding_cabinet/services/i2c_service.dart';
import 'package:holding_cabinet/services/pwm_services.dart';
import 'package:holding_cabinet/services/timer_services.dart';
import 'package:holding_cabinet/utilities/custom_app_theme.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file.
  await dotenv.load(fileName: "lib/.env");

  // Initialize services
  final pwmService = PwmService();
  final gpioService = GpioService();
  final timerService = TimerService();
  final i2cService = I2CService();
  final heaterService = HeaterService();
  final humidifierService = HumidifierService();

  // Initialize DataRepository
  final dataRepository = DataRepository();

  // gpioService.initializeGpioService();

  // Ensure window_manager is initialized
  await windowManager.ensureInitialized();
  final windowListener = MyWindowListener(
      pwmService, gpioService, heaterService, humidifierService, i2cService);
  windowManager.addListener(windowListener);

  runApp(MyApp(
    dataRepository: dataRepository,
    pwmService: pwmService,
    gpioService: gpioService,
    timerService: timerService,
    i2cService: i2cService,
    heaterService: heaterService,
    humidifierService: humidifierService,
  ));
}

class MyWindowListener extends WindowListener {
  final PwmService pwmService;
  final GpioService gpioService;
  final HeaterService heaterService;
  final HumidifierService humidifierService;
  final I2CService i2cService;

  MyWindowListener(this.pwmService, this.gpioService, this.heaterService,
      this.humidifierService, this.i2cService);

  @override
  void onWindowClose() async {
    debugPrint("Window close detected, disposing resources...");
    pwmService.dispose();
    gpioService.dispose();
    heaterService.dispose();
    humidifierService.dispose();
    i2cService.dispose();
    windowManager.destroy(); // Call destroy as a function
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  final DataRepository dataRepository;
  final PwmService pwmService;
  final GpioService gpioService;
  final TimerService timerService;
  final I2CService i2cService;
  final HeaterService heaterService;
  final HumidifierService humidifierService;

  const MyApp({
    super.key,
    required this.dataRepository,
    required this.pwmService,
    required this.gpioService,
    required this.timerService,
    required this.i2cService,
    required this.heaterService,
    required this.humidifierService,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => dataRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PwmCubit(dataRepository, pwmService)),
          BlocProvider(
              create: (context) => FlashCubit(dataRepository, gpioService)),
          BlocProvider(
              create: (context) => TimerCubit(dataRepository, timerService)),
          BlocProvider(
              create: (context) => SensorCubit(dataRepository, gpioService)),
          BlocProvider(
              create: (context) => ToggleCubit(dataRepository, gpioService,
                  heaterService, humidifierService)),
          BlocProvider(
              create: (context) =>
                  I2cCubit(dataRepository, i2cService, heaterService,
                      humidifierService)),
          BlocProvider(
              create: (context) => SetpointCubit(
                  dataRepository, heaterService, humidifierService)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Holding Cabinet',
          theme: CustomAppTheme.appTheme,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
