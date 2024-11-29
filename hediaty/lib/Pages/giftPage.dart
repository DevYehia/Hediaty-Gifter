import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftCreationDialog.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/Models/gift.dart';


class GiftPage extends StatefulWidget{
  final String title;
  final String eventID;
  GiftPage({required this.title, required this.eventID});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GiftState();
  }
}



class GiftState extends State<GiftPage>{


  List<GiftWidget> giftList = [];

  Future setGiftWidgets() async{
    List<Gift> giftModelList = await Gift.getAllGifts(widget.eventID);
    giftList = giftModelList.map((gift) => GiftWidget(gift: gift),).toList();
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

        actions: [
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
        ],

      ),
      body: FutureBuilder(
            future: setGiftWidgets(),
            builder: (context, snapshot){
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