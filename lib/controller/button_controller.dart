import 'package:get/get.dart';

class Button_Controller extends GetxController {
  RxBool up_btn = false.obs;

  changeUpdate() {
    up_btn(!up_btn.value);
  }
}
