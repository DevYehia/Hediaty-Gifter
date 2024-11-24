import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Pages/SignUpPage.dart';
import 'package:hediaty/Pages/mainPage.dart';

class LoginPage extends StatefulWidget{

  const LoginPage();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }

}

class LoginPageState extends State<LoginPage>{

  void authAndRedirect (String email, String password) async{

    try{
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
     );
      await LoggedUser.logInUser();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyMainPage(title: "Gifter")));
    }
    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      }

  }


  @override
  Widget build(BuildContext context) {

    var globalFormKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("Welcome To Hediaty"),centerTitle: true,backgroundColor: Colors.blue,),
      body:
        DecoratedBox(decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/giftsBackground.jpg"),
              fit: BoxFit.cover
          )
        ),
        child: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 30),
              child: Text("Login",style: TextStyle(fontSize: 20),),
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color.fromRGBO(51, 204, 51, 0.5)),
              padding: EdgeInsets.all(30),
              width: 400,
              child: Form(
                key: globalFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Mail",
                        hintText: "example@gmail.com"
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: "Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      child: ElevatedButton(onPressed: (){
                      if(globalFormKey.currentState!.validate()){
                        authAndRedirect(emailController.text, passController.text);
                      }
                    }, 
                    child: Text("Login"))
                    ),
                    Container(
                      padding: EdgeInsets.only(top:30),
                      child:
                      InkWell(
                        child: Text("Don't Have an Account? Click Here", style: TextStyle(color: Colors.red),),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                        },
                      )
                    )
                  ],
                  ),
                  ),
            )
          ],)
      )
    ));


  }

}