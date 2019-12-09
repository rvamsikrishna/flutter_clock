import 'dart:async';

import 'package:flippety_clock/digit_matrix_widget.dart';
import 'package:flippety_clock/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

class Clock extends StatefulWidget {
  final ClockModel model;
  const Clock(
    this.model, {
    Key key,
  }) : super(key: key);

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  String _temperature = '';
  String _condition = '';
  IconData _weatherConditionIcon;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(Clock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _condition = widget.model.weatherString.toUpperCase();
      _weatherConditionIcon = widget.model.weatherConditionIcon;
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    final colors = Theme.of(context).brightness == Brightness.light
        ? lightTheme
        : darkTheme;

    //To get the max width allowed by the parent widget i.e AspectRatio
    //This is used to consider for the SafeArea like notches or status
    //bar when being test on the mobile. Otherwise MediaQuery could be used
    //to get the screen width.
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      //The width of the clockface.
      final double clockWidth = constraints.maxWidth;
      //vertical margin in the clockface.
      final double clockVerticalPadding = clockWidth * 0.045;
      //Margin for each cube in the digit matrix.
      final double eachCubeMargin = clockWidth * 0.005;
      //Size for each cube in the digit matrix.
      final double cubeSize = (clockWidth - 20 * eachCubeMargin) / 19;
      final double fontSize = clockWidth * 0.05;

      return Container(
        padding: EdgeInsets.symmetric(vertical: clockVerticalPadding),
        color: colors[ThemeElement.notFlipped],
        child: DefaultTextStyle(
          style: TextStyle(
            color: colors[ThemeElement.flipped],
            fontSize: fontSize,
            fontFamily: 'Righteous',
          ),
          child: Column(
            children: <Widget>[
              Text(_temperature),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //the first digit of the hour
                    DigitMatrixWidget(
                      digit: int.parse(hour.split('')[0]),
                      cubeSize: cubeSize,
                      margin: eachCubeMargin,
                      flippedColor: colors[ThemeElement.flipped],
                      unFlippedColor: colors[ThemeElement.notFlipped],
                      shadowColor: colors[ThemeElement.shadow],
                    ),
                    SizedBox(width: cubeSize),
                    //the second digit of the hour
                    DigitMatrixWidget(
                      digit: int.parse(hour.split('')[1]),
                      cubeSize: cubeSize,
                      margin: eachCubeMargin,
                      flippedColor: colors[ThemeElement.flipped],
                      unFlippedColor: colors[ThemeElement.notFlipped],
                      shadowColor: colors[ThemeElement.shadow],
                    ),
                    //the ":" seperator between hour digits and minute digits
                    DigitMatrixWidget(
                      digit: 10,
                      cubeSize: cubeSize,
                      margin: eachCubeMargin,
                      flippedColor: colors[ThemeElement.flipped],
                      unFlippedColor: colors[ThemeElement.notFlipped],
                      shadowColor: colors[ThemeElement.shadow],
                    ),
                    //the first digit of the minute
                    DigitMatrixWidget(
                      digit: int.parse(minute.split('')[0]),
                      cubeSize: cubeSize,
                      margin: eachCubeMargin,
                      flippedColor: colors[ThemeElement.flipped],
                      unFlippedColor: colors[ThemeElement.notFlipped],
                      shadowColor: colors[ThemeElement.shadow],
                    ),
                    SizedBox(width: cubeSize),
                    //the second digit of the minute
                    DigitMatrixWidget(
                      digit: int.parse(minute.split('')[1]),
                      cubeSize: cubeSize,
                      margin: eachCubeMargin,
                      flippedColor: colors[ThemeElement.flipped],
                      unFlippedColor: colors[ThemeElement.notFlipped],
                      shadowColor: colors[ThemeElement.shadow],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    _weatherConditionIcon,
                    size: fontSize,
                    color: colors[ThemeElement.flipped],
                  ),
                  SizedBox(width: 10.0),
                  Text(_condition),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
