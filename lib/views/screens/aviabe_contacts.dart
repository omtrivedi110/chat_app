import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/views/components/iconbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class Aviable_contacts extends StatelessWidget {
  Aviable_contacts({super.key});

  String mail = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: MyBack(),
        title: const Text("Add In Your Contact List"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseHelper.firebaseHelper.getAviableContact(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> tmpdata =
                snap.data!.docs;
            List mapdata = tmpdata.map((e) => e.data()).toList();
            return ListView.separated(
              itemCount: mapdata.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  title: Text(mapdata[index]['name']),
                  trailing: TextButton(
                    onPressed: () {
                      FirebaseHelper.firebaseHelper.addIntoContact(
                          mail: mail, reciever: mapdata[index]['mail']);
                    },
                    child: const Text("Add"),
                  ),
                ),
              ),
              separatorBuilder: (context, ind) => const Divider(),
            );
          } else if (snap.hasError) {
            return Center(
              child: Text(snap.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
