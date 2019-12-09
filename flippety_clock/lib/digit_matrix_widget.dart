import 'package:flippety_clock/cube.dart';
import 'package:flutter/material.dart';

class DigitMatrixWidget extends StatelessWidget {
  const DigitMatrixWidget({
    Key key,
    @required this.digit,
    this.cubeSize,
    this.margin = 0.0,
    this.flippedColor,
    this.unFlippedColor,
    this.shadowColor,
  }) : super(key: key);

  final int digit;
  final double cubeSize;
  final double margin;
  final Color flippedColor;
  final Color unFlippedColor;
  final Color shadowColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ..._digits[digit].map(
          (List<int> row) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ...row.map(
                  (c) {
                    return Container(
                      margin: EdgeInsets.all(margin),
                      child: Cube(
                        size: cubeSize,
                        flipped: c == 1,
                        flippedColor: flippedColor,
                        unFlippedColor: unFlippedColor,
                        shadowColor: shadowColor,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

Map<int, List<List<int>>> _digits = {
  10: [
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
    [0, 1, 0],
    [0, 0, 0],
  ],
  0: [
    [1, 1, 1],
    [1, 0, 1],
    [1, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  1: [
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
    [0, 1, 0],
  ],
  2: [
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
  ],
  3: [
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  4: [
    [1, 0, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  5: [
    [1, 1, 1],
    [1, 0, 0],
    [1, 1, 1],
    [0, 0, 1],
    [1, 1, 1],
  ],
  6: [
    [1, 0, 0],
    [1, 0, 0],
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  7: [
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
  8: [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
  ],
  9: [
    [1, 1, 1],
    [1, 0, 1],
    [1, 1, 1],
    [0, 0, 1],
    [0, 0, 1],
  ],
};
