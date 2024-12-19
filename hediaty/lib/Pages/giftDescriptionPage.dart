import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Models/user.dart';
import 'package:hediaty/darkModeSelection.dart';

class GiftDescriptionPage extends StatefulWidget {
  final String title;
  Gift gift;
  final bool isOwner;
  final bool isPledged;
  final String userID;

  GiftDescriptionPage({
    required this.title,
    required this.gift,
    required this.isOwner,
    required this.isPledged,
    required this.userID,
  });

  @override
  State<GiftDescriptionPage> createState() => _GiftDescriptionPageState();
}

class _GiftDescriptionPageState extends State<GiftDescriptionPage> {

  bool? darkMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    darkMode = DarkModeSelection.getDarkMode();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode == false ? Colors.white : Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.purple,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Icon(Icons.image),
                radius: 40,
              ),
              Container(
                margin: EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Description: ",
                          style: TextStyle(fontFamily: "Merienda", fontSize: 20,
                          color: darkMode == false ? Colors.black : Colors.white),
                        ),
                        Flexible(
                          child: Text(
                            widget.gift.description == null || widget.gift.description == ""
                                ? "No Description Available"
                                : widget.gift.description!,
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: "Merienda",
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Category: ",
                          style: TextStyle(fontFamily: "Merienda", fontSize: 20,
                          color: darkMode == false ? Colors.black : Colors.white),
                        ),
                        Text(
                          widget.gift.category!,
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Merienda",
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Price: ",
                          style: TextStyle(fontFamily: "Merienda", fontSize: 20,
                          color: darkMode == false ? Colors.black : Colors.white),
                        ),
                        Text(
                          widget.gift.price.toString(),
                          style: TextStyle(
                            color: Colors.red,
                            fontFamily: "Merienda",
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    (widget.isOwner || widget.isPledged)
                        ? const SizedBox.shrink()
                        : ElevatedButton(
                            onPressed: () {
                              Gift.pledgeFriendGift(
                                  widget.gift.firebaseID!,
                                  UserModel.getLoggedUserID());
                              Navigator.pop(context);
                            },
                            child: Text("Pledge"),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
