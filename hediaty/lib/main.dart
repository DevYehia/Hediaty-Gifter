import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Pages/mainPage.dart';
import 'package:hediaty/Pages/LoginPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



//test Firebase Connection

Future<void> testFire() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final ref = FirebaseDatabase.instance.ref();
  final userId = 1;
  final snapshot = await ref.child('Users/$userId').get();
  if (snapshot.exists) {
      print(snapshot.value);
  } else {
      print('No data available.');
  }
}



//create database tables when database is first created
Future<void> initDB() async{


  WidgetsFlutterBinding.ensureInitialized();
  //print(await getDatabasesPath());
  final database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.


  join(await getDatabasesPath(), 'hediaty.db'),
  // When the database is first created, create a table to store dogs.
  onCreate: (db, version) {
    // Run the CREATE TABLE statement on the database.
    print("tsettset");
    //userID will be TEXT due to it being the one in firebase database
    return db.execute(
      '''
         CREATE TABLE Events(
         ID INTEGER PRIMARY KEY, 
         name TEXT not null,
         date TEXT not null, 
         category TEXT not null,
         location TEXT not null, 
         description TEXT, 
         userID TEXT
         );

         CREATE TABLE Gifts(
         ID INTEGER PRIMARY KEY,
         name TEXT not null,
         description TEXT,
         category TEXT not null,
         price DOUBLE not null,
         isPledged BOOL,
         eventID integer,
         pledgerID TEXT
         );
         
      ''',
    );
  },
  // Set the version. This executes the onCreate function and provides a
  // path to perform database upgrades and downgrades.
  version: 1,
);
}

void main() async{
  await testFire();
  await initDB();
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
      home: LoginPage(),
    );
  }
}

