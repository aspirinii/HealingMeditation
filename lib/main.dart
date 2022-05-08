import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'VibCol.dart';
// import 'other_widget.dart';
import 'breath_animation.dart';
import 'dart:ui';

void main(){
  runApp(GetMaterialApp(
  theme :ThemeData(scaffoldBackgroundColor: const Color(0xFFF6F5FF)),
  home: const Home()
  ));
}

class WindowsController extends GetxController{
  double physicalWidth = Get.width;
  double physicalHeight = Get.height; 
  //Size in logical pixels
  double logicalWidth = window.physicalSize.width  / Get.pixelRatio;
  double logicalHeight = window.physicalSize.height  / Get.pixelRatio;
  //Padding in physical pixels

  //Safe area paddings in logical pixels
  double paddingLeft = window.padding.left / window.devicePixelRatio;
  double paddingRight = window.padding.right / window.devicePixelRatio;
  double paddingTop = window.padding.top / window.devicePixelRatio;
  double paddingBottom = window.padding.bottom / window.devicePixelRatio;

  //Safe area in logical pixels
  late double safeWidth = (logicalWidth - paddingLeft - paddingRight);
  late double safeHeight = (logicalHeight - paddingTop - paddingBottom);
  late double safeMinSize = min(safeWidth, safeHeight);
  
}


class Controller extends GetxController with GetSingleTickerProviderStateMixin{
  RxBool _visible = true.obs;
  RxBool _isRunning = false.obs;
  var timeSec = 0;
  var timeMin = 0;
  var timeMinRx = 0.obs;
  var timeSecRx = 0.obs;
  var count = 0.obs;
  var cycle = 2.obs;
  var inhale = 3.obs;
  var full = 0.obs;
  var exhale = 3.obs;
  var empty = 0.obs;
  // ignore: unused_field
  late Timer _timer;
  var _timeSum = 10.obs;
  var _cycle = 3.obs;


  late AnimationController _controller;

  @override
  void onInit(){
    _controller = AnimationController(vsync:this);
    timeSum();
    
    super.onInit();
  }
  @override
  void onClose(){
    _controller.dispose();
    vibStop();
    super.onClose();
  }
  // int inhalefullforAni  = inhale.value + full.value;
  // int exhaleforAni = exhale.value;

  void _defineControllerDuration1() {
    int inhalefullforAni  = (inhale.value + full.value)*1000;
    _controller.duration = Duration(milliseconds: inhalefullforAni);
  }
  void _defineControllerDuration2() {
    int exhaleforAni = (exhale.value + empty.value)*1000;
    _controller.duration = Duration(milliseconds: exhaleforAni);
  }

  Future<void> _playAnimation() async {
    for(int i=0; i < cycle.value; i++){  
      try {
        if(!_isRunning.value){
          return;
        }
        _defineControllerDuration1();
        await _controller.forward().orCancel;
        _defineControllerDuration2();
        await _controller.reverse().orCancel;
      } on TickerCanceled {
        // the animation got canceled, probably because we were disposed
      }
    }
  }


  void startTimer() {
      _timeSum.value = cycle.value * (inhale.value + full.value + exhale.value + empty.value);
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(oneSec, (_timer){
            if (_timeSum.value == 0) {
                _visible.value =true;
                _isRunning.value = false;
                stopTimer();
            } else {
                _timeSum.value--;
                timeSumInRunning();
          }
        }
      );
  }

  void stopTimer(){
      _timer.cancel();
      timeSum();
      return;
  }

  var inhaleR = 0.obs;
  var exhaleR = 0.obs;

  void timerWork() {
    int _cycle1 = cycle.value;
    int _inhale = inhale.value;
    int _exhale = exhale.value;
    int _full = full.value;
    int _empty = empty.value;
    HapticVib(_cycle1, _inhale, _full, _exhale, _empty);
  }
  
  increment(a) {
    if(_isRunning.value){
      return;
    }
    a++;
    timeSum();
  }
  decrement(b){
    if(_isRunning.value){
      return;
    }
    if (b.value<=0){
      b.value = 0;
      return;
    }
    b--;
    timeSum();
  } 
  timeSum(){
    timeSec = cycle.value * (inhale.value + full.value + exhale.value + empty.value);
    timeMin = Duration(seconds: timeSec).inMinutes;
    timeMinRx.value = timeMin;
    timeSecRx.value = timeSec%60;
    _cycle.value = timeSec~/(inhale.value + full.value + exhale.value + empty.value);
  }
  timeSumInRunning(){
    _cycle.value = (_timeSum.value~/(inhale.value + full.value + exhale.value + empty.value) )+ 1;
    timeSec = _timeSum.value;
    timeMin = Duration(seconds: timeSec).inMinutes;
    timeMinRx.value = timeMin;
    timeSecRx.value = timeSec%60;
  }
  vibStop(){
    Vibration.cancel();
  }

  void startBtn(){
    if (_isRunning.value || !_visible.value){
      return;
    }else{
      _isRunning.value = true;
      _playAnimation();
      timerWork(); // vibration
      startTimer();
      _visible.value = false;                  
    }
  }
  void stopBtn(){
    if (!_visible.value){
      return;
    }
    _isRunning.value = false;
    _visible.value = true;
    stopTimer();
    vibStop();
    stopAnimation();

  }

  Future<void>  stopAnimation() async{
    for(int i=0; i < cycle.value; i++){  
      try {
        _controller.isAnimating
        ? _controller.stop()
        : _controller.reverse(from : 0.3);
      } on TickerCanceled {
          // the animation got canceled, probably because we were disposed
      }
    }
    // _controller.reverse(from : 0.1);
  }



}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  

  @override
  Widget build(context) {

    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());
    final WindowsController c2 = Get.put(WindowsController());


    return Scaffold(
      // Use Obx(()=> to update Text() whenever count is changed.
      // appBar: AppBar(title: Obx(() => Text("cycle: ${c._cycle} Timer:${c._timeSum} , ${c._isRunning.value}"
      // ))),

      body:GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          if(c._isRunning.value){
          c._visible.value = !c._visible.value;
          }else{
            c._visible.value = true;
          }
        },
        child: 
        Stack(
          children: [
            const StaggerDemo(),
            Obx(() => AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: c._visible.value ? 1 : 0,
              child: MenuWidget()
              )
            )
          ],
        ),
      )
    );
  }
}

// class Other extends StatelessWidget {
//   // You can ask Get to find a Controller that is being used by another page and redirect you to it.
//   final Controller c = Get.find();

//   @override
//   Widget build(context){
//      // Access the updated count variable
//     return Scaffold(body: Center(child: Text("${c.count}")));
//   }
// }


class StaggerDemo extends StatefulWidget {
  const StaggerDemo({Key? key}) : super(key: key);
  @override
  _StaggerDemoState createState() => _StaggerDemoState();
}
class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {

  final Controller c = Get.put(Controller());
  final WindowsController c2 = Get.put(WindowsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
              child: StaggerAnimation(c2.safeMinSize, controller: c._controller.view),
            ),
    );
  }
}

class MenuWidget extends StatelessWidget {
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  MenuWidget({Key? key}) : super(key: key);
  final Controller c = Get.find();
  final WindowsController c2 = Get.put(WindowsController());




  @override
  Widget build(context){
     // Access the updated count variable
    return Center(
            child: Container(
              color : Colors.grey.withOpacity(0.2),
              child: SizedBox( //responsive.. 작은폰엔 어떻게 적용하는가
                height: 500,
                width: 300,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.clock),Obx(() => Text("   ${c.timeMinRx} : ${c.timeSecRx}")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.arrow_2_circlepath_circle),Obx(() => Text("   ${c._cycle} ")),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      
                    IconButton(
                        onPressed: () {
                          c.decrement(c.cycle);
                        },
                      icon: const Icon(CupertinoIcons.chevron_left),
                      splashColor : Colors.red,
                      splashRadius: 10,
                      hoverColor : Colors.blue,
                    ),
                    const Icon(CupertinoIcons.arrow_clockwise),Obx(() => Text("${c.cycle}")),
                    IconButton(
                        onPressed: () {
                          c.increment(c.cycle);
                        },
                      icon: const Icon(CupertinoIcons.chevron_right),
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
                        const Icon(CupertinoIcons.arrow_down_right_arrow_up_left),
                        IconButton(
                        onPressed: () {
                          c.increment(c.inhale);
                        },
                        icon: const Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.inhale}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.inhale);
                        },
                        icon: const Icon(CupertinoIcons.chevron_down
                        ),),
                        const Text("Inhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.heart_fill),
                        IconButton(
                        onPressed: () {
                          c.increment(c.full);
                        },
                        icon: const Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.full}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.full);
                        },
                        icon: const Icon(CupertinoIcons.chevron_down
                        ),),
                        const Text("full"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.arrow_up_left_arrow_down_right),
                        IconButton(
                        onPressed: () {
                          c.increment(c.exhale);
                        },
                        icon: const Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.exhale}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.exhale);
                        },
                        icon: const Icon(CupertinoIcons.chevron_down
                        ),),
                        const Text("Exhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.heart),
                        IconButton(
                        onPressed: () {
                          c.increment(c.empty);
                        },
                        icon: const Icon(CupertinoIcons.chevron_up
                        ),),
                        Obx(() => Text("${c.empty}")),
                        IconButton(
                        onPressed: () {
                          c.decrement(c.empty);
                        },
                        icon: const Icon(CupertinoIcons.chevron_down,
                        ),),
                        const Text("empty"),
                      ],
                    ),

                  ],),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          c.startBtn();
                        },
                        child: const Icon(
                          Icons.play_arrow_sharp,
                          size: 30,
                        color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.red, // <-- Splash color
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          c.stopBtn();
                        },
                        child: const Icon(
                          Icons.stop,
                          size: 30,
                        color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          primary: Colors.transparent, // <-- Button color
                          onPrimary: Colors.red, // <-- Splash color
                        ),
                      )
                  ],),
                ],
            ),
              )),
          );
  }
}