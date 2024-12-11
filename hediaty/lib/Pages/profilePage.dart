import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hediaty/Models/user.dart';

class ProfilePage extends StatefulWidget{

    String userID;
    ProfilePage({required this.userID});

    // TODO: implement createState
    @override
    State<ProfilePage> createState() => ProfilePageState();
}


class ProfilePageState extends State<ProfilePage>{

  late UserModel user;



  Future<void> getProfile() async{
    user = await UserModel.getUserByID(widget.userID);
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        //The app's icon
        leading: Image.asset("assets/gift_logo.jpg"),

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.green,
        // Here we take the value from the EventPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("My Profile"),

      ),
      body: FutureBuilder(
            future: getProfile(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator()); 
              }
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                    return Text("error: ${snapshot.error}");
                }
                return Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 40,backgroundImage: AssetImage("assets/youssef.jpeg"),),
                              Text(user.userName)
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            Text("Phone: ${user.phone}"),
                            Text("Email: ${user.email}")
                        ],
                        );
              }
              return Text("Hello");
            }
          )
  
    );
  }
}