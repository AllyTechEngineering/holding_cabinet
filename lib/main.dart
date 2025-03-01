import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:holding_cabinet/bloc/cubits/flash_cubit/flash_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/pwm_cubit/pwm_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/sensor_cubit/sensor_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/timer_cubit/timer_cubit.dart';
import 'package:holding_cabinet/bloc/cubits/toggle_cubit/toggle_cubit.dart';
import 'package:holding_cabinet/bloc/data_repository/data_repository.dart';
import 'package:holding_cabinet/screens/home_screen.dart';
import 'package:holding_cabinet/services/gpio_services.dart';
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

  // Initialize DataRepository
  final dataRepository = DataRepository();

  // gpioService.initializeGpioService();

  // Ensure window_manager is initialized
  await windowManager.ensureInitialized();
  final windowListener = MyWindowListener(pwmService, gpioService);
  windowManager.addListener(windowListener);

  runApp(MyApp(
    dataRepository: dataRepository,
    pwmService: pwmService,
    gpioService: gpioService,
    timerService: timerService,
  ));
}

class MyWindowListener extends WindowListener {
  final PwmService pwmService;
  final GpioService gpioService;

  MyWindowListener(this.pwmService, this.gpioService);

  @override
  void onWindowClose() async {
    debugPrint("Window close detected, disposing resources...");
    pwmService.dispose();
    gpioService.dispose();
    windowManager.destroy(); // Call destroy as a function
    exit(0);
  }
}

class MyApp extends StatelessWidget {
  final DataRepository dataRepository;
  final PwmService pwmService;
  final GpioService gpioService;
  final TimerService timerService;

  const MyApp({
    super.key,
    required this.dataRepository,
    required this.pwmService,
    required this.gpioService,
    required this.timerService,
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
              create: (context) => ToggleCubit(dataRepository, gpioService)),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MQTT Demo',
          theme: CustomAppTheme.appTheme,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}