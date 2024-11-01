import 'package:flutter/material.dart';
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

  //to-do
  //get logged-in user from somewhere
  User loggedInUser = User.fromID(1);
  late List<FriendWidget> friendList = [];

  void initFriendsList() async{
    List<User> friendModelList = await loggedInUser.getAllFriends();
    friendList = friendModelList.map((friend) => FriendWidget(friendName: friend.userName),).toList();

    //rerender page in case page rendered before friends update
    setState(() {
      
    });
  }



  @override
  Widget build(BuildContext context) {
    initFriendsList();
    final TextEditingController newFriendNameController = TextEditingController();
    SearchDelegate idk;
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
                    decoration: InputDecoration(hintText: 'Enter friend\'s name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          String friendName = newFriendNameController.text;
                          // Handle adding the friend (e.g., API call)
                          friendList.add(FriendWidget(friendName: friendName));
                          print('Adding friend: $friendName');
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
      body:  SingleChildScrollView(
        child: Column(
          children: friendList
    )
      ),
    );
  }
}
