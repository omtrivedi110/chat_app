import 'package:get/get.dart';

class Status_Controller extends GetxController {
  RxString status = "Offline".obs;
  changeSatus({required String mystatus}) {
    status(mystatus);
  }
}
