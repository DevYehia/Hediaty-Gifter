import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/gift.dart';

class GiftDescriptionPage extends StatelessWidget{
  final String title;

  //to-do
  //get the list from the database
  Gift gift;
  final bool isOwner;
  final bool isPledged;
  final String userID;
  GiftDescriptionPage({required this.title, required this.gift, required this.isOwner, required this.isPledged, required this.userID});

  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        //The app's icon
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back)),

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.purple,
        // Here we take the value from the EventPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(this.title),

      ),
      body:  SingleChildScrollView(
        child: Center(
          child: Column(
          children: [
            CircleAvatar(child: Icon(Icons.image), radius: 40,),
            
            Container(
              margin: EdgeInsets.only(top: 40),
              child: 
              Column(children: [
            Row(children: [
              Text("Description: ",  style: TextStyle(fontFamily: "Merienda", fontSize: 20)),
              Flexible(child: Text(gift.description == null ? "No Description Available" : gift.description!,
              style: TextStyle(color:Colors.red,fontFamily: "Merienda", fontSize: 20)),
              )
              ]
            ),
            Row(children: [
              Text("Category: ",  style: TextStyle(fontFamily: "Merienda", fontSize: 20)),
              Text(gift.category!,
              style: TextStyle(color:Colors.red,fontFamily: "Merienda", fontSize: 20)),
              ]
            ),
            Row(children: [
              Text("Price: ",  style: TextStyle(fontFamily: "Merienda", fontSize: 20)),
              Text(gift.price.toString(),
              style: TextStyle(color:Colors.red,fontFamily: "Merienda", fontSize: 20)),
              ]
            ),
            (isOwner || isPledged)?
            const Text(""):
            ElevatedButton(onPressed: (){
              Gift.pledgeFriendGift(gift.ID, LoggedUser.getLoggedUser().userID);
              Navigator.pop(context);
            },
             child: Text("Pledge"))            
              ]
              )
            )
          ]
      )
    )
      )
    );
  }
}