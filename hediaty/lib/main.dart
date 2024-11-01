import 'package:flutter/material.dart';
import 'package:hediaty/Pages/mainPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; //remove when deploying


//create database tables when database is first created
void initDB() async{
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactory = databaseFactoryFfi; //remove when deploying
  print(await getDatabasesPath());
  final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.


  join(await getDatabasesPath(), 'hediaty.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    return db.execute(
      '''CREATE TABLE Users(
         ID INTEGER PRIMARY KEY, 
         name TEXT not null, 
         email TEXT not null
         );

         CREATE TABLE Events(
         ID INTEGER PRIMARY KEY, 
         name TEXT not null,
         date DATETIME not null, 
         category TEXT not null,
         location TEXT not null, 
         description TEXT, 
         userID integer,
         FOREIGN KEY(userID) REFERENCES Users(ID) ON DELETE CASCADE
         );

         CREATE TABLE Gifts(
         ID INTEGER PRIMARY KEY,
         name TEXT not null,
         description TEXT,
         category TEXT not null,
         price DOUBLE not null,
         isPledged BOOL,
         eventID integer,
         pledgerID integer,
         FOREIGN KEY(eventID) REFERENCES Events(ID) ON DELETE CASCADE,
         FOREIGN KEY(pledgerID) REFERENCES Users(ID) ON DELETE CASCADE
         );

         CREATE TABLE Friends(
         userID integer,
         friendID integer,
         FOREIGN KEY(userID) REFERENCES Users(id),
         FOREIGN KEY(friendID) REFERENCES Users(id),
         PRIMARY KEY(userID,friendID)         
         )
         
      ''',
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);
}

void main() async{
  initDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gifter',
      home: MyMainPage(title: 'Gifter'),
    );
  }
}

