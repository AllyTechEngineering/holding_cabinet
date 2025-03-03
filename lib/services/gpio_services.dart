import 'dart:async';
import 'package:dart_periphery/dart_periphery.dart';
import 'package:flutter/foundation.dart';
import 'package:holding_cabinet/utilities/constants.dart';


class GpioService {
  static final GpioService _instance = GpioService._internal();
  static final Duration _pollingDuration =
      const Duration(milliseconds: Constants.kPollingDuration);
  Timer? _pollingTimer;
  Timer? _flashTimer;
  late GPIO _gpio5;
  late GPIO _gpio6;
  late GPIO _gpio22;
  late GPIO _gpio16;
  late GPIO _gpio27;
  static int _flashRate = 0;

  // Use a map for managing boolean states
  final Map<String, bool> _gpioStates = {
    "directionState": true, // true = forward, false = backward
    "toggleDeviceState": false,
    "isInputDetected": false,
    "isPolling": false,
    "currentInputState": false,
    "isFlashing": true,
  };

  factory GpioService() => _instance;

  GpioService._internal() {
    _initializeGpios();
  }

  void _initializeGpios() {
    _initializeGpio(5, GPIOdirection.gpioDirOut, false, (gpio) => _gpio5 = gpio);
    _initializeGpio(6, GPIOdirection.gpioDirOut, false, (gpio) => _gpio6 = gpio);
    _initializeGpio(22, GPIOdirection.gpioDirOut, false, (gpio) => _gpio22 = gpio);
    _initializeGpio(27, GPIOdirection.gpioDirOut, false, (gpio) => _gpio27 = gpio);
    _initializeGpio(16, GPIOdirection.gpioDirIn, null, (gpio) {
      _gpio16 = gpio;
      bool initialInput = _gpio16.read();
      setState("isInputDetected", initialInput);
      setLedState(initialInput);
      // debugPrint('_gpio16 initial state: $initialInput');
    });
  }

  void _initializeGpio(int pin, GPIOdirection direction, bool? initialState,
      Function(GPIO) assignGpio) {
    try {
      GPIO gpio = GPIO(pin, direction, 0);
      if (initialState != null) {
        gpio.write(initialState);
      }
      assignGpio(gpio);
      debugPrint('GPIO $pin initialized');
    } on Exception catch (e) {
      debugPrint('Error initializing GPIO $pin: $e');
    }
  }

  // Getters for boolean states
  bool get directionState => _gpioStates["directionState"]!;
  bool get toggleDeviceState => _gpioStates["toggleDeviceState"]!;
  bool get isInputDetected => _gpioStates["isInputDetected"]!;
  bool get isPolling => _gpioStates["isPolling"]!;
  bool get currentInputState => _gpioStates["currentInputState"]!;
  bool get isFlashing => _gpioStates["isFlashing"]!;

  // Methods to modify state values
  void setState(String key, bool value) {
    _gpioStates[key] = value;
  }

  Stream<bool> pollInputState() async* {
    // Read and yield the initial state
    bool lastState = _gpio16.read();
    setState("isInputDetected", lastState);
    setLedState(lastState);
    yield lastState; // Yield the initial state immediately

    // Continuously poll _gpio16 without blocking the main thread
    while (true) {
      await Future.delayed(_pollingDuration);
      bool newState = _gpio16.read();
      if (newState != lastState) {
        lastState = newState;
        setState("isInputDetected", newState);
        setLedState(newState);
        yield newState;
      }
    }
  }

  // Sensor input LED control
  void setLedState(bool state) {
    _gpio27.write(state);
  }

  void stopInputPolling() {
    _pollingTimer?.cancel();
    setState("isPolling", false);
  }

  // GPIO Output Control
  void newToggleDeviceState() {
    final bool newState = !toggleDeviceState; // Toggle the state
    setState("toggleDeviceState", newState);
    _gpio5.write(newState);
  }

  void setRelayState(bool state) {
    _gpio6.write(state);
  }

  void pwmMotorServiceDirection() {
    _gpio5.write(true);
    _gpio6.write(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState("directionState", !directionState);
      _gpio5.write(!directionState);
      _gpio6.write(directionState);
    });
  }

  void toggleFlashState() {
   // debugPrint('Toggling flash state');
    bool currentState = isFlashing;
    setState("isFlashing", !currentState);
    updateDeviceFlashRate(_flashRate);
  }

  void updateDeviceFlashRate(int newFlashRate) {
   // debugPrint('Updating flash rate to $newFlashRate');
    _flashRate = newFlashRate;
    _flashTimer?.cancel(); // Cancel any existing timer

    if (newFlashRate == 0 || !isFlashing) {
      _gpio22.write(false); // Ensure LED is off if not flashing
    } else {
      _flashTimer = Timer.periodic(Duration(milliseconds: _flashRate), (_) {
        _gpio22.write(!_gpio22.read()); // Toggle LED state
      });
    }
  }

  // Disposal
  void dispose() {
    _pollingTimer?.cancel();
    _flashTimer?.cancel();

    // Ensure all GPIOs are set to a safe state before disposing
    for (var gpio in [_gpio5, _gpio6, _gpio22, _gpio27]) {
      gpio.write(false);
    }

    // Dispose all GPIOs
    for (var gpio in [_gpio5, _gpio6, _gpio22, _gpio16, _gpio27]) {
      gpio.dispose();
    }

    debugPrint('GPIO resources released');
  }
}