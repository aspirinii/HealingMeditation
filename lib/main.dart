import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'dart:async';
import 'VibCol.dart';
import 'other_widget.dart';
import 'breath_animation.dart';

void main() => runApp(GetMaterialApp(home: Home()));

class Controller extends GetxController{
  var timeSec = 0;
  var timeMin = 0;
  var timeMinRx = 0.obs;
  var timeSecRx = 0.obs;
  var count = 0.obs;
  var cycle = 3.obs;
  var inhale = 5.obs;
  var full = 1.obs;
  var exhale = 5.obs;
  var empty = 0.obs;
  late Timer _timer;
  var _timeSum = 10.obs;
  var _cycle = 3.obs;
  void startTimer() {
    _timeSum.value = cycle.value * (inhale.value + full.value + exhale.value + empty.value);
    // int tranferValue = cycle.value;
    // _cycle.value = tranferValue;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec,(Timer timer) {
          if (_timeSum.value == 0) {
              timer.cancel();
          } else {
              _timeSum.value--;
              _cycle.value = (_timeSum.value/(inhale.value + full.value + exhale.value + empty.value)).toInt() + 1;
          }   
          
        },
    );
  }

  var inhaleR = 0.obs;
  var exhaleR = 0.obs;

  void timerWork() {
    int _cycle = cycle.value;
    int _inhale = inhale.value;
    int _exhale = exhale.value;
    int _full = full.value;

    HapticVib(_cycle, _inhale, _full, _exhale);

  }



  
  increment(a) {
      /// The default vibration duration is 500ms.
  /// Amplitude is a range from 1 to 255, if supported.
    a++;
    timeSum();
  }
  decrement(b){
    b--;
    timeSum();
  } 
  timeSum(){

    timeSec = cycle.value * (inhale.value + full.value + exhale.value + empty.value);
    timeMin = Duration(seconds: timeSec).inMinutes;
    timeMinRx.value = timeMin;
    timeSecRx.value = timeSec%60;
  }



  vibStop(){
    Vibration.cancel();
  }


}

class Home extends StatelessWidget {
  

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      appBar: AppBar(title: Obx(() => Text("cycle: ${c._cycle} Timer:${c._timeSum}"
      ))),

      body:Stack(
        children: [
          StaggerDemo(),
          Center(

            child: Container(
              color : Colors.grey.withOpacity(0.5),
              child: SizedBox( //responsive.. 작은폰엔 어떻게 적용하는가
                height: 500,
                width: 300,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Obx(() => Text("Estimate Time : ${c.timeMinRx} : ${c.timeSecRx}")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                    IconButton(
                        onPressed: () {
                          c.decrement(c.cycle);
                        },
                      icon: Icon(CupertinoIcons.chevron_left),
                      splashColor : Colors.red,
                      splashRadius: 10,
                      hoverColor : Colors.blue,
                    ),
                    Obx(() => Text("${c.cycle} Cycle")),
                    IconButton(
                        onPressed: () {
                          c.increment(c.cycle);
                        },
                      icon: Icon(CupertinoIcons.chevron_right),
                      splashColor : Colors.red,
                      splashRadius: 10,
                      hoverColor : Colors.blue,
                    ),
                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Image"),
                        IconButton(
                        onPressed: () {
                          c.increment(c.inhale);
                        },
                        icon: Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.inhale}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.inhale);
                        },
                        icon: Icon(CupertinoIcons.chevron_down
                        ),),
                        Text("Inhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Image"),
                        IconButton(
                        onPressed: () {
                          c.increment(c.full);
                        },
                        icon: Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.full}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.full);
                        },
                        icon: Icon(CupertinoIcons.chevron_down
                        ),),
                        Text("full(1,2,4,5,10)"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Image"),
                        IconButton(
                        onPressed: () {
                          c.increment(c.exhale);
                        },
                        icon: Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.exhale}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.exhale);
                        },
                        icon: Icon(CupertinoIcons.chevron_down
                        ),),
                        Text("Exhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Image"),
                        IconButton(
                        onPressed: () {
                          c.increment(c.empty);
                        },
                        icon: Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.empty}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.empty);
                        },
                        icon: Icon(CupertinoIcons.chevron_down,
                        ),),
                        Text("empty"),
                      ],
                    ),

                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
  
                          c.timerWork();
                          c.startTimer();
                        },
                        child: Icon(
                          Icons.play_arrow_sharp,
                          size: 30,
                        color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.red, // <-- Splash color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          c.decrement(c.count);
                          c.vibStop();
                          // c.stopTimer();
                        },
                        child: Icon(
                          Icons.stop_circle_sharp,
                          size: 30,
                        color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.red, // <-- Splash color
                        ),
                      )
                  ],),
                ],
            ),
              )),
          ),
        ],
      ),

    );
  }
}

class Other extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  final Controller c = Get.find();

  @override
  Widget build(context){
     // Access the updated count variable
    return Scaffold(body: Center(child: Text("${c.count}")));
  }
}