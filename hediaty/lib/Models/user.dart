import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Models/event.dart';

class User{
  int userID;
  late String userName;
  late String email;  
  //late Stirng 
  User({required this.userID, required this.userName, required this.email});

  User.fromID(this.userID);

  void initUserByID() async{
    final database = await DBManager.getDataBase();
    List<Map> user = await database.rawQuery("SELECT * FROM USERS WHERE id = $userID");
    this.userName = user[0]["name"];
    this.userName = user[0]["email"];
  }


  Future<List<User>> getAllFriends() async{
    List<User> friends = [];
    final database = await DBManager.getDataBase();
    List<Map> rawFriends = await database.rawQuery("SELECT * FROM USERS WHERE id in (SELECT friendID from FRIENDS where userID = $userID)");
    for(final rawFriend in rawFriends){
      friends.add(User(userID: rawFriend["ID"], userName: rawFriend["name"], email: rawFriend["email"]));
    }
    return friends;
  }


  
}