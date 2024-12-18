import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Events/EventCategoryFilter.dart';
import 'package:hediaty/Util/Events/EventDateFilter.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';
import 'package:hediaty/Util/Events/EventPrivacyFilter.dart';

class EventFilterDialog extends StatefulWidget {
  EventFilterDialog({super.key});

  @override
  State<EventFilterDialog> createState() => _EventFilterDialogState();
}

class _EventFilterDialogState extends State<EventFilterDialog> {

  static EventCategories? selectedCat;
  static EventStatus? selectedStatus;
  static PrivacyStates? selectedPrivacy;
  List<EventFilter> filters = [];
  late List<DropdownMenuItem<EventCategories>> catMenuList;
  late List<DropdownMenuItem<EventStatus>> statusMenuList;
  late List<DropdownMenuItem<PrivacyStates>> privacyMenuList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catMenuList = EventCategories.values
        .map((cat) => DropdownMenuItem(value: cat, child: Text("${cat.name}")))
        .toList();
    catMenuList.add(DropdownMenuItem(child: Text("None"), value: null));
    statusMenuList = EventStatus.values
        .map((status) =>
            DropdownMenuItem(value: status, child: Text("${status.name}")))
        .toList();
    statusMenuList.add(DropdownMenuItem(child: Text("None"), value: null));
    privacyMenuList = PrivacyStates.values
        .map((status) =>
            DropdownMenuItem(value: status, child: Text("${status.name}")))
        .toList();
    privacyMenuList.add(DropdownMenuItem(child: Text("None"), value: null));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filters'),
      content: SizedBox(
          child: Column(
        mainAxisSize: MainAxisSize.min,
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
                  onChanged: (cat) {
                    selectedCat = cat;
                    setState(() {});
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Status: "),
              DropdownButton(
                  hint: Text("Status"),
                  value: selectedStatus,
                  items: statusMenuList,
                  onChanged: (status) {
                    selectedStatus = status;
                    setState(() {});
                  })
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Privacy: "),
              DropdownButton(
                  hint: Text("Status"),
                  value: selectedPrivacy,
                  items: privacyMenuList,
                  onChanged: (status) {
                    selectedPrivacy = status;
                    setState(() {});
                  })
            ],
          )
        ],
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if(selectedCat != null){
              filters.add(EventCategoryFilter(selectedCat!));
            }
            if(selectedStatus != null){
              filters.add(EventDateFilter(selectedStatus!));
            }
            if(selectedPrivacy != null){
              filters.add(EventPrivacyFilter(selectedPrivacy!));
            }
            Navigator.pop(
                context, filters); // Close the dialog
          },
          child: Text('Filter'),
        ),
      ],
    );
  }
}
