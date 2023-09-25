import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget MyBack() {
  return IconButton(
    onPressed: () => Get.back(),
    icon: const Icon(Icons.arrow_back_ios),
  );
}
