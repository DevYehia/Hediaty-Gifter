import 'package:flutter/material.dart';
import 'package:hediaty/Pages/mainPage.dart';

class SignUpPage extends StatefulWidget{

  const SignUpPage();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpPageState();
  }

}

class SignUpPageState extends State<SignUpPage>{
  @override
  Widget build(BuildContext context) {

    var globalFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome To Hediaty"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          onPressed: (){Navigator.pop(context);}, 
          icon: Icon(Icons.arrow_back)
          ),
          ),
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
              child: Text("SignUp",style: TextStyle(fontSize: 20),),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MyMainPage(title: "Gifter")));
                      }
                    }, 
                    child: Text("SignUp"))
                    ),
                  ],
                  ),
                  ),
            )
          ],)
      )
    ));


  }

}