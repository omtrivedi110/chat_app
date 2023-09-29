import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  FirebaseHelper._();

  String collection = "user";
  String idCollection = "user_id";
  String idDocs = "id";
  String mymail = "";
  static final FirebaseHelper firebaseHelper = FirebaseHelper._();
  GoogleSignIn signIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStream(
      {required String mail}) {
    return firestore.collection(collection).doc(mail).snapshots();
  }

  Future<Map<String, dynamic>?> getUser({required String mail}) async {
    mymail = mail;
    DocumentSnapshot<Map<String, dynamic>> doc =
        await firestore.collection(collection).doc(mail).get();
    Map<String, dynamic>? data = doc.data();
    return data;
  }

  deleteChat(
      {required String sender,
      required String reciever,
      required int index}) async {
    Map<String, dynamic>? senderMap = await getUser(mail: sender);
    Map<String, dynamic>? recievedMap = await getUser(mail: reciever);

    senderMap!['sent']['${recievedMap!['id']}']['msg'].removeAt(index);
    senderMap['sent']['${recievedMap['id']}']['time'].removeAt(index);

    recievedMap['recieved']['${senderMap['id']}']['msg'].removeAt(index);
    recievedMap['recieved']['${senderMap['id']}']['time'].removeAt(index);

    firestore.collection(collection).doc(sender).set(senderMap);
    firestore.collection(collection).doc(reciever).set(recievedMap);
  }

  offline({required String mail}) async {
    Map<String, dynamic>? tmpdata = await getUser(mail: mail);
    tmpdata!['status'] = "offline";

    firestore.collection(collection).doc(mail).set(tmpdata);

    dev.log(tmpdata.toString());
  }

  online({required String mail}) async {
    Map<String, dynamic>? tmpdata = await getUser(mail: mail);
    tmpdata!['status'] = "online";

    firestore.collection(collection).doc(mail).set(tmpdata);
  }

  editChat(
      {required String sender,
      required String reciever,
      required int index,
      required String newMsg}) async {
    Map<String, dynamic>? senderMap = await getUser(mail: sender);
    Map<String, dynamic>? recievedMap = await getUser(mail: reciever);

    senderMap!['sent']['${recievedMap!['id']}']['msg'][index] = newMsg;

    recievedMap['recieved']['${senderMap['id']}']['msg'][index] = newMsg;

    firestore.collection(collection).doc(sender).set(senderMap);
    firestore.collection(collection).doc(reciever).set(recievedMap);
  }

  addChat(
      {required String sender,
      required String reciever,
      required String newMsg}) async {
    Map<String, dynamic>? senderMap = await getUser(mail: sender);
    Map<String, dynamic>? recievedMap = await getUser(mail: reciever);

    String time =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}-${DateTime.now().hour}:${DateTime.now().minute}";

    senderMap!['sent']['${recievedMap!['id']}']['msg'].add(newMsg);
    senderMap['sent']['${recievedMap['id']}']['time'].add(time);

    recievedMap['recieved']['${senderMap['id']}']['msg'].add(newMsg);
    recievedMap['recieved']['${senderMap['id']}']['time'].add(time);

    firestore.collection(collection).doc(sender).set(senderMap);
    firestore.collection(collection).doc(reciever).set(recievedMap);
  }

  // addUser({required String pass, required int id}) async {
  //   Map<String, dynamic> data = {
  //     'pass': pass,
  //     'age': "18",
  //   };
  //   firestore.collection(collection).doc(id.toString()).set(data);
  // }

  logOut() {
    FirebaseAuth.instance.signOut();
    signIn.signOut();
  }

  // ignore: non_constant_identifier_names
  google_Sign_In() async {
    GoogleSignInAccount? account = await signIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  //guest
  guest() {
    try {
      FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (error) {
      Get.snackbar("Error Occured...", "Error : $error");
      return false;
    }
  }

  // ignore: non_constant_identifier_names
  String auto_generate_pass() {
    List number = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'];
    List alphabet = [
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      'h',
      'i',
      'j',
      'k',
      'l',
      'm',
      'n',
      'o',
      'p',
      'q',
      'r',
      's',
      't',
      'u',
      'v',
      'w',
      'x',
      'y',
      'z'
    ];
    List special = ['!', '@', '#', '%', '^', '&', '*', '~', '*'];
    Random r1 = Random();
    int a = r1.nextInt(24);
    int b = r1.nextInt(10);
    int c = r1.nextInt(9);

    String pass = alphabet[a] +
        alphabet[(a + 3) % 24] +
        number[(b + 3) % 10] +
        special[(c + 3) % 9] +
        alphabet[(a + 6) % 24] +
        special[c] +
        number[b] +
        number[(b + 1) % 10] +
        alphabet[a] +
        alphabet[(a + 1) % 24];

    return pass;
  }
}
