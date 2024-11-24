import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/user.dart';
import '../CustomWidgets/friend_widget.dart';
import '../Pages/eventsPage.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  late List<FriendWidget> friendList = [];

  Future<void> initFriendsList() async{
    print("email is ${FirebaseAuth.instance.currentUser!.email!}");
    UserModel loggedInUser = await LoggedUser.getLoggedUser();
    List<UserModel> friendModelList = await loggedInUser.getAllFriendsFirebase();
    friendList = friendModelList.map((friend) => FriendWidget(friendName: friend.userName),).toList();
    print(friendList);
  }



  @override
  Widget build(BuildContext context) {
    //initFriendsList();
    final TextEditingController newFriendNameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        //The app's icon
        leading: Image.asset("assets/gift_logo.jpg"),

        backgroundColor: Colors.blue,
        title: Text(widget.title),

        actions: <Widget>[
          IconButton(
            onPressed: () {
              print("Enta");
              //showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: Icon(Icons.search)
          ),
          IconButton(
            onPressed: (){//setState(() {
              print("Oi Stop"); 
              showDialog(context: context, builder:  (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Friend'),
                  content: TextField(
                    controller: newFriendNameController,
                    decoration: InputDecoration(hintText: 'Enter friend\'s Phone Number'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async{
                          String friendPhone = newFriendNameController.text;
                          UserModel loggedInUser = await LoggedUser.getLoggedUser();
                          await UserModel.addFriend(loggedInUser.userID,friendPhone);
                          await initFriendsList();                       
                        setState(() {

                          // Handle adding the friend (e.g., API call)
                          
                        });
                        Navigator.of(context).pop(); // Close the dialog           
                      },
                      child: Text('Add'),
                    ),
                  ],
                );
              },);
            },
            tooltip: "Add Friend",
            icon: const Icon(Icons.add)),
        ],
      ),
      body:  FutureBuilder(
        future: initFriendsList(), 
        builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                    return Text("error: ${snapshot.error}");
                }
                return  SingleChildScrollView(
                          child: Center( child: Column(
                            children: friendList
                          )
                          )
                );
              }
              return Text("Hello");
            }
      )
    );
  }
}
