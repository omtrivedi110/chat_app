import 'dart:developer';

import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool theme = false.obs;

  changeTheme() {
    theme(!theme.value);
    update();
  }
}
