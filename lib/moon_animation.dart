import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; 
// 사각형을 원형으로 만들기 위해 라이브러리 임시로 손댐 , 수정하면 잘 안될수있으니 잘확인 
//    path.addOval(Rect.fromCircle(
//      center: Offset(20, 20), <-- width,height/2  
//      radius: 20.0,
//    ));



class ShimmerPage extends StatelessWidget {
  double safeMinSize = 200;
  ShimmerPage(haha, hoho): enabledValue = haha, yellowValue = hoho;
  bool enabledValue;
  bool yellowValue;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Shimmer(
        // This is the 3ONLY required parameter
        child: Container(
          width: safeMinSize / 5,
          height: safeMinSize / 5,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(safeMinSize * 0.3),
          color: Colors.black.withOpacity(0),
          )
        ),
        // This is the default value
        duration: Duration(seconds: 1),
        // This is NOT the default value. Default value: Duration(seconds: 0)
        interval: Duration(seconds: 0), // This is the default value 
        color: yellowValue ? const Color(0xFFD7C49E) : const Color(0xFF343148),
         // This is the default value
        colorOpacity: 1,
        // This is the default value
        enabled: enabledValue,
        // This is the default value
        direction: ShimmerDirection.fromLTRB(),
      ),
    );
  }
}