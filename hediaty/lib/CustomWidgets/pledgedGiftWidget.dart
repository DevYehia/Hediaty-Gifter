import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/darkModeSelection.dart';
import 'package:intl/intl.dart';

class PledgedGiftWidget extends StatefulWidget {
  final Gift gift;
  DateTime date;
  DateFormat dateFormatter = DateFormat("d/M/y");

  PledgedGiftWidget({
    Key? key,
    required this.gift,
    required this.date,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PledgedGiftWidgetState();
  }
}

class PledgedGiftWidgetState extends State<PledgedGiftWidget> {


  bool? darkMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    darkMode = DarkModeSelection.getDarkMode();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      color: darkMode == false ? Colors.white : Colors.black,
      shadowColor: darkMode == false ? Colors.black : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  // Placeholder for an image
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Gift name and date
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.gift.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkMode == false ?  Colors.black87 : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Event Date: ${widget.dateFormatter.format(widget.date!)}",
                        style: TextStyle(
                          fontSize: 14,
                          color: darkMode == false ?  Colors.black87 : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Unpledge button
            (widget.date.isAfter(DateTime.now()))
                ? IconButton(
                    onPressed: () async {
                      await Gift.unpledgeGift(widget.gift.firebaseID!);
                      //widget.refreshCallback();
                    },
                    icon: const Icon(Icons.clear),
                    color: Colors.red,
                    tooltip: "Unpledge",
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
