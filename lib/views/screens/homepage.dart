import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat_app/controller/theme_controller.dart';
import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/utils/route_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  HomePage({super.key});

  String mail = Get.arguments;
  String name = "";
  ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text("Change Theme"),
                      onTap: () {
                        themeController.theme.value
                            ? Get.changeThemeMode(ThemeMode.dark)
                            : Get.changeThemeMode(ThemeMode.light);
                        themeController.changeTheme();
                      },
                    ),
                    PopupMenuItem(
                      child: const Text("Sign Out"),
                      onTap: () {
                        FirebaseHelper.firebaseHelper.logOut();
                        Get.offNamed(MyRoute.login);
                      },
                    )
                  ]),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseHelper.firebaseHelper.getStream(mail: mail),
        builder: (context, snap) {
          if (snap.hasData) {
            DocumentSnapshot<Map<String, dynamic>> alldata = snap.data!;
            Map<String, dynamic>? data = alldata.data();
            if (data == null) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      "We don't have user so please click on '+' Button to register yourself...",
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 150),
                    ),
                  ],
                  totalRepeatCount: 1,
                  pause: const Duration(milliseconds: 10),
                  displayFullTextOnTap: true,
                  stopPauseOnTap: true,
                )),
              );
            } else {
              List contacts = data['contacts'];
              name = data['name'];
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          trailing: Text(""),
                          onTap: () async {
                            Map<String, dynamic>? recieved =
                                await FirebaseHelper.firebaseHelper
                                    .getUser(mail: contacts[index]);
                            Map? data2;
                            if (recieved != null) {
                              data2 = {
                                'name': recieved['name'],
                                'mail': mail,
                                'reciever': recieved['id'],
                                'recievedMail': contacts[index],
                              };
                            }
                            if (recieved == null) {
                              data2 = {
                                'name': "Kirti Kakalotar",
                                'mail': mail,
                                'reciever':
                                    await FirebaseHelper.firebaseHelper.getId(),
                                'recievedMail': contacts[index],
                              };
                              FirebaseHelper.firebaseHelper.addContactData(
                                  mail: mail, senderMail: contacts[index]);
                            }
                            Get.toNamed(MyRoute.chat, arguments: data2);
                          },
                          title: Text(contacts[index].split('@')[0]),
                        ),
                      );
                    }),
              );
            }
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(name),
              accountEmail: Text(mail),
              currentAccountPicture: const CircleAvatar(
                foregroundImage: NetworkImage(
                  "https://e1.pxfuel.com/desktop-wallpaper/454/79/desktop-wallpaper-wild-nature-for-whatsapp-dp-www-galleryneed-awesome-dp.jpg",
                ),
              ),
            ),
            TextButton(
                onPressed: () {
                  FirebaseHelper.firebaseHelper.logOut();
                  Get.offNamed(MyRoute.login);
                },
                child: const Text("Sign Out"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (con) => AlertDialog(
              title: const Text("Add a contact"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onSubmitted: (val) {},
                    decoration: const InputDecoration(
                      hintText: "xyz@gmail.com",
                      labelText: "Mail",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    onSubmitted: (val) {},
                    decoration: const InputDecoration(
                      hintText: "1234",
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Register me"),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text("Cancel"),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
