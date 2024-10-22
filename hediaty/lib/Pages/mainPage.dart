import 'package:flutter/material.dart';
import '../CustomWidgets/friend_widget.dart';
import 'eventsPage.dart';
import 'homePage.dart';


class MyMainPage extends StatefulWidget {
  const MyMainPage({super.key, required this.title});

  // This widget is the Main page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyMainPage> createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {

  int navCurrIndex = 0;
  late StatefulWidget selectedPage = MyHomePage(title: "Gifter");
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:  selectedPage,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            navCurrIndex = index;
            if(index == 0){
              selectedPage = MyHomePage(title: "Gifter");
            }
            if(index == 1){
              selectedPage = EventPage(title: "Gifter");
            }
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: navCurrIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Friends',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'My Events',
          ),
        ],
      ),
    );
  }
}
