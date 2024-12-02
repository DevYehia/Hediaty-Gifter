import 'package:flutter/material.dart';

class PledgedGiftWidget extends StatelessWidget {
  final String giftName;
  final String date;

  const PledgedGiftWidget({
    Key? key,
    required this.giftName,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Row(
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
                      giftName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Event Date: $date",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Unpledge button
            IconButton(
              onPressed: () {
                print("Unpledge");
              },
              icon: const Icon(Icons.clear),
              color: Colors.red,
              tooltip: "Unpledge",
            ),
          ],
        ),
      ),
    );
  }
}
