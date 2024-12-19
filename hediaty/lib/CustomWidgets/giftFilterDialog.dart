import 'package:flutter/material.dart';
import 'package:hediaty/Enums/giftCategoryEnum.dart';
import 'package:hediaty/Enums/giftStatusEnum.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Gifts/GiftCategoryFilter.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';
import 'package:hediaty/Util/Gifts/GiftPrivacyFilter.dart';
import 'package:hediaty/Util/Gifts/GiftStatusFilter.dart';
import 'package:hediaty/darkModeSelection.dart';

class GiftFilterDialog extends StatefulWidget {
  GiftFilterDialog({super.key});

  @override
  State<GiftFilterDialog> createState() => _GiftFilterDialogState();
}

class _GiftFilterDialogState extends State<GiftFilterDialog> {
  static GiftCategories? selectedCat;
  static GiftStatus? selectedStatus;
  static PrivacyStates? selectedPrivacy;
  List<GiftFilter> filters = [];
  late List<DropdownMenuItem<GiftCategories>> catMenuList;
  late List<DropdownMenuItem<GiftStatus>> statusMenuList;
  late List<DropdownMenuItem<PrivacyStates>> privacyMenuList;
  late bool darkMode;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode ?? false;
    catMenuList = GiftCategories.values
        .map((cat) => DropdownMenuItem(
              value: cat,
              child: Text(
                "${cat.name}",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
            ))
        .toList();
    catMenuList.add(DropdownMenuItem(
      child: Text(
        "None",
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
      ),
      value: null,
    ));
    statusMenuList = GiftStatus.values
        .map((status) => DropdownMenuItem(
              value: status,
              child: Text(
                "${status.name}",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
            ))
        .toList();
    statusMenuList.add(DropdownMenuItem(
      child: Text(
        "None",
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
      ),
      value: null,
    ));
    privacyMenuList = PrivacyStates.values
        .map((status) => DropdownMenuItem(
              value: status,
              child: Text(
                "${status.name}",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
            ))
        .toList();
    privacyMenuList.add(DropdownMenuItem(
      child: Text(
        "None",
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
      ),
      value: null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      surfaceTintColor: darkMode ? Colors.white : Colors.black,
      shadowColor: darkMode ? Colors.white : Colors.black,
      title: Text(
        'Filters',
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
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
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
              DropdownButton(
                dropdownColor: darkMode ? Colors.black : Colors.white,
                hint: Text(
                  "Category",
                  style:
                      TextStyle(color: darkMode ? Colors.white : Colors.black),
                ),
                value: selectedCat,
                items: catMenuList,
                onChanged: (cat) {
                  setState(() {
                    selectedCat = cat;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Status: ",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
              DropdownButton(
                dropdownColor: darkMode ? Colors.black : Colors.white,
                hint: Text(
                  "Status",
                  style:
                      TextStyle(color: darkMode ? Colors.white : Colors.black),
                ),
                value: selectedStatus,
                items: statusMenuList,
                onChanged: (status) {
                  setState(() {
                    selectedStatus = status;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Privacy: ",
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
              DropdownButton(
                dropdownColor: darkMode ? Colors.black : Colors.white,
                hint: Text(
                  "Privacy",
                  style:
                      TextStyle(color: darkMode ? Colors.white : Colors.black),
                ),
                value: selectedPrivacy,
                items: privacyMenuList,
                onChanged: (privacy) {
                  setState(() {
                    selectedPrivacy = privacy;
                  });
                },
              ),
            ],
          ),
        ],
      )),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: darkMode ? Colors.white : Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            if (selectedCat != null) {
              filters.add(GiftCategoryFilter(selectedCat!));
            }
            if (selectedStatus != null) {
              filters.add(GiftStatusFilter(selectedStatus!));
            }
            if (selectedPrivacy != null) {
              filters.add(GiftPrivacyFilter(selectedPrivacy!));
            }
            Navigator.pop(context, filters); // Close the dialog
          },
          child: Text(
            'Filter',
            style: TextStyle(color: darkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
