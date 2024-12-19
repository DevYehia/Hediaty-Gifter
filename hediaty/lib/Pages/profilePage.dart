import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hediaty/Models/user.dart';

class ProfilePage extends StatefulWidget {
  String userID;
  bool isOwner;
  ProfilePage({required this.userID, required this.isOwner});

  // TODO: implement createState
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late UserModel user;

  Future<void> getProfile() async {
    user = await UserModel.getUserByID(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //The app's icon
          leading: widget.isOwner ? Image.asset("assets/gift_logo.jpg") : 
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back)),

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
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("error: ${snapshot.error}");
                }
                return Center(
                    child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, bottom: 10),
                      width: 150, // Adjust to fit the avatar + border
                      height: 150, // Adjust to fit the avatar + border
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green, // Border color
                          width: 3.0, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/youssef.jpeg"),
                      ),
                    ),
                    Text(user.userName,
                        style: TextStyle(fontSize: 24, color: Colors.green)),
                    Card(
                      color: Colors.lime,
                      elevation: 4.0, // Adds shadow for depth
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12.0), // Rounded corners
                      ),
                      margin: EdgeInsets.all(16.0), // Space around the card
                      child: Padding(
                        padding: EdgeInsets.all(16.0), // Space inside the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align text to the left
                          children: [
                            Text(
                              "Phone: ${user.phone}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                                height:
                                    12.0), // Add spacing between phone and email
                            Text(
                              "Email: ${user.email}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
              }
              return Text("Hello");
            }));
  }
}
