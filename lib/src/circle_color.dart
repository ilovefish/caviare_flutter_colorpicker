import 'package:flutter/material.dart';

class CircleColor extends StatelessWidget {
  final bool isSelected;
  final Color color;
  final VoidCallback onColorChoose;
  final double circleSize;
  final double borderSize;
  final Color borderColor;
  final double elevation;

  const CircleColor(
      {Key key,
      @required this.color,
      @required this.circleSize,
      this.onColorChoose,
      this.isSelected = false,
      this.borderColor = Colors.black,
      this.borderSize = 4,
      this.elevation = 0.0})
      : assert(color != null, "You must provide a not null Color"),
        assert(circleSize != null, "CircleColor must have a not null size"),
        assert(circleSize >= 0, "You must provide a positive size"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onColorChoose,
      child: Material(
        elevation: elevation,
        shape: const CircleBorder(),
        child: Center(
            child: isSelected
                ? SelectedColorCircleAvatar(
                    circleSize: circleSize,
                    color: color,
                    borderColor: borderColor,
                    borderSize: borderSize)
                : ColorCircleAvatar(
                    circleSize: circleSize,
                    color: color,
                    borderSize: borderSize)),
      ),
    );
  }
}

class ColorCircleAvatar extends StatelessWidget {
  final double circleSize;
  final Color color;
  final double borderSize;

  ColorCircleAvatar({this.circleSize, this.color, this.borderSize});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleSize / 2,
      backgroundColor: color,
    );
  }
}

class SelectedColorCircleAvatar extends StatelessWidget {
  final double circleSize;
  final Color color;
  final Color borderColor;

  final double borderSize;

  SelectedColorCircleAvatar(
      {this.circleSize, this.color, this.borderColor, this.borderSize});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: circleSize / 2,
      backgroundColor: Colors.black,
      child: CircleAvatar(
        radius: circleSize / 2 - borderSize,
        backgroundColor: color,
        // child: isSelected ? Icon(iconSelected, color: icon) : null,
      ),
    );
  }
}
