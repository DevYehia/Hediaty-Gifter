import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget{
    // TODO: implement createState
    @override
    State<ProfilePage> createState() => ProfilePageState();
  }


class ProfilePageState extends State<ProfilePage>{

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
      body: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 40,backgroundImage: AssetImage("assets/youssef.jpeg"),),
              Text("Yehia")
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            )
        ],
        ),
    );
  }
}