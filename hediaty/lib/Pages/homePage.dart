import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/friendSearchDelegate.dart';
import 'package:hediaty/ModelView/UserModelView.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/darkModeSelection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomWidgets/friend_widget.dart';
import '../Pages/eventsPage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, this.darkMode});
  final String title;
  bool? darkMode;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late UserViewModel viewModel;
  bool? darkMode;

  void addedEventNotif(String? userName) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${userName ?? "User"} Added Event")));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    darkMode = DarkModeSelection.darkMode;

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
    print("dark choice is $darkMode");
    return Scaffold(
        backgroundColor:
            darkMode == null || darkMode == false ? Colors.white : Colors.black,
        appBar: AppBar(
          key: Key("FriendsPageAppbar"),
          //The app's icon
          leading: darkMode == false
              ? Image.asset("assets/gift_logo.jpg")
              : Image.asset("assets/gift_logo_inverted.jpg"),

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
                key: Key("AddFriendButton"),
                onPressed: () {
                  //setState(() {
                  print("Oi Stop");
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        surfaceTintColor:
                            darkMode == true ? Colors.white : Colors.black,
                        shadowColor:
                            darkMode == true ? Colors.white : Colors.black,
                        backgroundColor:
                            darkMode == true ? Colors.black : Colors.white,
                        title: Text('Add Friend',
                            style: TextStyle(
                                color:
                                    darkMode! ? Colors.white : Colors.black)),
                        content: TextField(
                          style: TextStyle(
                              color: darkMode == true
                                  ? Colors.white
                                  : Colors.black),
                          key: Key("NewFriendPhone"),
                          controller: newFriendNameController,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(
                                  color: darkMode == true
                                      ? Colors.white
                                      : Colors.black),
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
                            key: Key("AddFriendDialogButton"),
                            onPressed: () async {
                              String friendPhone = newFriendNameController.text;
                              bool addResult =
                                  await viewModel.addFriend(friendPhone);
                              if (addResult) {
                                setState(() {
                                  // Handle adding the friend (e.g., API call)
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        key: Key("AddFailedSnack"),
                                        content: Text(
                                            "Phone Not Found or already friend")));
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
