
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.
// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';


class StaggerAnimation extends StatelessWidget {
  StaggerAnimation(safeMinSize,{Key? key, required this.controller, double test = 0})
      :
        // Each animation defined here transforms its value during the subset
        // of the controller's duration defined by the animation's interval.
        // For example the opacity animation transforms its value during
        // the first 10% of the controller's duration.
        
        // opacity = Tween<double>(
        //   begin: 1,
        //   end: 1.0,
        // ).animate(
        //   CurvedAnimation(
        //     parent: controller,
        //     curve: const Interval(
        //       0.0,
        //       0.100,
        //       curve: Curves.easeInCirc,
        //     ),
        //   ),
        // ),
        width = Tween<double>(
          begin: safeMinSize/5,
          end: safeMinSize,
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
        height = Tween<double>(begin: safeMinSize/5, end: safeMinSize).animate(
          CurvedAnimation(
            parent: controller,
            curve: const Interval(
              0,
              1,
              curve:Curves.ease,
            ),
          ),
        ),
        borderRadius = BorderRadiusTween(
          begin: BorderRadius.circular(safeMinSize*0.3),
          end: BorderRadius.circular(safeMinSize*1.5),
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
        color1 = ColorTween(
          begin:Color(0x55EDC2D8),
          end:Color(0xFFEDC2D8),
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
          begin: Color(0x55BABAD3),
          end: Color(0xFFBABAD3),
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
  // final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color1;
  final Animation<Color?> color2;


  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  int safeMinSize = 200;
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: const EdgeInsets.all(0),
      alignment: Alignment.center,
      child: Opacity(
        opacity: 1,
        child: Container(
          // width: width.value,
          // height: height.value,
          width: safeMinSize/5,
          height: safeMinSize/5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                // color1.value ?? Colors.blue,
                // color2.value ?? Colors.red,
                Color(0xFFF6F5FF),
                Color(0xFFF6F5FF),
              ],
            ),
            borderRadius: BorderRadius.circular(safeMinSize*0.3),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFBABAD3).withOpacity(1),
                spreadRadius: width.value/5,
                blurRadius: width.value/7,
                offset: Offset(0, 0),
    // changes position of shadow
              ),
            ],
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

