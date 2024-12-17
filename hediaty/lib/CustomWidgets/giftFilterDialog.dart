import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/Enums/eventStatusEnum.dart';
import 'package:hediaty/Enums/giftCategoryEnum.dart';
import 'package:hediaty/Enums/giftStatusEnum.dart';
import 'package:hediaty/Enums/privacyEnum.dart';
import 'package:hediaty/Util/Gifts/GiftCategoryFilter.dart';
import 'package:hediaty/Util/Gifts/GiftFilter.dart';
import 'package:hediaty/Util/Gifts/GiftPrivacyFilter.dart';
import 'package:hediaty/Util/Gifts/GiftStatusFilter.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catMenuList = GiftCategories.values
        .map((cat) => DropdownMenuItem(value: cat, child: Text("${cat.name}")))
        .toList();
    catMenuList.add(DropdownMenuItem(child: Text("None"), value: null));
    statusMenuList = GiftStatus.values
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
              filters.add(GiftCategoryFilter(selectedCat!));
            }
            if(selectedStatus != null){
              filters.add(GiftStatusFilter(selectedStatus!));
            }
            if(selectedPrivacy != null){
              filters.add(GiftPrivacyFilter(selectedPrivacy!));
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
