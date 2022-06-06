import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'breath_animation.dart';
import 'moon_animation.dart';
import 'controller_class.dart';
import 'menu.dart';
import 'package:lottie/lottie.dart';


void main() {
  // Get.put(LifeController());
  runApp(GetMaterialApp(
    initialBinding: HomeBinding(),
    theme: ThemeData(
      scaffoldBackgroundColor: const Color(0xFF343148),
      ),
    home: const Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final Controller c = Get.put(Controller());
    return Scaffold(
        body: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (c.value_isRunning.value) {
          c.value_visible.value = !c.value_visible.value;
        } else {
          c.value_visible.value = true;
        }
      },
      child: Stack(
        children: [
          const StaggerDemo(),
          Obx(() => AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: c.complete_star_visible.value ? 1 : 0,
// opacity: 1,
            child: Align(alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Lottie.asset('assets/LottieStars.json')))
            )
          ),
          Obx(() => ShimmerPage(c.shimmerEn.value, c.yellowShimmer.value)),
          Obx(() => AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: c.value_visible.value ? 1 : 0,
              child: MenuWidget()
              )
          ),
          // Lottie.asset('assets/LottieSparkling.json'),
        ],
      ),
    ));
  }
}


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
      body: Center(
        child: StaggerAnimation(c2.safeMinSize, controller: c.value_controller.view),
      ),
    );
  }
}

