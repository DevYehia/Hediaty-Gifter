import 'package:flutter/material.dart';
import 'package:hediaty/Models/LoggedUser.dart';
import 'package:hediaty/Models/event.dart';

class EventCreationDialog extends StatelessWidget{

  final eventNameController = TextEditingController();
  final eventCategoryController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final VoidCallback setStateCallBack;

  EventCreationDialog({required this.setStateCallBack});
  @override
  Widget build(BuildContext context) {


    var globalFormKey = GlobalKey<FormState>();
   return AlertDialog(
      title: Text('Add Event'),
      content: Form(
        key: globalFormKey,
        child: Column(
                  children: [
                    TextFormField(
                      controller: eventNameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the event\'s name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: eventCategoryController,
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
                      controller: eventDescriptionController,
                      decoration: InputDecoration(
                      labelText: "Description",
                      ),
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
                          Map<String, Object?> eventData = {
                            'name' : eventNameController.text,
                            'date' : "2011-11-22", //To Do --> Add proper date
                            'category' : eventCategoryController.text,
                            'location' : 'ElMarg',
                            'description': eventDescriptionController.text,
                            'userID' : LoggedUser.getLoggedUser().userID
                          };
                          //insert to firebase
                          //get event ID
                          //insert to local DB
                          String eventID = await Event.insertEventFireBase(eventData);
                          eventData["ID"] = eventID;
                          await Event.insertEventLocal(eventData);
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