import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftCreationDialog.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/gift.dart';


class GiftPage extends StatefulWidget{
  final String title;
  final String eventID;
  final bool isOwner;
  final String userID;
  GiftPage({required this.title, required this.eventID, required this.isOwner, required this.userID});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GiftState();
  }
}



class GiftState extends State<GiftPage>{


  List<GiftWidget> giftList = [];

  Future setGiftWidgets() async{

    late List<Gift> giftModelList;
    if(widget.isOwner){
      giftModelList = await Gift.getAllGifts(widget.eventID);
    }
    else{
      giftModelList = await Gift.getAllGiftsFirebase(widget.eventID);
    }
    giftList = giftModelList.map((gift) => GiftWidget(gift: gift, isOwner: widget.isOwner,userID: widget.userID,),).toList();
    print("Gift Widgets are $giftList");
  }
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
        title: Text(widget.title),

        //if gift's owner show actions otherwise no
        actions: widget.isOwner ? 
          [
          IconButton(
           onPressed: (){print("Barcode yet to be implemented");},
           icon: Icon(Icons.barcode_reader)
           ),

           IconButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return GiftCreationDialog(eventID: widget.eventID, setStateCallBack: (){setState(() {
                
              });},);
            }
            );

           },
           icon: Icon(Icons.add)
           )
        ]: 
        [],

      ),
      body: FutureBuilder(
            future: setGiftWidgets(),
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
                            children: giftList
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