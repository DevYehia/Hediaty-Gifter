// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/ModelView/Authentication.dart';
import 'package:hediaty/ModelView/UserModelView.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Pages/EnterLoadPage.dart';
import 'package:hediaty/Pages/SignUpPage.dart';
import 'package:hediaty/Pages/mainPage.dart';
import 'package:hediaty/darkModeSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage();
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  Future<void> authAndRedirect(String email, String password) async {
    Authentication.login(email, password).then(
      (userID) async{
        if (userID != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MyMainPage(title: "Gifter", userID: userID!,)));
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Incorrect Mail or Password")));
        }
      },
    );
    await DarkModeSelection.getDarkModeFromPref();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoadingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    var globalFormKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passController = TextEditingController();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Welcome To Hediaty"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: DecoratedBox(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/giftsBackground.jpg"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 30),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(51, 204, 51, 0.5)),
                  padding: const EdgeInsets.all(30),
                  width: 400,
                  child: Form(
                    key: globalFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          key: Key("LoginEmailField"),
                          controller: emailController,
                          decoration: const InputDecoration(
                              icon: Icon(Icons.mail),
                              iconColor: Colors.red,
                              labelText: "Mail",
                              hintText: "example@gmail.com"),
                          validator: (value) {
                            //Empty Field
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }

                            //Incorrect email format
                            else if (!value.contains('@')) {
                              return "Incorrect Email Format";
                            }

                            //good format
                            return null;
                          },
                        ),
                        TextFormField(
                          key: Key('LoginPasswordField'),
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.key),
                            iconColor: Colors.red,
                            labelText: "Password",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        Container(
                            padding: EdgeInsets.only(top: 50),
                            child: ElevatedButton(
                              key: Key("LoginButton"),
                                onPressed: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (globalFormKey.currentState!.validate()) {
                                    await authAndRedirect(emailController.text,
                                        passController.text);
                                  }
                                },
                                child: Text("Login"))),
                        Container(
                            padding: EdgeInsets.only(top: 30),
                            child: InkWell(
                              child: Text(
                                "Don't Have an Account? Click Here",
                                style: TextStyle(color: Colors.red),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }
}
