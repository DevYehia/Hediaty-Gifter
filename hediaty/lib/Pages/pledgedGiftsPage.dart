import 'package:flutter/material.dart';
import "../CustomWidgets/pledgedGiftWidget.dart";

class PledgedGiftsPage extends StatefulWidget {

  final String userID;
  const PledgedGiftsPage({super.key, required this.userID});

  @override
  State<PledgedGiftsPage> createState() => _PledgedGiftsPageState();
}

class _PledgedGiftsPageState extends State<PledgedGiftsPage> {


  List<PledgedGiftWidget> pledgedGiftList = [PledgedGiftWidget(giftName: "Test", date: "haha")];
  Future<void> getPledgedGifts() async{
    //this function should get all pledged gifts
    //and fill the pledged gifts list with the widgets
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
                            children: pledgedGiftList
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