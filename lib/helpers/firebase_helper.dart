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

  addIntoContact({required String mail, required String reciever}) async {
    Map<String, dynamic>? sender = await getUser(mail: mail);
    Map<String, dynamic>? recieve = await getUser(mail: reciever);
    sender!['contacts'].add(reciever);
    recieve!['contacts'].add(mail);

    Map<String, dynamic> sent = {
      '${recieve['id']}': {
        'msg': ["hi"],
        'time': ["10/10/2023-07:00"]
      }
    };

    Map<String, dynamic> rec = {
      "${recieve['id']}": {
        'msg': ["hello"],
        'time': ["10/10/2023-07:03"]
      }
    };

    Map<String, dynamic> sent2 = {
      '${sender['id']}': {
        'msg': ["hi"],
        'time': ["10/10/2023-07:00"]
      }
    };

    Map<String, dynamic> rec2 = {
      "${sender['id']}": {
        'msg': ["hello"],
        'time': ["10/10/2023-07:03"]
      }
    };

    sender['sent'].addAll(sent);
    sender['recieved'].addAll(rec);
    recieve['sent'].addAll(rec2);
    recieve['recieved'].addAll(sent2);

    firestore.collection(collection).doc(mail).set(sender);
    firestore.collection(collection).doc(reciever).set(recieve);
  }

  addContactData({required String senderMail, String? pass}) async {
    String mail = "omtrivedi460@gmail.com";
    DocumentSnapshot snapshot =
        await firestore.collection(idCollection).doc("id").get();
    DocumentSnapshot<Map<String, dynamic>> omsnap =
        await firestore.collection(collection).doc(mail).get();
    Map<String, dynamic>? ommap = omsnap.data();
    Map<String, dynamic>? myid = snapshot.data() as Map<String, dynamic>?;
    int id = myid!['id'];
    id++;
    Map<String, dynamic> data = {
      "contacts": [mail],
      "name": "Newuser",
      "mail": senderMail,
      "pass": pass ?? "iamnew$id",
      "id": id,
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
    ommap!['contacts'].add(senderMail);
    ommap['recieved'].addAll({
      '$id': {'msg': [], 'time': []}
    });
    ommap['sent'].addAll({
      '$id': {'msg': [], 'time': []}
    });
    firestore.collection(collection).doc(senderMail).set(data);
    firestore.collection(collection).doc(mail).set(ommap);
    firestore.collection(idCollection).doc("id").set({'id': id});
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

  Stream<QuerySnapshot<Map<String, dynamic>>> getAviableContact() {
    return firestore.collection(collection).snapshots();
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

  // deleteContact(
  //     {required int index,
  //     required String mail,
  //     required String recieverMail}) async {
  //   Map<String, dynamic>? senderMap = await getUser(mail: mail);
  //   Map<String, dynamic>? recievedMap = await getUser(mail: recieverMail);
  //
  //   senderMap!['contacts'].remove(index);
  //   recievedMap!['contacts'].remove(recieverMail);
  //
  //   senderMap['recieved'].remove(recievedMap['id']);
  //   senderMap['sent'].remove(recievedMap['id']);
  //   recievedMap['sent'].remove(senderMap['id']);
  //   recievedMap['recieved'].remove(senderMap['id']);
  //
  //   firestore.collection(collection).doc(mail).set(senderMap);
  //   firestore.collection(collection).doc(recieverMail).set(recievedMap);
  // }

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
