import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {

  PageController pageSelectController;
  Function (int) pageChangeCallback;
  CustomBottomNavBar({super.key, required this.pageSelectController, required this.pageChangeCallback});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  int navCurrIndex = 0;


  @override
  void initState() {
    super.initState();
    
    widget.pageSelectController.addListener(() { 
            // setState method to  
            // rebuild the widget 
          setState(() {  
            navCurrIndex = widget.pageSelectController.page!.toInt();   
          }); 
      });
  }
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        onDestinationSelected: (int index) {
          print("Index is $index");
          navCurrIndex = index;
          widget.pageChangeCallback(index);
          setState(() {
            
          });

        },
        indicatorColor: Colors.amber,
        selectedIndex: navCurrIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'My Friends',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_sharp),
            label: 'My Events',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'My Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard),
            label: 'Pledged Gifts',
          ),
        ],
      );
  }
}