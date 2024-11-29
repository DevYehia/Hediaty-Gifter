import 'package:flutter/material.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/gift.dart';

class GiftCreationDialog extends StatelessWidget{

  final giftNameController = TextEditingController();
  final giftCategoryController = TextEditingController();
  final giftDescriptionController = TextEditingController();
  final giftPriceController = TextEditingController();
  final String eventID;
  final VoidCallback setStateCallBack;
  GiftCreationDialog({super.key, required this.eventID, required this.setStateCallBack});

  @override
  Widget build(BuildContext context) {


   var globalFormKey = GlobalKey<FormState>();
   return AlertDialog(
      title: Text('Add Gift'),
      content: Form(
        key: globalFormKey,
        child: Column(
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the price';
                        }
                        return null;
                      },
                    ),                    
   
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
                      onPressed: () async{
                        if(globalFormKey.currentState!.validate()){

                          //insert gift into firebase
                          //get gift ID
                          //insert gift locally with ID
                          String giftID = await Gift.insertGiftFireBase(
                            giftNameController.text,
                            giftCategoryController.text,
                            giftDescriptionController.text,
                            double.parse(giftPriceController.text),
                            this.eventID
                          );
                          
                          await Gift.insertGiftLocal(
                            giftID,
                            giftNameController.text,
                            giftCategoryController.text,
                            giftDescriptionController.text,
                            double.parse(giftPriceController.text),
                            this.eventID
                          );                          
                          setStateCallBack();
                        }
                        Navigator.of(context).pop(); // Close the dialog                        
                      },
                      child: Text('Add'),
                    ),
                  ],
      );
      
   
  }




}