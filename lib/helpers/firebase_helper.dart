import 'dart:developer' as dev;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseHelper {
  FirebaseHelper._();

  String collection = "student";
  static final FirebaseHelper firebaseHelper = FirebaseHelper._();
  GoogleSignIn signIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  guest() {
    try {
      FirebaseAuth.instance.signInAnonymously();
      return true;
    } on FirebaseAuthException catch (error) {
      dev.log(error.toString());
      return false;
    }
  }

  addUser({required String pass, required int id}) async {
    Map<String, dynamic> data = {
      'pass': pass,
      'age': "18",
    };
    firestore.collection(collection).doc(id.toString()).set(data);
    // log(om.toString());
  }

  google_sign_in() async {
    GoogleSignInAccount? account = await signIn.signIn();
    GoogleSignInAuthentication authentication = await account!.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    FirebaseAuth.instance.signInWithCredential(authCredential);
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

    String pass = "Guest" +
        special[c] +
        number[b] +
        number[(b + 1) % 10] +
        alphabet[a] +
        alphabet[(a + 1) % 24];

    return pass;
  }
}
