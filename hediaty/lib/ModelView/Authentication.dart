import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Models/user.dart';

class Authentication {
  static Future<String> addUserToFirebaseAuth(
      String email, String password) async {
    var userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user!.uid;
  }

  static Future<void> addUsertoFirebaseDB(
      String ID, String name, String phone, String email) async {
    var userListRef = FirebaseDatabase.instance.ref("Users");
    await userListRef.update({
      ID: {"email": email, "name": name, "phone": phone, "eventCount": 0}
    });
  }

  static Future<bool> checkIfPhoneExists(String phone) async {
    bool result = await UserModel.checkIfPhoneExistsFirebase(phone);

    return result;
  }

  static Future<String?> login(String email, String password) async {
    String? prevID;
    if (FirebaseAuth.instance.currentUser != null) {
      prevID = FirebaseAuth.instance.currentUser!.uid;
    }

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (credential.user!.uid != prevID) {
        await DBManager.resetLocalDB();
      }

      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return null;
    }
  }

  static Future<String?> signUp(
      String name, String phone, String email, String password) async {
    bool found = await checkIfPhoneExists(phone);
    if (!found) {
      //add user to firebase Auth and Firebase RealTime Database
      String ID = await addUserToFirebaseAuth(email, password);
      await addUsertoFirebaseDB(ID, name, phone, email);
      return ID;
    }
    else{
      return null;
    }
  }
}
