import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/utils/route_utils.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
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
      ],
    );
  }
}
