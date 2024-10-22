import 'package:flutter/material.dart';
import '../CustomWidgets/friend_widget.dart';
import '../Pages/eventsPage.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<FriendWidget> testFriendList = <FriendWidget>[];

  @override
  Widget build(BuildContext context) {

    final TextEditingController newFriendName = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        //The app's icon
        leading: Image.asset("assets/gift_logo.jpg"),

        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: <Widget>[
          SearchBar(leading: Icon(Icons.search)),
          IconButton(
            onPressed: (){//setState(() {
              print("Oi Stop"); 
              showDialog(context: context, builder:  (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Friend'),
                  content: TextField(
                    controller: newFriendName,
                    decoration: InputDecoration(hintText: 'Enter friend\'s name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          String friendName = newFriendName.text;
                          // Handle adding the friend (e.g., API call)
                          testFriendList.add(FriendWidget(friendName: friendName));
                          print('Adding friend: $friendName');
                        });
                        Navigator.of(context).pop(); // Close the dialog           
                      },
                      child: Text('Add'),
                    ),
                  ],
                );
              },);
            },
            tooltip: "Add Friend",
            icon: const Icon(Icons.add)),
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          //mainAxisAlignment: MainAxisAlignment.center,
          children: testFriendList
    )
      ),
    );
  }
}
