import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/ModelView/EventModelView.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';
import 'package:intl/intl.dart';
import 'package:hediaty/darkModeSelection.dart';

class EventEditingDialog extends StatefulWidget {
  final Event eventToModify;
  final VoidCallback setStateCallBack;
  final EventModelView modelView;

  EventEditingDialog({
    required this.setStateCallBack,
    required this.eventToModify,
    required this.modelView,
  });

  @override
  _EventEditingDialogState createState() => _EventEditingDialogState();
}

class _EventEditingDialogState extends State<EventEditingDialog> {
  final eventNameController = TextEditingController();
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventLocationController = TextEditingController();
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool? darkMode;
  DateFormat dateFormatter = DateFormat("d/M/y");
  String? eventCatValue;

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode;
    eventNameController.text = widget.eventToModify.eventName;
    eventCatValue = widget.eventToModify.category;
    eventDescriptionController.text = widget.eventToModify.description ?? "";
    eventDateController.text = dateFormatter.format(widget.eventToModify.eventDate);
    eventLocationController.text = widget.eventToModify.location;
  }

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventDateController.dispose();
    eventLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: darkMode == true ? Colors.white : Colors.black,
      shadowColor: darkMode == true ? Colors.white : Colors.black,
      backgroundColor: darkMode == true ? Colors.black : Colors.white,
      title: Text(
        'Edit Event',
        style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
      ),
      content: Form(
        key: globalFormKey,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: eventNameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event\'s name';
                  }
                  return null;
                },
              ),
      DropdownButtonFormField(
                dropdownColor: darkMode == true ? Colors.black : Colors.white,
                value: eventCatValue,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter your category';
                  }
                  return null;
                },
                onChanged: (value) {
                  eventCatValue = value as String?;
                  setState(() {
                    
                  });
                },
                items: EventCategories.values.map((cat) => DropdownMenuItem(
                  value: cat.name,
                  child: 
                Text(cat.name, style: TextStyle(
                  color: darkMode == true? Colors.white : Colors.black
                ),)),).toList()
              ),
              TextFormField(
                controller: eventDescriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
              ),
              TextFormField(
                controller: eventDateController,
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    setState(() {
                      eventDateController.text =
                          "${date.day}/${date.month}/${date.year}";
                    });
                  }
                },
              ),
              TextFormField(
                controller: eventLocationController,
                decoration: InputDecoration(
                  labelText: "Location",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
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
            style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (globalFormKey.currentState!.validate()) {
              await widget.modelView.editEvent(
                eventNameController.text,
                eventDateController.text,
                eventCatValue!,
                eventDescriptionController.text,
                eventLocationController.text,
                widget.eventToModify,
              );
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text(
            'Edit',
            style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}