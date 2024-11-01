

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBManager{
  static Future<Database>? database;
  static Future<Database> getDataBase() async{
    database ??= openDatabase(
      join(await getDatabasesPath(), 'hediaty.db')
      );
    return database!;
  }
}