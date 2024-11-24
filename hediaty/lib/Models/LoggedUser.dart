import 'package:firebase_auth/firebase_auth.dart';
import 'package:hediaty/Models/user.dart';

class LoggedUser{

  static UserModel? loggedUser;
  LoggedUser._();

  static Future<UserModel> getLoggedUser() async{
    return loggedUser!;
  }

  static void logOutUser(){
    loggedUser = null;
  }

  static Future<void> logInUser() async{
      String loggedUserID = await UserModel.getUserIDByEmail(FirebaseAuth.instance.currentUser!.email!);
      loggedUser = UserModel.fromID(loggedUserID);      
      await loggedUser!.initUserModelByIDFirebase();
  }

}