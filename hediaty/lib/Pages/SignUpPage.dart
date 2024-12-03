import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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

  //returns ID of user
  Future<String> addUserToFirebaseAuth(String email, String password) async{
    var userCredentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user!.uid;
  }

  
  Future<void> addUsertoFirebaseDB(String ID, String name, String phone, String email) async{

    var userListRef = FirebaseDatabase.instance.ref("Users");
    await userListRef.update(
      { ID:
        {
        "email" : email,
        "name" : name,
        "phone" : phone,
        "eventCount" : 0
      }
    });
  }



  @override
  Widget build(BuildContext context) {

    var globalFormKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final passController = TextEditingController();
    final confirmPassController = TextEditingController();

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

                    //Name Field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Name';
                        }
                        return null;
                      },
                    ),

                    //phone field
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        hintText: ""
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),

                    //Mail Field
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: ""
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    //password field
                    TextFormField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "example@gmail.com"
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                    ),

                    //Confirm Password Field
                    TextFormField(
                      controller: confirmPassController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Password';
                        }
                        return null;
                      },
                    ),

                    //sign-up button
                    Container(
                      padding: EdgeInsets.only(top: 50),
                      child: ElevatedButton(onPressed: () async{
                      if(globalFormKey.currentState!.validate()){
                        //add user to firebase Auth and Firebase RealTime Database
                        String ID = await addUserToFirebaseAuth(emailController.text, passController.text);
                        await addUsertoFirebaseDB(ID,nameController.text, phoneController.text, emailController.text);



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