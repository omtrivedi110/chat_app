import 'dart:developer';

import 'package:chat_app/controller/button_controller.dart';
import 'package:chat_app/controller/status_controller.dart';
import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/helpers/notification_helper.dart';
import 'package:chat_app/helpers/notification_helper.dart';
import 'package:chat_app/modals/chat_modal.dart';
import 'package:chat_app/views/screens/components/iconbutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // initState() {
    //   WidgetsBinding.instance.addObserver(this);
    // }
    //
    // dispose() {
    //   WidgetsBinding.instance.removeObserver(this);
    // }

    switch (state) {
      case AppLifecycleState.paused:
        log("tgjkhjgxtyu");
        FirebaseHelper.firebaseHelper.offline(mail: data['mail']);
        break;
      case AppLifecycleState.resumed:
        log("tgjkhjgxtyu");
        FirebaseHelper.firebaseHelper.online(mail: data['mail']);
        break;
      default:
        FirebaseHelper.firebaseHelper.offline(mail: data['mail']);
    }
  }

  Map data = Get.arguments;
  String upValue = "";

  Button_Controller button_Controller = Get.put(Button_Controller());
  Status_Controller status_controller = Get.put(Status_Controller());
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(data['name']),
            Obx(() {
              return Text(
                status_controller.status.value == "online" ? "😊" : "😴",
              );
            }),
          ],
        ),
        leading: MyBack(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
              Map<String, dynamic>? userData = doc!.data();

              //sent Data
              List sentChat = userData!['sent']['${data['reciever']}']['msg'];
              List sentTime = userData['sent']['${data['reciever']}']['time'];

              //statusCheck
              status_controller.changeSatus(mystatus: userData['status']);

              //recieved Data
              List recievedChat =
                  userData['recieved']['${data['reciever']}']['msg'];
              List recievedTime =
                  userData['recieved']['${data['reciever']}']['time'];

              //Time Sorting(Sender)
              List<DateTime> rTime = recievedTime.map((e) {
                String day = e.split('-')[0].split('/')[0];
                String month = e.split('-')[0].split('/')[1];
                String year = e.split('-')[0].split('/')[2];
                String hour = e.split('-')[1].split(':')[0];
                String minut = e.split('-')[1].split(':')[1];
                DateTime d = DateTime(
                  int.parse(year),
                  int.parse(month),
                  int.parse(day),
                  int.parse(hour),
                  int.parse(minut),
                );
                return d;
              }).toList();

              //Time Sorting(Reciever)
              List<DateTime> sTime = sentTime.map((e) {
                String day = e.split('-')[0].split('/')[0];
                String month = e.split('-')[0].split('/')[1];
                String year = e.split('-')[0].split('/')[2];
                String hour = e.split('-')[1].split(':')[0];
                String minut = e.split('-')[1].split(':')[1];
                DateTime d = DateTime(int.parse(year), int.parse(month),
                    int.parse(day), int.parse(hour), int.parse(minut));
                return d;
              }).toList();

              List<ChatModal> alldata = List.generate(
                sTime.length,
                (index) => ChatModal(sentChat[index], sTime[index], "sent"),
              );
              alldata.addAll(
                List.generate(
                  rTime.length,
                  (index) => ChatModal(
                    recievedChat[index],
                    rTime[index],
                    "recieved",
                  ),
                ),
              );

              alldata.sort((c1, c2) => c1.time.isAfter(c2.time) ? 1 : 0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: alldata.length,
                      itemBuilder: (context, index) => GestureDetector(
                        onLongPress: () {
                          if (alldata[index].type == "sent") {
                            showDialog(
                                context: context,
                                builder: (context) => Obx(() {
                                      return AlertDialog(
                                        title: const Text(
                                            "What do you want to Do ?"),
                                        content: Visibility(
                                          visible:
                                              button_Controller.up_btn.value,
                                          child: TextField(
                                            onSubmitted: (val) {
                                              FirebaseHelper.firebaseHelper
                                                  .editChat(
                                                      sender: data['mail'],
                                                      reciever:
                                                          data['recievedMail'],
                                                      index: sentChat.indexOf(
                                                          alldata[index].msg),
                                                      newMsg: val);
                                            },
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton.icon(
                                            onPressed: () {
                                              if (button_Controller
                                                  .up_btn.value) {
                                                FirebaseHelper.firebaseHelper
                                                    .editChat(
                                                        sender: data['mail'],
                                                        reciever: data[
                                                            'recievedMail'],
                                                        index: sentChat.indexOf(
                                                            alldata[index].msg),
                                                        newMsg: upValue);
                                              }
                                              button_Controller.changeUpdate();
                                            },
                                            icon: const Icon(Icons.cancel),
                                            label: const Text("Update"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              FirebaseHelper.firebaseHelper
                                                  .deleteChat(
                                                sender: data['mail'],
                                                reciever: data['recievedMail'],
                                                index: sentChat.indexOf(
                                                    alldata[index].msg),
                                              );
                                            },
                                            child: const Text("Delete"),
                                          ),
                                        ],
                                      );
                                    }));
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: alldata[index].type == "sent"
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  topLeft: alldata[index].type == "sent"
                                      ? const Radius.circular(30)
                                      : Radius.zero,
                                  bottomLeft: const Radius.circular(30),
                                  bottomRight: const Radius.circular(30),
                                  topRight: alldata[index].type == "sent"
                                      ? Radius.zero
                                      : const Radius.circular(30),
                                ),
                              ),
                              child: Text(
                                alldata[index].msg,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          FirebaseHelper.firebaseHelper.addChat(
                              sender: data['mail'],
                              reciever: data['recievedMail'],
                              newMsg: chatController.text);
                          Notification_Helper.notification_helper
                              .initNotification();
                          Notification_Helper.notification_helper
                              .simpleNotification(
                                  mail: data['mail'], msg: chatController.text);
                          chatController.clear();
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (val) {
                      FirebaseHelper.firebaseHelper.addChat(
                        sender: data['mail'],
                        reciever: data['recievedMail'],
                        newMsg: chatController.text,
                      );
                      Notification_Helper.notification_helper
                          .initNotification();
                      Notification_Helper.notification_helper
                          .simpleNotification(
                              mail: data['mail'], msg: chatController.text);
                      chatController.clear();
                    },
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
