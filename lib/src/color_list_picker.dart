import 'dart:developer' as developer;

import 'package:caviare_flutter_colorpicker/src/circle_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorListPicker extends StatefulWidget {
  final Color? selectedColor;
  final ValueChanged<Color>? onColorChange;
  final List<Color>? colors;
  final double circleSize;
  final ScrollPhysics? physics;
  final double spacing;
  final Axis scrollDirection;
  final int crossAxisCircleNum;
  final double borderSize;
  final Color borderColor;
  final double elevation;
  final bool shrinkWrap;

  const ColorListPicker(
      {this.selectedColor,
      this.onColorChange,
      this.colors,
      this.circleSize = 45.0,
      this.spacing = 20,
      this.physics,
      this.shrinkWrap = true,
      this.scrollDirection = Axis.horizontal,
      this.borderSize = 4,
      this.borderColor = Colors.black,
      this.crossAxisCircleNum = 0,
      this.elevation = 0.0});

  @override
  State<StatefulWidget> createState() {
    return _ColorListPickerState();
  }
}

class _ColorListPickerState extends State<ColorListPicker> {
  List<Color> _colors = [];
  Color? _shadeColor;

  List<ColorSwatch> fullMaterialColors = const <ColorSwatch>[
    const ColorSwatch(0xFFFFFFFF, {500: Colors.white}),
    const ColorSwatch(0xFF000000, {500: Colors.black}),
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey
  ];

  List<Color> _getfullColors() {
    List<Color> fullColors = [];
    for (ColorSwatch colorSwatch in fullMaterialColors) {
      fullColors.addAll(_getMaterialColorShades(colorSwatch));
    }
    developer.log('fullColors:' + fullColors.toString(),
        name: 'caviare.flutter.colorpicker');
    return fullColors;
  }

  List<Color> _getMaterialColorShades(ColorSwatch color) {
    List<Color> colors = <Color>[];
    if (color[100] != null) colors.add(color[100]!);
    // if (color[200] != null) color[200],
    if (color[300] != null) colors.add(color[300]!);
    // if (color[400] != null) color[400],
    if (color[500] != null) colors.add(color[500]!);
    // if (color[600] != null) color[600],
    if (color[700] != null) colors.add(color[700]!);
    // if (color[800] != null) color[800],
    if (color[900] != null) colors.add(color[900]!);
    return colors;
  }

  List<Widget> _buildFullColors() {
    developer.log(
        'circleSize:' +
            widget.circleSize.toString() +
            ',_shadeColor' +
            _shadeColor.toString(),
        name: 'caviare.flutter.colorpicker');
    return [
      for (final color in _colors)
        CircleColor(
            color: color,
            circleSize: widget.circleSize,
            onColorChoose: () => _onColorSelected(color),
            isSelected: _shadeColor == color,
            borderSize: widget.borderSize,
            borderColor: widget.borderColor,
            elevation: widget.elevation),
    ];
  }

  void _onColorSelected(Color color) {
    setState(() => _shadeColor = color);
    if (widget.onColorChange != null) widget.onColorChange!(color);
  }

  @override
  void initState() {
    super.initState();
    _initSelectedValue();
  }

  @protected
  void didUpdateWidget(ColorListPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initSelectedValue();
  }

  void _initSelectedValue() {
    if (widget.colors != null) {
      _colors = widget.colors!;
    } else {
      _colors = _getfullColors();
    }

    developer.log('selectedColor:' + widget.selectedColor.toString());
    Color shadeColor = widget.selectedColor ?? _colors[0];

    setState(() {
      _shadeColor = shadeColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: LayoutBuilder(builder: (context, constrains) {
      developer.log('width:' +
          constrains.maxWidth.toString() +
          ',height:' +
          constrains.maxHeight.toString());
      double mainAxisSize = 0;
      double crossAxisSize = 0;
      double height = 0;
      double width = 0;
      int circleNum = widget.crossAxisCircleNum;
      if (widget.scrollDirection == Axis.horizontal) {
        mainAxisSize = constrains.maxWidth != double.infinity
            ? constrains.maxWidth
            : MediaQuery.of(context).size.width;
        crossAxisSize = constrains.maxHeight != double.infinity
            ? constrains.maxHeight
            : MediaQuery.of(context).size.height;
      } else {
        mainAxisSize = constrains.maxHeight != double.infinity
            ? constrains.maxHeight
            : MediaQuery.of(context).size.height;
        crossAxisSize = constrains.maxWidth != double.infinity
            ? constrains.maxWidth
            : MediaQuery.of(context).size.width;
      }
      if (circleNum == 0) {
        circleNum = (crossAxisSize - widget.spacing) ~/
            (widget.circleSize + widget.spacing);
      }
      crossAxisSize =
          circleNum * (widget.circleSize + widget.spacing) + widget.spacing;
      mainAxisSize = ((mainAxisSize - widget.spacing) ~/
                  (widget.circleSize + widget.spacing)) *
              (widget.circleSize + widget.spacing) +
          widget.spacing;
      developer.log('constraints:' +
          BoxConstraints.tightFor(width: width, height: height).toString());
      return Container(
          width: widget.scrollDirection == Axis.horizontal
              ? mainAxisSize
              : crossAxisSize,
          height: widget.scrollDirection == Axis.horizontal
              ? crossAxisSize
              : mainAxisSize,
          child: GridView.count(
            scrollDirection: widget.scrollDirection,
            shrinkWrap: widget.shrinkWrap,
            physics: widget.physics,
            padding: EdgeInsets.all(widget.spacing),
            crossAxisSpacing: widget.spacing,
            mainAxisSpacing: widget.spacing,
            crossAxisCount: circleNum,
            children: _buildFullColors(),
          ));
    }));
  }
}
