import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/views/screens/components/iconbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  Map data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        centerTitle: true,
        leading: MyBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: StreamBuilder(
          stream: FirebaseHelper.firebaseHelper.getStream(
            mail: data['mail'],
          ),
          builder: (context, snap) {
            if (snap.hasError) {
              return Center(
                child: Text(
                  snap.error.toString(),
                ),
              );
            } else if (snap.hasData) {
              DocumentSnapshot<Map<String, dynamic>>? doc = snap.data;
              Map<String, dynamic>? data = doc!.data();
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView(),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.send_rounded),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (val) {},
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
