import 'dart:developer';
import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/utils/route_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  String mail = Get.arguments;
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseHelper.firebaseHelper.logOut();
              Get.offNamed(MyRoute.login);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseHelper.firebaseHelper.getStream(mail: mail),
        builder: (context, snap) {
          if (snap.hasData) {
            DocumentSnapshot<Map<String, dynamic>> alldata = snap.data!;
            log(alldata.toString());
            Map<String, dynamic>? data = alldata.data();
            log(data.toString());
            List contacts = data!['contacts'];
            name = data['name'];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    onTap: () async {
                      Map<String, dynamic>? recieved = await FirebaseHelper
                          .firebaseHelper
                          .getUser(mail: contacts[index]);
                      Map data = {'name': recieved!['name'], 'mail': mail};
                      Get.toNamed(MyRoute.chat, arguments: data);
                    },
                    title: Text(
                      contacts[index],
                    ),
                  ),
                ),
              ),
            );
          } else if (snap.hasError) {
            return Center(
              child: Text(
                snap.error.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(mail),
              currentAccountPicture: const CircleAvatar(
                foregroundImage: NetworkImage(
                    "https://e1.pxfuel.com/desktop-wallpaper/454/79/desktop-wallpaper-wild-nature-for-whatsapp-dp-www-galleryneed-awesome-dp.jpg"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
