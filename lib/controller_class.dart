import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'vib_func.dart';
import 'dart:ui';
import 'dart:io' show Platform;
import 'package:wakelock/wakelock.dart';

class WindowsController extends GetxController {
  double physicalWidth = Get.width;
  double physicalHeight = Get.height;
  //Size in logical pixels
  double logicalWidth = window.physicalSize.width / Get.pixelRatio;
  double logicalHeight = window.physicalSize.height / Get.pixelRatio;
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

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LifeController());
  }
}

class LifeController extends FullLifeCycleController with FullLifeCycleMixin {
  final Controller c = Get.put(Controller());

  @override
  void onDetached() {
    // 응용 프로그램은 여전히 flutter 엔진에서 호스팅되지만 "호스트 View"에서 분리됩니다.
    // 앱이 이 상태에 있으면 엔진이 "View"없이 실행됩니다.
    // 엔진이 처음 초기화 될 때 "View" 연결 진행 중이거나 네비게이터 팝으로 인해 "View"가 파괴 된 후 일 수 있습니다.
    print('HomeController - onDetached called');
  }

  // Mandatory
  @override
  void onInactive() {
    // 앱이 비활성화 상태이고 사용자의 입력을 받지 않습니다.
    // ios에서는 포 그라운드 비활성 상태에서 실행되는 앱 또는 Flutter 호스트 뷰에 해당합니다.
    // 안드로이드에서는 화면 분할 앱, 전화 통화, PIP 앱, 시스템 대화 상자 또는 다른 창과 같은 다른 활동이 집중되면 앱이이 상태로 전환됩니다.
    // inactive가 발생되고 얼마후 pasued가 발생합니다.
    print('HomeController - onInative called');
    c.stopBtn();
  }

  // Mandatory
  @override
  void onPaused() {
    // 앱이 현재 사용자에게 보이지 않고, 사용자의 입력을 받지 않으며, 백그라운드에서 동작 중입니다.
    // 안드로이드의 onPause()와 동일합니다.
    // 응용 프로그램이 이 상태에 있으면 엔진은 Window.onBeginFrame 및 Window.onDrawFrame 콜백을 호출하지 않습니다.

    print('HomeController - onPaused called');
    c.stopBtn();
  }

  // Mandatory
  @override
  void onResumed() {
    print('HomeController - onResumed called');
    c.value_visible.value = true;
  }
}

class Controller extends GetxController with GetSingleTickerProviderStateMixin {
  RxBool value_visible = true.obs;
  RxBool complete_star_visible = false.obs;
  RxBool value_isRunning = false.obs;
  RxBool value_black = true.obs;
  var value_timeSum = 10.obs;
  var value_cycle = 3.obs;

  var timeSec = 0;
  var timeMin = 0;
  var timeMinRx = 0.obs;
  var timeSecRx = 0.obs;
  var count = 0.obs;
  var cycle = 5.obs;
  var inhale = 5.obs;
  var full = 1.obs;
  var exhale = 5.obs;
  var empty = 1.obs;
  late Timer value_timer;

  late AnimationController value_controller;
  var shimmerEn = false.obs;
  var yellowShimmer = false.obs;

  int value_counter = 0;
  //시작할 때 counter 값을 불러옵니다.
  value_loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cycle.value = (prefs.getInt('cycle') ?? 5);
    inhale.value = (prefs.getInt('inhale') ?? 5);
    full.value = (prefs.getInt('full') ?? 1);
    exhale.value = (prefs.getInt('exhale') ?? 5);
    empty.value = (prefs.getInt('empty') ?? 1);
  }

  //클릭하면 counter를 증가시킵니다.
  value_savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cycle', cycle.value);
    prefs.setInt('inhale', inhale.value);
    prefs.setInt('full', full.value);
    prefs.setInt('exhale', exhale.value);
    prefs.setInt('empty', empty.value);
  }

  @override
  void onInit() {
    value_controller = AnimationController(vsync: this);
    timeSum();
    value_loadPreferences();
    Wakelock.enable();
    super.onInit();
  }

  @override
  void onClose() {
    value_controller.dispose();
    vibStop();
    super.onClose();
  }
  // int inhalefullforAni  = inhale.value + full.value;
  // int exhaleforAni = exhale.value;

  void value_defineControllerDuration1() {
    int inhalefullforAni = (inhale.value) * 1000;
// int inhalefullforAni = (inhale.value + full.value) * 1000;
    value_controller.duration = Duration(milliseconds: inhalefullforAni);
  }

  void value_defineControllerDuration2() {
    // int exhaleforAni = (exhale.value + empty.value) * 1000;
    int exhaleforAni = (exhale.value) * 1000;
    value_controller.duration = Duration(milliseconds: exhaleforAni);
  }

  Future<void> value_playAnimation() async {
    int fullforAni = full.value * 1000;
    int emptyforAni = empty.value * 1000;
    for (int i = 0; i < cycle.value; i++) {
      try {
        if (!value_isRunning.value) {
          return;
        }
        value_defineControllerDuration1();
        await value_controller.forward().orCancel;
        shimmerEn.value = true;
        yellowShimmer.value = false;
        await Future.delayed(Duration(milliseconds: fullforAni));
        shimmerEn.value = false;

        value_defineControllerDuration2();
        await value_controller.reverse().orCancel;

        shimmerEn.value = true;
        yellowShimmer.value = true;
        await Future.delayed(Duration(milliseconds: emptyforAni));
        shimmerEn.value = false;
      } on TickerCanceled {
        // the animation got canceled, probably because we were disposed
      }
    }
  }

  void startTimer() {
    value_timeSum.value =
        cycle.value * (inhale.value + full.value + exhale.value + empty.value);
    const oneSec = Duration(seconds: 1);
    value_timer = Timer.periodic(oneSec, (value_timer) {
      print(value_timeSum.value);
      if (value_timeSum.value == 0) {
        value_isRunning.value = false;
        stopTimer();
        Congratulations();
      } else {
        value_timeSum.value--;
        timeSumInRunning();
      }
    });
  }

  void stopTimer() {
    if (value_timer != null && value_timer.isActive) {
      value_timer.cancel();
      print("value_tiemr is active ${value_timer.isActive}");
    } else {
      print("value timer is not active ");
    }
    timeSum();
    return;
  }

  var inhaleR = 0.obs;
  var exhaleR = 0.obs;

  void timerWork() {
    int value_cycle1 = cycle.value;
    int value_inhale = inhale.value;
    int value_exhale = exhale.value;
    int value_full = full.value;
    int value_empty = empty.value;
    if (Platform.isAndroid || Platform.isIOS) {
      HapticVib(
          value_cycle1, value_inhale, value_full, value_exhale, value_empty);
    } else {
      print("it is not mobile");
    }
  }

  increment(a) {
    if (value_isRunning.value) {
      return;
    }
    a++;
    timeSum();
    print('workworkwork');
  }

  decrement(b) {
    if (value_isRunning.value) {
      return;
    }
    if (b.value <= 0) {
      b.value = 0;
      return;
    }
    b--;
    timeSum();
  }

  timeSum() {
    timeSec =
        cycle.value * (inhale.value + full.value + exhale.value + empty.value);
    timeMin = Duration(seconds: timeSec).inMinutes;
    timeMinRx.value = timeMin;
    timeSecRx.value = timeSec % 60;
    value_cycle.value =
        timeSec ~/ (inhale.value + full.value + exhale.value + empty.value);
    value_savePreferences();
  }

  timeSumInRunning() {
    value_cycle.value = (value_timeSum.value ~/
            (inhale.value + full.value + exhale.value + empty.value)) +
        1;
    timeSec = value_timeSum.value;
    timeMin = Duration(seconds: timeSec).inMinutes;
    timeMinRx.value = timeMin;
    timeSecRx.value = timeSec % 60;
  }

  Congratulations() {
    value_isRunning.value = true;
    complete_star_visible.value = true;
    const oneSec = Duration(seconds: 1);
    var staytime = 10;
    Timer.periodic(oneSec, (time) {
      if (staytime == 0) {
        value_visible.value = true;
        value_isRunning.value = false;
        time.cancel();
      } else if (staytime == 1) {
        complete_star_visible.value = false;
        staytime--;
      } else {
        staytime--;
      }
    });
  }

  vibStop() {
    Vibration.cancel();
  }

  void startBtn() {
    // if (value_isRunning.value || !value_visible.value) {
    //   return;}
    value_isRunning.value = true;
    value_playAnimation();
    timerWork(); // vibration
    startTimer();
    value_visible.value = false;
    complete_star_visible.value = false;
  }

  void stopBtn() async {
    print("stopBtn start ---------------------------------");
    // if (!value_visible.value) {
    //   return;
    // }
    value_isRunning.value = false;
    value_visible.value = true;
    stopTimer();

    if (Platform.isAndroid || Platform.isIOS) {
      vibStop();
    } else {
      print("it is not mobile");
    }

    // vibStop();
    await stopAnimation();
    value_controller.reverse(from: 0.3);
    print("stopBtn End ---------------------------------");
  }

  Future<void> stopAnimation() async {
    // for (int i = 0; i < cycle.value; i++) {
    //   try {
    //     value_controller.isAnimating
    //         ? value_controller.stop()
    //         : value_controller.reverse(from: 0.3);
    //   } on TickerCanceled {
    //     // the animation got canceled, probably because we were disposed
    //   }
    // }
    do {
      try {
        value_controller.isAnimating
            ? value_controller.stop()
            : value_controller.reverse(from: 0.3);
      } on TickerCanceled {
        // the animation got canceled, probably because we were disposed
      }
    } while (value_controller.isAnimating);
    // value_controller.reverse(from : 0.1);
    shimmerEn.value = false;
  }
}
