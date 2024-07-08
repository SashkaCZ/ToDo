import 'dart:async';
import 'package:get/get.dart';

class SplashController extends GetxController {
  var progress = 0.0.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    const duration = Duration(seconds: 5);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      progress.value += 0.02;
      if (progress.value >= 1.0) {
        timer.cancel();
        Get.offNamed('/login');
      }
    });
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}