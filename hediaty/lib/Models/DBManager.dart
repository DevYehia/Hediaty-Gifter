import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager {
  static Future<Database>? database;
  static Future<Database> getDataBase() async {
    database ??= openDatabase(join(await getDatabasesPath(), 'hediaty.db'));
    return database!;
  }

//call this functioon whenever a database reset like changing table structures is needed
  static Future<void> resetLocalDB() async {
    final database = await DBManager.getDataBase();
    try {
      await database.execute("DROP TABLE EVENTS");
    } catch (e) {}
    try {
      await database.execute("DROP TABLE GIFTS");
    } catch (e) {}
    await database.execute('''
            CREATE TABLE Events(
            ID INTEGER PRIMARY KEY, 
            name TEXT not null,
            date TEXT not null, 
            category TEXT not null,
            location TEXT not null, 
            description TEXT, 
            userID TEXT,
            firebaseID TEXT
            );
            
        ''');
    await database.execute('''
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
            ''');
    final tables =
        await database.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    //print(tables);
    print("DB RESET SUCCESSFULLY");
  }
}
