import 'package:flutter/material.dart';
import 'package:hediaty/Enums/eventCategoryEnum.dart';
import 'package:hediaty/ModelView/EventModelView.dart';
import 'package:hediaty/darkModeSelection.dart';

class EventCreationDialog extends StatefulWidget {
  final EventModelView modelView;

  EventCreationDialog({required this.modelView});

  @override
  State<EventCreationDialog> createState() => _EventCreationDialogState();
}

class _EventCreationDialogState extends State<EventCreationDialog> {
  final eventNameController = TextEditingController();
  EventCategories? eventCatValue;
  final eventDescriptionController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventLocationController = TextEditingController();
  final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool? darkMode;

  @override
  void dispose() {
    eventNameController.dispose();
    eventDescriptionController.dispose();
    eventDateController.dispose();
    eventLocationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    darkMode = DarkModeSelection.darkMode;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: darkMode == true ? Colors.white : Colors.black,
      shadowColor: darkMode == true ? Colors.white : Colors.black,
      backgroundColor: darkMode == true ? Colors.black : Colors.white,
      title: Text(
        'Add Event',
        style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
      ),
      content: Form(
        key: globalFormKey,
        child: SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: Key('eventNameField'),
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
                key: Key("eventCategoryField"),
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
                  eventCatValue = value;
                  setState(() {
                    
                  });
                },
                items: EventCategories.values.map((cat) => DropdownMenuItem(
                  value: cat,
                  child: 
                Text(cat.name, style: TextStyle(
                  color: darkMode == true? Colors.white : Colors.black
                ),)),).toList()
              ),
              TextFormField(
                key: Key('eventDescriptionField'),
                controller: eventDescriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
              ),
              TextFormField(
                key: Key('eventDateField'),
                controller: eventDateController,
                decoration: InputDecoration(
                  labelText: "Date",
                  labelStyle: TextStyle(
                      color: darkMode == true ? Colors.white : Colors.black),
                ),
                style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
                onTap: () async {
                  DateTime? date = DateTime(1900);
                  FocusScope.of(context).requestFocus(FocusNode());
                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (date != null) {
                    setState(() {
                      eventDateController.text =
                          "${date!.day}/${date!.month}/${date!.year}";
                    });
                  }
                },
              ),
              TextFormField(
                key: Key("eventLocationField"),
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
          key: Key("addDialogEvent"),
          onPressed: () async {
            if (globalFormKey.currentState!.validate()) {
              await widget.modelView.addEvent(
                eventNameController.text,
                eventDateController.text,
                eventCatValue!.name,
                eventDescriptionController.text,
                eventLocationController.text,
              );

              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text(
            'Add',
            style: TextStyle(color: darkMode == true ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
