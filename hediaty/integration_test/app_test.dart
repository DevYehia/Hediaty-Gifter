import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hediaty/Pages/LoginPage.dart';
import 'package:hediaty/main.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<void> initDB() async {
  WidgetsFlutterBinding.ensureInitialized();
  //print(await getDatabasesPath());
  final database = await openDatabase(
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
            userID TEXT,
            FirebaseID TEXT
            );

         CREATE TABLE Gifts(
         ID INTEGER PRIMARY KEY,
         name TEXT not null,
         description TEXT,
         category TEXT not null,
         price DOUBLE not null,
         isPledged BOOL,
         eventID INTEGER,
         pledgerID TEXT,
         firebaseID TEXT
         );
         
      ''',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
  //optional stuff for debugging purposes
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Workflow: 1)Login 2)Add existing Friend 3)Fail 4)Add Event 5)Add gift in event', (tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await initDB();
    await tester.pumpWidget(MyApp());
    //Login
    await testLogin(tester);

    await testFriendsPage(tester);

    await testEventsPage(tester);

    await testGiftCreate(tester);
  });
}

Future<void> testLogin(WidgetTester tester) async {
  final loginEmailField = find.byKey(const Key('LoginEmailField'));
  final loginPasswordField = find.byKey(const Key('LoginPasswordField'));
  final loginButton = find.byKey(const Key('LoginButton'));

  await tester.enterText(loginEmailField, 'yaya@yaya.com');
  await tester.enterText(loginPasswordField, '123456');
  await tester.tap(loginButton);

  await tester.pumpAndSettle();
}

Future<void> testFriendsPage(WidgetTester tester) async {
  final friendsPageAppBar = find.byKey(Key("FriendsPageAppbar"));
  final addFriendButton = find.byKey(Key("AddFriendButton"));

  expect(friendsPageAppBar, findsOneWidget);

  await tester.tap(addFriendButton);

    await tester.pumpAndSettle();
  final newFriendPhoneField = find.byKey(Key("NewFriendPhone"));
  final addFriendDialogButton = find.byKey(Key("AddFriendDialogButton"));


  expect(newFriendPhoneField, findsOneWidget);

  await tester.enterText(newFriendPhoneField, "1234"); //This user is already a friend
  await tester.tap(addFriendDialogButton);

   await tester.pumpAndSettle();
  final alreadyFriendSnack = find.byKey(Key("AddFailedSnack")); //show snack bar of failed add

  expect(alreadyFriendSnack, findsOneWidget);

  
}


Future<void> testEventsPage(WidgetTester tester) async{
  final navBarEventDest = find.byKey(Key("OwnerBotNavBarEvent"));

  await tester.tap(navBarEventDest);
  await tester.pumpAndSettle();

  final addEventButton = find.byKey(Key("AddEventButton"));

  await tester.tap(addEventButton);
  await tester.pumpAndSettle();

  final eventNameField = find.byKey(const Key('eventNameField'));
  final eventDescriptionField = find.byKey(const Key('eventDescriptionField'));
  final eventDateField = find.byKey(const Key('eventDateField'));
  final eventLocationField = find.byKey(const Key("eventLocationField"));
  final eventCategoryField = find.byKey(const Key("eventCategoryField"));
  final eventAddDialogButton = find.byKey(Key("addDialogEvent"));

  String eventName = "TesterEvent";
  await tester.enterText(eventNameField, "TesterEvent");
  await tester.enterText(eventDescriptionField, "TesterDesc");
  await tester.enterText(eventLocationField, "TesterLocation");  

  await tester.tap(eventDateField);
  await tester.pumpAndSettle();

  await tester.tap(find.text('28'));
  await tester.pumpAndSettle();  
  await tester.tap(find.text("OK"));
  await tester.pumpAndSettle();  

  await tester.tap(eventCategoryField);
  await tester.pumpAndSettle();

  await tester.tap(find.text("Birthday"));
  await tester.pumpAndSettle();

  await tester.tap(eventAddDialogButton);
  await tester.pumpAndSettle();

  final newEvent = find.text(eventName);
  expect(newEvent, findsOneWidget);

  await tester.tap(newEvent);
  await tester.pumpAndSettle();

}

Future<void> testGiftCreate(WidgetTester tester)async{

  final addGiftButton = find.byKey(Key("AddGiftButton"));

  await tester.tap(addGiftButton);
  await tester.pumpAndSettle();

  final giftNameField = find.byKey(const Key('giftNameField'));
  final giftDescriptionField = find.byKey(const Key('giftDescriptionField'));
  final giftCategoryField = find.byKey(const Key("giftCategoryField"));
  final giftPriceField = find.byKey(Key("giftPriceField"));

  final giftAddDialogButton = find.byKey(Key("addDialogGift"));

  String giftName = "TesterGift";
  await tester.enterText(giftNameField, giftName);
  await tester.enterText(giftDescriptionField, "TesterGiftDesc");
  await tester.enterText(giftPriceField, "2000");  


  await tester.tap(giftCategoryField);
  await tester.pumpAndSettle();

  await tester.tap(find.text("Gaming"));
  await tester.pumpAndSettle();

  await tester.tap(giftAddDialogButton);
  await tester.pumpAndSettle();

  final newGift = find.text(giftName);
  expect(newGift, findsOneWidget);

}