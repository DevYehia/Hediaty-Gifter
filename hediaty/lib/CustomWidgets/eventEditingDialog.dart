import 'package:flutter/material.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:intl/intl.dart';

class EventEditingDialog extends StatelessWidget{

  final eventNameController = TextEditingController();
  final eventCategoryController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventLocationController = TextEditingController();


  final Event eventToModify;
  final VoidCallback setStateCallBack;

  EventEditingDialog({required this.setStateCallBack,required this.eventToModify});
  @override
  Widget build(BuildContext context) {

    DateFormat dateFormatter = DateFormat("d/M/y");

    var globalFormKey = GlobalKey<FormState>();
   return AlertDialog(
      title: Text('Edit Event'),
      content: Form(
        key: globalFormKey,
        child: Column(
                  children: [
                    TextFormField(
                      initialValue: eventToModify.eventName,
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
                      initialValue: eventToModify.category,
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
                      initialValue: eventToModify.description,
                      controller: eventDescriptionController,
                      decoration: InputDecoration(
                      labelText: "Description",
                      ),
                    ),
                    TextFormField(
                      initialValue: dateFormatter.format(eventToModify.eventDate),
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
                      initialValue: eventToModify.location,
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
                          
                          Event.updateEventLocal(
                            eventToModify.eventID, 
                            eventNameController.text,
                            eventDateController.text,
                            eventCategoryController.text,
                            eventLocationController.text,
                            eventDescriptionController.text
                          );

                          Event.updateEventFirebase(
                            eventToModify.eventID, 
                            eventNameController.text,
                            eventDateController.text,
                            eventCategoryController.text,
                            eventLocationController.text,
                            eventDescriptionController.text
                          );

                          setStateCallBack();
                        }
                        Navigator.of(context).pop(); // Close the dialog                        
                      },
                      child: Text('Edit'),
                    ),
                  ],
      );
      
   
  }




}