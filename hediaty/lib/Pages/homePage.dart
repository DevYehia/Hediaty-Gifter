import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/friendSearchDelegate.dart';
import 'package:hediaty/ModelView/UserModelView.dart';
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
  late UserViewModel viewModel;

  void addedEventNotif(String? userName){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${userName??"User"} Added Event")));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = UserViewModel(
        UIAddEvent: addedEventNotif,
        refreshCallback: () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //initFriendsList();
    final TextEditingController newFriendNameController =
        TextEditingController();
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
                  showSearch(
                      context: context,
                      delegate: FriendSearchDelegate(
                          friendWidgetList: viewModel.allFriendList));
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  //setState(() {
                  print("Oi Stop");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Friend'),
                        content: TextField(
                          controller: newFriendNameController,
                          decoration: InputDecoration(
                              hintText: 'Phone Number'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              String friendPhone = newFriendNameController.text;
                              bool addResult = await viewModel.addFriend(friendPhone);
                              if(addResult){
                                setState(() {
                                  // Handle adding the friend (e.g., API call)
                                });
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone Not Found or already friend")));
                              }
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                tooltip: "Add Friend",
                icon: const Icon(Icons.add)),
          ],
        ),
        body: FutureBuilder(
            future: viewModel.initFriendsList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("error: ${snapshot.error}");
                }
                return SingleChildScrollView(
                    child: Center(child: Column(children: snapshot.data!)));
              }
              return Text("Hello");
            }));
  }
}
