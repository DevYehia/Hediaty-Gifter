import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';

class EventCreationDialog extends StatelessWidget{

  final eventNameController = TextEditingController();
  final eventCategoryController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventLocationController = TextEditingController();
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
                    TextFormField(
                      controller: eventDateController,
                      decoration: InputDecoration(
                        labelText: "Date",
                        ), 
                      onTap: () async{
                        DateTime? date = DateTime(1900);
                        FocusScope.of(context).requestFocus(new FocusNode());
                        date = await showDatePicker(
                                  context: context, 
                                  initialDate:DateTime.now(),
                                  firstDate:DateTime(1900),
                                  lastDate: DateTime(2100));

                        eventDateController.text = "${date?.day}/${date?.month}/${date?.year}";
                        },),
                    TextFormField(
                      controller: eventLocationController,
                      decoration: InputDecoration(
                      labelText: "Location",
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
                            'date' : eventDateController.text, //To Do --> Add proper date
                            'category' : eventCategoryController.text,
                            'location' : eventLocationController.text,
                            'description': eventDescriptionController.text,
                            'userID' : UserModel.getLoggedUserID()
                          };
                          print("Data Map is $eventData");
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