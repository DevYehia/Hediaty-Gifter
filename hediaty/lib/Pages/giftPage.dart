import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/giftCreationDialog.dart';
import 'package:hediaty/CustomWidgets/giftFilterDialog.dart';
import 'package:hediaty/CustomWidgets/giftWidget.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';
import 'package:hediaty/Util/Gifts/GiftNameSort.dart';
import 'package:hediaty/Util/Gifts/GiftPriceSort.dart';
import 'package:hediaty/Util/Gifts/GiftSortStrategy.dart';
import 'package:hediaty/darkModeSelection.dart';

class GiftPage extends StatefulWidget {
  final String title;
  final Event event;
  final bool isOwner;
  final String userID;
  GiftPage(
      {required this.title,
      required this.event,
      required this.isOwner,
      required this.userID});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GiftState();
  }
}

class GiftState extends State<GiftPage> {
  late GiftModelView modelView;
  GiftSortStrategy? selectedSort;
  bool? darkMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    darkMode = DarkModeSelection.getDarkMode();
    modelView = GiftModelView(
        isOwner: widget.isOwner,
        userID: widget.userID,
        event: widget.event,
        refreshCallback: () {
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode == false ? Colors.white : Colors.black,
        appBar: AppBar(
            //The app's icon
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),

            // TRY THIS: Try changing the color here to a specific color (to
            // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
            // change color while the other colors stay the same.
            backgroundColor: Colors.purple,
            // Here we take the value from the EventPage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),

            //if gift's owner show actions otherwise no
            actions: [
              IconButton(
                  onPressed: () async {
                    List<GiftFilter> selectedFilters = [];
                    selectedFilters = (await showDialog(
                          context: context,
                          builder: (context) => GiftFilterDialog(),
                        )) ??
                        selectedFilters;
                    modelView.setFilters(selectedFilters);
                    setState(() {});
                  },
                  icon: Icon(Icons.filter_alt)),
              PopupMenuButton<GiftSortStrategy>(
                initialValue: selectedSort,
                icon: const Icon(
                  Icons.menu,
                ), //use this icon
                onSelected: (GiftSortStrategy item) {
                  setState(() {
                    selectedSort = item;
                    modelView.setSort(item);
                  });
                },
                itemBuilder: (BuildContext context) =>
                    <PopupMenuEntry<GiftSortStrategy>>[
                  PopupMenuItem<GiftSortStrategy>(
                    value: GiftPriceSort(),
                    child: Text('Price Sort'),
                  ),
                  PopupMenuItem<GiftSortStrategy>(
                    value: GiftNameSort(),
                    child: Text('Name Sort'),
                  ),
                ],
              ),
              widget.isOwner
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GiftCreationDialog(
                                modelView: modelView,
                                setStateCallBack: () {
                                  setState(() {});
                                },
                              );
                            });
                      },
                      icon: Icon(Icons.add))
                  : SizedBox.shrink()
            ]),
        body: FutureBuilder(
            future: modelView.getGiftWidgets(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text("error: ${snapshot.error}");
                }
                return Column(children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15.0), // Rounded corners
                    ),
                    elevation: 10, // Shadow for depth
                    color: darkMode == false ? Colors.white : Colors.black, // Card background color
                    shadowColor: darkMode == false ? Colors.black : Colors.white, // Shadow color
                    margin: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // External margin
                    child: Padding(
                      padding: EdgeInsets.all(20), // Internal padding
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to start
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Category: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.deepPurple, // Label text color
                                  ),
                                ),
                                TextSpan(
                                  text: widget.event.category,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.teal, // Value text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10), // Space between text widgets
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Location: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.deepPurple, // Label text color
                                  ),
                                ),
                                TextSpan(
                                  text: widget.event.location,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.teal, // Value text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Description: ",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Colors.deepPurple, // Label text color
                                  ),
                                ),
                                TextSpan(
                                  text: widget.event.description,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.teal, // Value text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                      child: Center(child: Column(children: snapshot.data!)))
                ]);
              }
              return Text("Hello");
            }));
  }
}
