import 'package:flutter/material.dart';
import 'dart:math';

///The cube that is rotated on the x-axis where the z-axis is towards
///the user.
///Only 4 sides are shown while rotating on the x-axis alone, so only
///four containers are used within a [Stack].

///Since the stack overlays the children in order from first being at the bootom
///and last veing at the top. While the cube rotates to show different faces
///we hide the non-required faces in order to not overlay them over other
///faces the needs to be shown.
class Cube extends StatefulWidget {
  ///Whether the cube is flipped to show the colored side.
  final bool flipped;

  ///The size of the cube's face.
  final double size;

  ///Color of the flipped side(top and bottom)
  final Color flippedColor;

  ///Color of the flipped side(front and back)
  final Color unFlippedColor;

  ///The glow effect color surrounding the flipped color side.
  final Color shadowColor;

  const Cube({
    Key key,
    this.flipped = false,
    this.size = 50.0,
    this.flippedColor = Colors.white,
    this.unFlippedColor = Colors.black,
    this.shadowColor = Colors.grey,
  }) : super(key: key);
  @override
  _CubeState createState() => _CubeState();
}

class _CubeState extends State<Cube> with SingleTickerProviderStateMixin {
  //The animation that rotates on x-axis from 0 deg to 360 deg.
  Animation<double> _rotationAnimation;

  //Controller that controls the animation.
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 2000))
          ..addListener(() {
            //rebuild
            setState(() {});
          });
    //animates one complete rotation of the cube
    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    if (widget.flipped) {
      //if already flipped rotate the cube 90deg to show flipped color.
      _controller.animateTo(0.25);
    }
  }

  @override
  void didUpdateWidget(Cube oldWidget) {
    if (oldWidget.flipped != widget.flipped) {
      if (_controller.value < 0.75) {
        _animateToNextSide();
      } else {
        //when on the 3rd side complete a rotation to the final
        //fourth side and rest the controller.
        _completeAnimation();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  void _animateToNextSide() {
    if (_controller.status != AnimationStatus.forward)
      //rotate to the next side
      _controller.animateTo(0.25 + _controller.value);
  }

  Future<void> _completeAnimation() async {
    await _controller.animateTo(1.0);
    _controller.reset();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    return AnimatedContainer(
      duration: Duration(milliseconds: widget.flipped ? 300 : 0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        //glow only when flipped or when finished rotation to one side
        boxShadow: widget.flipped &&
                _rotationAnimation.status != AnimationStatus.forward
            ? [
                BoxShadow(
                  color: widget.shadowColor,
                  blurRadius: size * 0.1,
                  spreadRadius: 0.0,
                  offset: Offset(
                    0.0,
                    0.0,
                  ),
                ),
              ]
            : [],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          //bottom side
          CubeFace(
            size: size,
            color: widget.flippedColor,
            yTranslate: (cos(_rotationAnimation.value) * (size / 2)),
            zTranslate: ((size / 2) * sin(_rotationAnimation.value)),
            rotationAngle: (pi / 2) + _rotationAnimation.value,
            show: _controller.value > 0.5 && _controller.value < 1.0,
            showShade: !widget.flipped,
          ),
          //back side
          CubeFace(
            size: size,
            color: widget.unFlippedColor,
            yTranslate: (-(size / 2) * sin(_rotationAnimation.value)),
            zTranslate: ((size / 2) * cos(_rotationAnimation.value)),
            rotationAngle: pi + _rotationAnimation.value,
            show: _controller.value > 0.25 && _controller.value < 0.75,
            showShade: false,
          ),
          //top side
          CubeFace(
            size: size,
            color: widget.flippedColor,
            yTranslate: -((size / 2) * cos(_rotationAnimation.value)),
            zTranslate: (-(size / 2) * sin(_rotationAnimation.value)),
            rotationAngle: -(pi / 2) + _rotationAnimation.value,
            show: _controller.value > 0.0 && _controller.value < 0.5,
            showShade: !widget.flipped,
          ),
          //front side
          CubeFace(
            size: size,
            color: widget.unFlippedColor,
            yTranslate: (size / 2) * sin(_rotationAnimation.value),
            zTranslate: -((size / 2) * cos(_rotationAnimation.value)),
            rotationAngle: _rotationAnimation.value,
            show: (_controller.value >= 0.0 && _controller.value < 0.25) ||
                _controller.value > 0.78,
            showShade: false,
          ),
        ],
      ),
    );
  }
}

///The cube only rotates on the x-axis. So the translation on x-axis is 0.0
class CubeFace extends StatelessWidget {
  const CubeFace({
    Key key,
    @required this.size,
    @required this.yTranslate,
    @required this.zTranslate,
    @required this.rotationAngle,
    @required this.show,
    this.showShade = true,
    this.shadeColor = Colors.black,
    this.color = Colors.amber,
  })  : assert(size > 0.0),
        super(key: key);

  ///The translation along y axis
  final double yTranslate;

  ///The translation along z axis
  final double zTranslate;

  ///The angle of rotation in x-axis for the plane.
  final double rotationAngle;

  ///Whether to  hide the cube face.
  final bool show;

  ///Show a shade while the face is rotating towards of away from the screen.
  final bool showShade;

  ///Color of the shade.
  final Color shadeColor;

  ///Size of the cube's side.
  final double size;

  ///Color of the cube's side.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: show ? 1.0 : 0.0,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          //perspective
          ..setEntry(3, 2, size * 0.000009)
          ..translate(
            0.0,
            yTranslate,
            zTranslate,
          )
          ..rotateX(rotationAngle),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: color,
              ),
            ),
            AnimatedContainer(
              color:
                  !showShade ? Colors.transparent : shadeColor.withOpacity(0.3),
              duration: Duration(milliseconds: 500),
            ),
          ],
        ),
      ),
    );
  }
}
