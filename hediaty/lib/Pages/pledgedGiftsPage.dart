import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import "../CustomWidgets/pledgedGiftWidget.dart";

class PledgedGiftsPage extends StatefulWidget {

  final String userID;
  const PledgedGiftsPage({super.key, required this.userID});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {


  List<PledgedGiftWidget> pledgedGiftWidgetList = [];
  Future<void> getPledgedGifts() async{
    List pledgedGiftList = await Gift.getPledgedGiftsByUserID(widget.userID);
    pledgedGiftWidgetList = pledgedGiftList.map((gift) => PledgedGiftWidget(gift: gift, refreshCallback: () {
      setState(() {
        
      });
    },),).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Pledged Gifts"),
        backgroundColor: Colors.purple,

      ),
      body: FutureBuilder(
        future: getPledgedGifts(), 
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
                            children: pledgedGiftWidgetList
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