import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {

  PageController pageSelectController;
  ValueNotifier<int> indexNotifer;
  CustomBottomNavBar({super.key, required this.pageSelectController, required this.indexNotifer});


  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {

  int navCurrIndex = 0;


  @override
  void initState() {
    super.initState();
    
  }

  void updateNavBar(int index){
    navCurrIndex = index;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    
    ValueListenableBuilder(
        valueListenable: widget.indexNotifer,
        builder: (BuildContext context, int val, Widget? child) {

            return NavigationBar(
                onDestinationSelected: (int index) {
                navCurrIndex = index;
                widget.pageSelectController.jumpToPage(index);
                setState(() {
                    
                });
                },
                indicatorColor: Colors.amber,
                selectedIndex: val,
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
    );
  }
}