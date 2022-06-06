import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'controller_class.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';




class DecoButton extends StatelessWidget {
  DecoButton(dicon) :  diconThis =dicon;
  IconData diconThis;

  final buttonColor = Color(0xFF232131);
  final buttonShadow = [
                        //   const BoxShadow(
                        // color:  Colors.black54,
                        // offset: Offset(1.3, 1.3),
                        // blurRadius: 5,
                        // spreadRadius: 20,
                        //   ),
                        // const BoxShadow(
                        // color: const Color(0x33D7C49E),  
                        // offset: Offset(-0.5, -0.5),
                        // blurRadius: 5,
                        // spreadRadius: 20,
                        //   ),
                        ];
  get icon => Icons.abc;
  @override
  Widget build(BuildContext context) {
    return DecoratedIcon(
                        diconThis,
                        color: buttonColor,
                        // shadows: buttonShadow,
                      );
  }
}

class StaticIcon extends StatelessWidget {
  StaticIcon(sicon) :  sThis =sicon;
  IconData sThis;

  // final buttonColor = Color(0xFF232131);
  final iconColor = Colors.black87;
  @override
  Widget build(BuildContext context) {
    return Icon(
                        sThis,
                        color: iconColor,
                        // shadows: buttonShadow,
                      );
  }
}

class MenuWidget extends StatelessWidget with WidgetsBindingObserver{
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  MenuWidget({Key? key}) : super(key: key);
  final Controller c = Get.find();
  final WindowsController c2 = Get.put(WindowsController());


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('state1manue = $state');
  }

  @override
  Widget build(context) {
    // Access the updated count variable
    return Center(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey.withOpacity(0.2),
          ),///////
          child: SizedBox(
            //responsive.. 작은폰엔 어떻게 적용하는가
            height: 500,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,          
              children: [
                                // Padding(padding: EdgeInsets.all(1)),
                Container(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        StaticIcon(CupertinoIcons.clock),
                        Obx(() => Text("   ${c.timeMinRx} : ${c.timeSecRx}")), 
                        const Spacer(),
                        StaticIcon(CupertinoIcons.arrow_2_circlepath_circle),
                        Obx(() => Text("   ${c.value_cycle} ")),
                        const Spacer(),
                      ],
                    ),
                //   ),
                ),
                // Padding(padding: EdgeInsets.all(1)),
                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          c.decrementMin1(c.cycle);
                        },
                        icon: DecoButton(CupertinoIcons.chevron_left)
                        ),
                      StaticIcon(CupertinoIcons.arrow_clockwise),
                      Obx(() => Text("${c.cycle}")),
                      IconButton(
                        onPressed: () {
                          c.increment(c.cycle);
                        },
                        icon: DecoButton(CupertinoIcons.chevron_right)
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StaticIcon(
                              CupertinoIcons.arrow_down_right_arrow_up_left),
                        IconButton(
                                onPressed: () {
                                  c.increment(c.inhale);
                                },
                                icon: DecoButton(CupertinoIcons.chevron_up),                       
                                ),
                        Obx(() => Text("${c.inhale}")),
                        IconButton(
                          onPressed: () {
                            c.decrementMin1(c.inhale);
                          },
                                icon: DecoButton(CupertinoIcons.chevron_down),                       
                        ),
                        const Text("Inhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StaticIcon(CupertinoIcons.circle_fill),
                        IconButton(
                          onPressed: () {
                            c.increment(c.full);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_up),     
                        ),
                        Obx(() => Text("${c.full}")),
                        IconButton(
                          onPressed: () {
                            c.decrement(c.full);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_down),  
                        ),
                        const Text("Full"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StaticIcon(
                            CupertinoIcons.arrow_up_left_arrow_down_right),
                        IconButton(
                          onPressed: () {
                            c.increment(c.exhale);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_up),                       
                        ),
                        Obx(() => Text("${c.exhale}")),
                        IconButton(
                          onPressed: () {
                            c.decrementMin1(c.exhale);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_down),                       
                        ),
                        const Text("Exhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StaticIcon(CupertinoIcons.circle),
                        IconButton(
                          onPressed: () {
                            c.increment(c.empty);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_up),                       
                        ),
                        Obx(() => Text("${c.empty}")),
                        IconButton(
                          onPressed: () {
                            c.decrement(c.empty);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_down),                     
                        ),
                        const Text("Empty"),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() =>ElevatedButton(
                      onPressed: () {
                        print(c.value_isRunning.value);
                        if (c.value_isRunning.value == true && c.value_visible.value == true) {
                          print("stop");
                          c.stopBtn();
                        }
                        else if(c.value_isRunning.value == false && c.value_visible.value == true){
                          print("start");
                          c.startBtn();
                        }
                        else{
                          print("menu is unvisible now! ");
                        }
                      },
                      child: c.value_isRunning.value ? Icon(Icons.stop): const Icon(Icons.play_arrow_sharp,
                          size: 30),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        primary: Colors.transparent, // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      ),
                    ),
                    )

                  ],
                ),
              ],
            ),
          )),
    );
  }
}
