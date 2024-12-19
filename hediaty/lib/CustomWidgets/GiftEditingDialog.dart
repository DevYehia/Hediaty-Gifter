import 'package:flutter/material.dart';
import 'package:hediaty/Enums/giftCategoryEnum.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/Models/gift.dart';
import 'package:hediaty/darkModeSelection.dart';

class GiftEditingDialog extends StatefulWidget {
  final Gift giftToModify;
  final VoidCallback setStateCallBack;
  final GiftModelView modelView;

  GiftEditingDialog({
    required this.setStateCallBack,
    required this.giftToModify,
    required this.modelView,
  });

  @override
  _GiftEditingDialogState createState() => _GiftEditingDialogState();
}

class _GiftEditingDialogState extends State<GiftEditingDialog> {
  late TextEditingController giftNameController;
  late TextEditingController giftDescriptionController;
  late TextEditingController giftPriceController;

  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  late bool darkMode;
  String? giftCatValue;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode ?? false;
    giftNameController = TextEditingController(text: widget.giftToModify.name);
    giftCatValue = widget.giftToModify.category;
    giftDescriptionController = TextEditingController(text: widget.giftToModify.description ?? "");
    giftPriceController = TextEditingController(text: widget.giftToModify.price.toString());
  }

  @override
  void dispose() {
    giftNameController.dispose();
    giftDescriptionController.dispose();
    giftPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      surfaceTintColor: darkMode ? Colors.white : Colors.black,
      shadowColor: darkMode ? Colors.white : Colors.black,
      title: Text(
        'Edit Gift',
        style: TextStyle(color: darkMode ? Colors.white : Colors.black),
      ),
      content: Form(
        key: globalFormKey,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: giftNameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: darkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the gift\'s name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField(
                dropdownColor: darkMode ? Colors.black : Colors.white,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(
                      color: darkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a category';
                  }
                  return null;
                },
                value: giftCatValue,
                onChanged: (value) {
                  setState(() {
                    giftCatValue = value as String?;
                  });
                },
                items: GiftCategories.values
                    .map((cat) => DropdownMenuItem(
                          value: cat.name,
                          child: Text(
                            cat.name,
                            style: TextStyle(
                                color: darkMode
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ))
                    .toList(),
              ),
              TextFormField(
                controller: giftDescriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                      color: darkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
              ),
              TextFormField(
                controller: giftPriceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  labelStyle: TextStyle(
                      color: darkMode ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the price';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
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
          onPressed: () async {
            if (globalFormKey.currentState!.validate()) {
              Gift newGift = Gift(
                ID: widget.giftToModify.ID,
                name: giftNameController.text,
                category: giftCatValue!,
                price: double.parse(giftPriceController.text),
                isPledged: widget.giftToModify.isPledged,
                eventID: widget.giftToModify.eventID,
                firebaseID: widget.giftToModify.firebaseID,
              );
              await widget.modelView.editGift(newGift);
              widget.setStateCallBack();
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text(
            'Edit',
            style: TextStyle(color: darkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
