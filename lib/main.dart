// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:udemy_mqtt_demo_linux/bloc/cubits/flash_cubit/flash_cubit.dart';
import 'package:udemy_mqtt_demo_linux/bloc/cubits/pwm_cubit/pwm_cubit.dart';
import 'package:udemy_mqtt_demo_linux/bloc/cubits/sensor_cubit/sensor_cubit.dart';
import 'package:udemy_mqtt_demo_linux/bloc/cubits/timer_cubit/timer_cubit.dart';
import 'package:udemy_mqtt_demo_linux/bloc/cubits/toggle_cubit/toggle_cubit.dart';
import 'package:udemy_mqtt_demo_linux/bloc/data_repository/data_repository.dart';
import 'package:udemy_mqtt_demo_linux/screens/home_screen.dart';
// import 'package:udemy_mqtt_demo/services/gpio_services.dart';
// import 'package:udemy_mqtt_demo/services/pwm_services.dart';
import 'package:udemy_mqtt_demo_linux/services/timer_services.dart';
import 'package:udemy_mqtt_demo_linux/utilities/custom_app_theme.dart';

// import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from the .env file.
  await dotenv.load(fileName: "lib/.env");

  // Initialize services
  // final pwmService = PwmService();
  // final gpioService = GpioService();
  final timerService = TimerService();

  // Initialize DataRepository
  final dataRepository = DataRepository();

  // gpioService.initializeGpioService();

  // Ensure window_manager is initialized
  // await windowManager.ensureInitialized();
  // final windowListener = MyWindowListener();
  // windowManager.addListener(windowListener);

  runApp(MyApp(
    dataRepository: dataRepository,
    // pwmService: pwmService,
    // gpioService: gpioService,
    timerService: timerService,
  ));
}

// class MyWindowListener extends WindowListener {
//   // final PwmService pwmService;
//   // final GpioService gpioService;

//   MyWindowListener();

//   @override
//   void onWindowClose() async {
//     debugPrint("Window close detected, disposing resources...");
//     // pwmService.dispose();
//     // gpioService.dispose();
//     windowManager.destroy(); // Call destroy as a function
//     exit(0);
//   }
// }

class MyApp extends StatelessWidget {
  final DataRepository dataRepository;
  // final PwmService pwmService;
  // final GpioService gpioService;
  final TimerService timerService;

  const MyApp({
    super.key,
    required this.dataRepository,
    // required this.pwmService,
    // required this.gpioService,
    required this.timerService,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => dataRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => PwmCubit(dataRepository)),
          BlocProvider(
              create: (context) => FlashCubit(dataRepository)),
          BlocProvider(
              create: (context) => TimerCubit(dataRepository, timerService)),
          BlocProvider(
              create: (context) => SensorCubit(dataRepository)),
          BlocProvider(
              create: (context) => ToggleCubit(dataRepository)),
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
