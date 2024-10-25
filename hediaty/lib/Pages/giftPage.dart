import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/gift.dart';

class GiftPage extends StatelessWidget{
  final String title;

  //to-do
  //get the list from the database
  List<Gift> eventsGiftList = <Gift>[];
  GiftPage({required this.title, required this.eventsGiftList});

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
        child: Column(children:
          eventsGiftList.map((gift) => GiftWidget(gift: gift),).toList()
        )
      )
    );
  }
}