import 'dart:math';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:get/get.dart';
import 'dart:ui';


class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({Key? key}) : super(key: key);

  @override
  _AnimatedContainerAppState createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {

  double physicalWidth = Get.width;
  double physicalHeight = Get.height; 
  //Size in logical pixels
  double logicalWidth = window.physicalSize.width  / Get.pixelRatio;
  double logicalHeight = window.physicalSize.height  / Get.pixelRatio;
  //Padding in physical pixels
  double padding =0;


  //Safe area paddings in logical pixels
    double paddingLeft = window.padding.left / window.devicePixelRatio;
    double paddingRight = window.padding.right / window.devicePixelRatio;
    double paddingTop = window.padding.top / window.devicePixelRatio;
    double paddingBottom = window.padding.bottom / window.devicePixelRatio;

  //Safe area in logical pixels
    late double safeWidth = (logicalWidth - paddingLeft - paddingRight);
    late double safeHeight = (logicalHeight - paddingTop - paddingBottom);

    // Define the various properties with default values. Update these properties
    // when the user taps a FloatingActionButton.
    double _width = 50;
    double _height = 50;
    Color _color = Colors.green;
    BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);
    final Controller c = Get.put(Controller());


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AnimatedContainer(
            // Use the properties stored in the State class.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Define how long the animation should take.
            duration: const Duration(seconds: 3),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // When the user taps the button
          onPressed: () {
            // Use setState to rebuild the widget with new values.
            setState(() {
              // Create a random number generator.
              final random = Random();

              // Generate a random width and height.
              _width = safeWidth;
              _height = safeHeight;

              // Generate a random color.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // Generate a random border radius.
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}