import 'package:flutter/material.dart';
import 'package:hediaty/Enums/giftCategoryEnum.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/darkModeSelection.dart';

class GiftCreationDialog extends StatefulWidget {
  final GiftModelView modelView;
  final VoidCallback setStateCallBack;

  GiftCreationDialog({
    super.key,
    required this.modelView,
    required this.setStateCallBack,
  });

  @override
  State<GiftCreationDialog> createState() => _GiftCreationDialogState();
}

class _GiftCreationDialogState extends State<GiftCreationDialog> {
  final giftNameController = TextEditingController();
  final giftCategoryController = TextEditingController();
  final giftDescriptionController = TextEditingController();
  final giftPriceController = TextEditingController();

  late bool darkMode;
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? giftCatValue;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode ?? false;
  }

  @override
  void dispose() {
    giftNameController.dispose();
    giftCategoryController.dispose();
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
        'Add Gift',
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
                onChanged: (value) {
                  giftCatValue = value;
                  setState(() {
                    
                  });
                },
                items: GiftCategories.values.map((cat) => DropdownMenuItem(
                  value: cat.name,
                  child: 
                Text(cat.name, style: TextStyle(
                  color: darkMode == true? Colors.white : Colors.black
                ),)),).toList()
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
              widget.modelView.addGift(
                giftNameController.text,
                giftCatValue!,
                giftDescriptionController.text,
                double.parse(giftPriceController.text),
              );
              widget.setStateCallBack();
            }
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(
            'Add',
            style: TextStyle(color: darkMode ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
