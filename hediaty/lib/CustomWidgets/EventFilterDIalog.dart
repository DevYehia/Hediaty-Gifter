import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';





class EventFilterDialog extends StatefulWidget {
  EventCategories? iniSelectedCat;
  EventStatus? iniSelectedStatus;
  EventFilterDialog({super.key, this.iniSelectedCat, this.iniSelectedStatus });

  @override
  State<EventFilterDialog> createState() => _EventFilterDialogState();
}

class _EventFilterDialogState extends State<EventFilterDialog> {

  EventCategories? selectedCat;
  EventStatus? selectedStatus;
  late List<DropdownMenuItem<EventCategories>> catMenuList;
  late List<DropdownMenuItem<EventStatus>> statusMenuList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedCat = widget.iniSelectedCat;
    selectedStatus = widget.iniSelectedStatus;
    catMenuList = EventCategories.values.map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text("${cat.name}")
                  )).toList();
    catMenuList.add(
      DropdownMenuItem(
        child: Text("None"),
        value: null
        )
      );
    statusMenuList = EventStatus.values.map(
                  (status) => DropdownMenuItem(
                    value: status,
                    child: Text("${status.name}")
                  )).toList();
    statusMenuList.add(
      DropdownMenuItem(
        child: Text("None"),
        value: null
        )
      );
    
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filters'),
      content: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Category: "),
              DropdownButton(
                hint: Text("Category"), 
                value: selectedCat,
                items: catMenuList,
               onChanged: (cat){
                selectedCat = cat;
                setState(() {
                  
                });
               })
            ],),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Status: "),
              DropdownButton(
                hint: Text("Status"), 
                value: selectedStatus,
                items: statusMenuList,
               onChanged: (status){
                selectedStatus = status;
                setState(() {
                  
                });
               })
            ],)
          ],
        )
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
                        
                        Navigator.pop(context,[selectedCat, selectedStatus]); // Close the dialog                        
                      },
                      child: Text('Filter'),
                    ),
                  ],
      );
  }
}