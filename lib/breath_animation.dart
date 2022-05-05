
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({Key? key, required this.controller})
      :
        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.
        opacity = Tween<double>(
          begin: 1,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.0,
              0.100,
              curve: Curves.ease,
            ),
          ),
        ),
        width = Tween<double>(
          begin: 50.0,
          end: 150.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        height = Tween<double>(begin: 50.0, end: 150.0).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        padding = EdgeInsetsTween(
          begin: const EdgeInsets.all(0),
          end: const EdgeInsets.all(0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.250,
              0.375,
              curve: Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(75.0),
          end: BorderRadius.circular(75.0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0.375,
              0.500,
              curve: Curves.ease,
            ),
          ),
        ),
        color1 = ColorTween(
          begin: Colors.indigo[100],
          end: Colors.orange[400],
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        color2 = ColorTween(
          begin: Colors.blueGrey,
          end: Colors.redAccent,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              1,
              curve: Curves.ease,
            ),
          ),
        ),
        super(key: key);
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color1;
  final Animation<Color?> color2;
  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
      child: Opacity(
        opacity: 1,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                color1.value ?? Colors.blue,
                color2.value ?? Colors.red,
              ],
            ),
            // border: Border.all(
            //   color: Colors.indigo[300]!,
            //   width: 3.0,
            // ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
class StaggerDemo extends StatefulWidget {
  const StaggerDemo({Key? key}) : super(key: key);
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}
class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _defineControllerDuration1() {
    _controller.duration = const Duration(milliseconds: 6000);
  }
  void _defineControllerDuration2() {
    _controller.duration = const Duration(milliseconds: 4000);
  }
  Future<void> _playAnimation() async {
    try {
      _defineControllerDuration1();
      await _controller.forward().orCancel;
      _defineControllerDuration2();
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0; // 1.0 is normal animation speed.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: 
      // GestureDetector(
      //   behavior: HitTestBehavior.opaque,
      //   onTap: () {
      //     // _defineControllerDuration1();
      //     _playAnimation();
      //     // _defineControllerDuration2();
      //     // _playBackAnimation();
      //   },
      //   child: 
        Center(
          child: Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              border: Border.all(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            child: Center(
              child: StaggerAnimation(controller: _controller.view),
            ),
          ),
        ),
      // ),
      floatingActionButton: FloatingActionButton(
          // When the user taps the button
          onPressed: () {
            // Use setState to rebuild the widget with new values.
            _playAnimation();
          },
          child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
void main() {
  runApp(
    const MaterialApp(
      home: StaggerDemo(),
    ),
  );
}
