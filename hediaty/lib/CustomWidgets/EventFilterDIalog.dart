import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Events/EventCategoryFilter.dart';
import 'package:hediaty/Util/Events/EventDateFilter.dart';
import 'package:hediaty/Util/Events/EventFilter.dart';
import 'package:hediaty/Util/Events/EventPrivacyFilter.dart';
import 'package:hediaty/darkModeSelection.dart';

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
  bool? darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode;
    catMenuList = EventCategories.values
        .map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(
              "${cat.name}",
              style: TextStyle(
                  color: darkMode == true ? Colors.white : Colors.black),
            )))
        .toList();
    catMenuList.add(DropdownMenuItem(
        child: Text(
          "None",
          style:
              TextStyle(color: darkMode == true ? Colors.white : Colors.black),
        ),
        value: null));
    statusMenuList = EventStatus.values
        .map((status) => DropdownMenuItem(
            value: status,
            child: Text(
              "${status.name}",
              style: TextStyle(
                  color: darkMode == true ? Colors.white : Colors.black),
            )))
        .toList();
    statusMenuList.add(DropdownMenuItem(
        child: Text(
          "None",
          style:
              TextStyle(color: darkMode == true ? Colors.white : Colors.black),
        ),
        value: null));
    privacyMenuList = PrivacyStates.values
        .map((status) => DropdownMenuItem(
            value: status,
            child: Text(
              "${status.name}",
              style: TextStyle(
                  color: darkMode == true ? Colors.white : Colors.black),
            )))
        .toList();
    privacyMenuList.add(DropdownMenuItem(
        child: Text(
          "None",
          style:
              TextStyle(color: darkMode == true ? Colors.white : Colors.black),
        ),
        value: null));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkMode == true ? Colors.black : Colors.white,
      surfaceTintColor: darkMode == true ? Colors.white : Colors.black,
      shadowColor: darkMode == true ? Colors.white : Colors.black,
      title: Text(
        'Filters',
        style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
      ),
      content: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Category: ",
                  style: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                DropdownButton(
                  dropdownColor: darkMode == true ? Colors.black : Colors.white,
                  hint: Text(
                    "Category",
                    style: TextStyle(
                        color: darkMode == true ? Colors.white : Colors.black),
                  ),
                  value: selectedCat,
                  items: catMenuList,
                  onChanged: (cat) {
                    selectedCat = cat;
                    setState(() {});
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Status: ",
                  style: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                DropdownButton(
                  dropdownColor: darkMode == true ? Colors.black : Colors.white,
                  hint: Text(
                    "Status",
                    style: TextStyle(
                        color: darkMode == true ? Colors.white : Colors.black),
                  ),
                  value: selectedStatus,
                  items: statusMenuList,
                  onChanged: (status) {
                    selectedStatus = status;
                    setState(() {});
                  },
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Privacy: ",
                  style: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                DropdownButton(
                  dropdownColor: darkMode == true ? Colors.black : Colors.white,
                  hint: Text(
                    "Status",
                    style: TextStyle(
                        color: darkMode == true ? Colors.white : Colors.black),
                  ),
                  value: selectedPrivacy,
                  items: privacyMenuList,
                  onChanged: (status) {
                    selectedPrivacy = status;
                    setState(() {});
                  },
                )
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(
                color: darkMode == true ? Colors.white : Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            if (selectedCat != null) {
              filters.add(EventCategoryFilter(selectedCat!));
            }
            if (selectedStatus != null) {
              filters.add(EventDateFilter(selectedStatus!));
            }
            if (selectedPrivacy != null) {
              filters.add(EventPrivacyFilter(selectedPrivacy!));
            }
            Navigator.pop(context, filters); // Close the dialog
          },
          child: Text(
            'Filter',
            style: TextStyle(
                color: darkMode == true ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
