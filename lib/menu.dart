import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller_class.dart';
import 'package:decorated_icon/decorated_icon.dart';



class DecoButton extends StatelessWidget {
  DecoButton(dicon) :  diconThis =dicon;
  IconData diconThis;

  final buttonColor = Colors.black;
  final buttonShadow = [
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 1,
                          ),
                        ];

  get icon => Icons.abc;
  @override
  Widget build(BuildContext context) {
    return DecoratedIcon(
                        diconThis,
                        color: buttonColor,
                        shadows: buttonShadow,
                      );
  }
}

class MenuWidget extends StatelessWidget with WidgetsBindingObserver{
  // You can ask Get to find a Controller that is being used by another page and redirect you to it.
  MenuWidget({Key? key}) : super(key: key);
  final Controller c = Get.find();
  final WindowsController c2 = Get.put(WindowsController());
  final buttonColor = Colors.black;
  final buttonShadow = [
                          const BoxShadow(
                            color: Colors.white,
                            blurRadius: 3,
                          ),
                        ];


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
            color: Colors.grey.withOpacity(0.3),
          ),///////
          child: SizedBox(
            //responsive.. 작은폰엔 어떻게 적용하는가
            height: 500,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(CupertinoIcons.clock),
                    Obx(() => Text("   ${c.timeMinRx} : ${c.timeSecRx}")), 
                    const Spacer(),
                    const Icon(CupertinoIcons.arrow_2_circlepath_circle),
                    Obx(() => Text("   ${c.value_cycle} ")),
                    const Spacer(),
                  ],
                ),
                Container(
                  // margin:  EdgeInsets.all(10),
                  // padding: EdgeInsets.all(0),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(20),
                  //   color: Colors.grey.withOpacity(0.2),
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          c.decrement(c.cycle);
                        },
                        icon: DecoButton(CupertinoIcons.chevron_left)
                        ),
                      const Icon(CupertinoIcons.arrow_clockwise),
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
                        const Icon(
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
                            c.decrement(c.inhale);
                          },
                                icon: DecoButton(CupertinoIcons.chevron_down),                       
                        ),
                        const Text("Inhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.circle_fill),
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
                        const Icon(
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
                            c.decrement(c.exhale);
                          },
                          icon: DecoButton(CupertinoIcons.chevron_down),                       
                        ),
                        const Text("Exhale"),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(CupertinoIcons.circle),
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
                    ElevatedButton(
                      onPressed: () {
                        c.startBtn();
                      },
                      child: const Icon(Icons.play_arrow_sharp,
                          size: 30, color: Colors.black),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        primary: Colors.transparent, // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        c.stopBtn();
                      },
                      child:
                          const Icon(Icons.stop, size: 30,color:Colors.black),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                        primary: Colors.transparent, // <-- Button color
                        onPrimary: Colors.white, // <-- Splash color
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
