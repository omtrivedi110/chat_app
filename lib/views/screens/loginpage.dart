import 'package:chat_app/helpers/firebase_helper.dart';
import 'package:chat_app/modals/user_modal.dart';
import 'package:chat_app/utils/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  String id = "";
  String pass = "";
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size s = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              height: s.height * 0.4,
              width: s.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Chat 💬",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Form(
              key: formkey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "xyz@gmial.com",
                      labelText: "id",
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (val) {
                      id = val!;
                    },
                    validator: (val) =>
                        (val!.isEmpty) ? "Please Enter Your id" : null,
                  ),
                  Gap(s.height * 0.02),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: passController,
                    decoration: InputDecoration(
                      hintText: "1234",
                      suffixIcon: IconButton(
                        onPressed: () {
                          passController.text = FirebaseHelper.firebaseHelper
                              .auto_generate_pass();
                        },
                        icon: const Icon(Icons.password_rounded),
                      ),
                      labelText: "Password",
                      border: const OutlineInputBorder(),
                    ),
                    onSaved: (val) {
                      pass = val!;
                    },
                    validator: (val) =>
                        (val!.isEmpty) ? "Enter password" : null,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  formkey.currentState!.save();
                  FirebaseHelper.firebaseHelper
                      .addUser(pass: pass, id: int.parse(id));
                  UserModal userModal = UserModal(id, pass);
                  Get.offNamed(MyRoute.home, arguments: userModal);
                }
              },
              child: const Text("Sign In"),
            ),
            Gap(s.height * 0.01),
            TextButton.icon(
              onPressed: () {
                FirebaseHelper.firebaseHelper.google_sign_in();
                Get.offNamed(MyRoute.home);
              },
              icon: const Icon(Icons.g_mobiledata_sharp),
              label: const Text("Google"),
            ),
            Gap(s.height * 0.15),
            TextButton(
              onPressed: () {
                bool guest = FirebaseHelper.firebaseHelper.guest();
                UserModal user = UserModal(
                  'Guest',
                  FirebaseHelper.firebaseHelper.auto_generate_pass(),
                );
                guest
                    ? Get.off(MyRoute.home, arguments: user)
                    : Get.snackbar("😔", "🤔");
              },
              child: const Text("Login As Guest"),
            ),
          ],
        ),
      ),
    );
  }
}
