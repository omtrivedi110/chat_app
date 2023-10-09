import 'package:get/get.dart';

class Status_Controller extends GetxController {
  RxMap<String, String> status =
      {'mail': "omtrivedi460@gmail.com", 'status': "offline"}.obs;
  changeSatus({required String mystatus, required String mail}) {
    status({'mail': mail, 'status': mystatus});
  }
}
