import 'package:flutter/material.dart';

class Button extends StatefulWidget{
  final double? width;
  final double? height;

  const Button({super.key, this.width, this.height});

  @override
  State<Button> createState() {
    return ButtonState();
  }
}

class ButtonState extends State<Button> {
  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    width = widget.width ?? 50.0;
    height = widget.height ?? 50.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: initState,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(),
      ),
    );
  }
}


