import 'package:chat_app/controller/theme_controller.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/utils/route_utils.dart';
import 'package:chat_app/views/screens/aviabe_contacts.dart';
import 'package:chat_app/views/screens/chatpage.dart';
import 'package:chat_app/views/screens/homepage.dart';
import 'package:chat_app/views/screens/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: MyRoute.login,
          page: () => LoginPage(),
        ),
        GetPage(
          name: MyRoute.home,
          page: () => HomePage(),
        ),
        GetPage(
          name: MyRoute.chat,
          page: () => ChatPage(),
        ),
        GetPage(
          name: MyRoute.contacts,
          page: () => Aviable_contacts(),
        ),
      ],
    );
  }
}
