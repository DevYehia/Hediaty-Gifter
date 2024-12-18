import 'package:flutter/material.dart';
import 'package:hediaty/ModelView/GiftModelView.dart';
import 'package:hediaty/Models/gift.dart';

class GiftEditingDialog extends StatelessWidget {

  final giftNameController = TextEditingController();
  final giftCategoryController = TextEditingController();
  final giftDescriptionController = TextEditingController();
  final giftPriceController = TextEditingController();


  final Gift giftToModify;
  final VoidCallback setStateCallBack;
  final GiftModelView modelView;

  GiftEditingDialog(
      {required this.setStateCallBack, required this.giftToModify, required this.modelView}) {
    giftNameController.text = giftToModify.name;
    giftCategoryController.text = giftToModify.category;
    giftDescriptionController.text = giftToModify.description ?? "";
    giftPriceController.text = giftToModify.price.toString();
  }
  @override
  Widget build(BuildContext context) {
    var globalFormKey = GlobalKey<FormState>();
    return AlertDialog(
      title: Text('Edit Gift'),
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
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the gift\'s name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: giftCategoryController,
              decoration: InputDecoration(
                labelText: "Category",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your category';
                }
                return null;
              },
            ),
            TextFormField(
              controller: giftDescriptionController,
              decoration: InputDecoration(
                labelText: "Description",
              ),
            ),
            TextFormField(
              controller: giftPriceController,
              decoration: InputDecoration(
                labelText: "Price",
              ),
            ),
          ],
        )),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (globalFormKey.currentState!.validate()) {

              Gift newGift = Gift(ID: giftToModify.ID,
               name: giftNameController.text, category: giftCategoryController.text,
                price: double.parse(giftPriceController.text),
                 isPledged: giftToModify.isPledged, 
                 eventID: giftToModify.eventID,
                 firebaseID: giftToModify.firebaseID);
              await modelView.editGift(newGift);
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text('Edit'),
        ),
      ],
    );
  }

}