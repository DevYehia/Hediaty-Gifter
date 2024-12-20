import 'package:flutter/material.dart';
import 'package:hediaty/ModelView/PledgedGiftModelView.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/darkModeSelection.dart';
import "../CustomWidgets/pledgedGiftWidget.dart";

class PledgedGiftsPage extends StatefulWidget {

  final String userID;
  const PledgedGiftsPage({super.key, required this.userID});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {


  late PledgedGiftModelView modelView;
  bool? darkMode;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    modelView = PledgedGiftModelView(userID: widget.userID, refreshCallback: (){setState(() {
      
    });});
    darkMode = DarkModeSelection.getDarkMode();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode == false ? Colors.white : Colors.black,
      appBar: AppBar(
        title: Text("Your Pledged Gifts"),
        backgroundColor: Colors.purple,


      ),
      body: FutureBuilder(
        future: modelView.getPledgedGifts(), 
        builder: (context, snapshot){

              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator()); 
              }
              if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                    return Text("error: ${snapshot.error}");
                }
                return  SingleChildScrollView(
                          child: Center( child: Column(
                            children: snapshot.data!
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