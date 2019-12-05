import 'dart:io';

import 'package:flippety_clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

void main() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  //remove statusbar for android platform to get a fullscreen experience
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }
  //This is a  bit modified version of ClockCustomizer provided with the
  //flutter_clock_helper
  runApp(ClockCustomizer((ClockModel model) => Clock(model)));
}
