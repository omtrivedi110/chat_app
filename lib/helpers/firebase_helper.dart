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
  }

  addContactData({required String mail, required String senderMail}) async {
    DocumentSnapshot snapshot =
        await firestore.collection(idCollection).doc("id").get();
    Map<String, dynamic>? myid = snapshot.data() as Map<String, dynamic>?;
    myid!['id']++;
    Map<String, dynamic> data = {
      "contacts": [mail],
      "name": "Newuser",
      "pass": "iamnew${myid['id']}",
      "id": myid['id'],
      "recieved": {
        '102': {
          'msg': [],
          'time': [],
        }
      },
      "sent": {
        '102': {
          'msg': [],
          "time": [],
        }
      },
      "status": "offline",
    };
    firestore.collection(collection).doc(senderMail).set(data);
  }

  Future<String> getId() async {
    DocumentSnapshot snapshot =
        await firestore.collection(idCollection).doc("id").get();
    Map<String, dynamic>? myid = snapshot.data() as Map<String, dynamic>?;
    return myid!['id'];
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

  logOut() {
    FirebaseAuth.instance.signOut();
    signIn.signOut();
  }

  guest() {
    try {
      FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (error) {
      Get.snackbar("Error Occured...", "Error : $error");
      return false;
    }
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
