import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
      ),
      drawer: const Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("fdbdr"),
              accountEmail: Text("hjvc"),
              currentAccountPicture: CircleAvatar(
                foregroundImage: NetworkImage(
                    "https://e1.pxfuel.com/desktop-wallpaper/454/79/desktop-wallpaper-wild-nature-for-whatsapp-dp-www-galleryneed-awesome-dp.jpg"),
              ),
            ),
          ],
        ),
      ),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //       FirebaseHelper.firebaseHelper.auto_generate_pass();
      //     },
      //     child: const Text("euhifw"),
      //   ),
      // ),
    );
  }
}
