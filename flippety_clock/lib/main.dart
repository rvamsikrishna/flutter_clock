import 'package:flippety_clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

void main() {
  //To access (ServicesBinding.defaultBinaryMessenger before the binding was initialized
  //and`runApp()`has been called (for example, during plugin initialization),
// then you need to explicitly call the `WidgetsFlutterBinding.ensureInitialized()` first.
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  //This is a  bit modified version of ClockCustomizer provided with the
  //flutter_clock_helper
  runApp(ClockCustomizer((ClockModel model) => Clock(model)));
}
