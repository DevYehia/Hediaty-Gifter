import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/ModelView/UserModelView.dart';
import 'package:hediaty/Pages/mainPage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SignUpPageState();
  }
}

class SignUpPageState extends State<SignUpPage> {
  //returns ID of user
  Future<String> addUserToFirebaseAuth(String email, String password) async {
    var userCredentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredentials.user!.uid;
  }

  Future<void> addUsertoFirebaseDB(
      String ID, String name, String phone, String email) async {
    var userListRef = FirebaseDatabase.instance.ref("Users");
    await userListRef.update({
      ID: {"email": email, "name": name, "phone": phone, "eventCount": 0}
    });
  }

  void PhoneExistsUpdate(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone Already Exists")));
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Welcome To Hediaty"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: DecoratedBox(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/giftsBackground.jpg"),
                    fit: BoxFit.cover)),
            child: Center(
                child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 30),
                  child: Text(
                    "SignUp",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromRGBO(51, 204, 51, 0.5)),
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
                            icon: Icon(Icons.person),
                            iconColor: Colors.red,
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
                            icon: Icon(Icons.phone),
                            iconColor: Colors.red,
                            labelText: "Phone",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }

                            //
                            return null;
                          },
                        ),

                        //Mail Field
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.mail),
                              iconColor: Colors.red,
                              labelText: "Email",
                              hintText: "example@gmail.com"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            //Incorrect email format
                            else if (!value.contains('@')) {
                              return "Incorrect Email Format";
                            }
                            return null;
                          },
                        ),
                        //password field
                        TextFormField(
                          obscureText: true,
                          controller: passController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.key),
                            iconColor: Colors.red,
                            labelText: "Password",
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
                          obscureText: true,
                          controller: confirmPassController,
                          decoration: InputDecoration(
                            icon: Icon(Icons.key),
                            iconColor: Colors.red,
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
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (globalFormKey.currentState!.validate()) {
                                    //check if password and confirm password match
                                    if (passController.text !=
                                        confirmPassController.text) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Password Fields Don't Match")));
                                    } else {
                                      //check if phone number is already existent
                                      bool found = await UserViewModel.checkIfPhoneExists(phoneController.text,PhoneExistsUpdate);
                                      if(!found){
                                      //add user to firebase Auth and Firebase RealTime Database
                                      String ID = await addUserToFirebaseAuth(
                                          emailController.text,
                                          passController.text);
                                      await addUsertoFirebaseDB(
                                          ID,
                                          nameController.text,
                                          phoneController.text,
                                          emailController.text);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyMainPage(title: "Gifter")));
                                      }
                                    }
                                  }
                                },
                                child: Text("SignUp"))),
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }
}
