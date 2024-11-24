import 'package:firebase_database/firebase_database.dart';
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

  Future<List<User>> getAllFriendsFirebase() async{
    List<User> friends = [];
    final ref = FirebaseDatabase.instance.ref();

    //access friends of current User
    final rawFriends = await ref.child("Users/$userID/friends").get();

    //loop over the children i.e.: the friend's ids as keys    
    for(final rawFriend in rawFriends.children){
      print("Key is ${rawFriend.key}");

      //get friend's data
      //NOTE: this line doesn't read the friend's list correctly
      //DO NOT USE TO READ FRIENDS
      var friendData = await ref.child("Users/${rawFriend.key}").get();
      //print(friendData.value);
      Map friendMap = friendData.value as Map;
      //print("friend Map is $friendMap");
      friends.add(User(userID: int.parse(rawFriend.key!), userName: friendMap["name"], email: friendMap["email"]));
    }
    return friends;
  }


    static Future<int> checkUserExistsByPhone(String phoneNumber) async{
      final ref = FirebaseDatabase.instance.ref();
      final usersData = await ref.child("Users").get();
      if (usersData.exists) {
          for(var userData in usersData.children){
            Map userMap = userData.value as Map;
            //may need to change phone comparison
            if(userMap["phone"] == phoneNumber){
              return int.parse(userData.key!);
            }
            
          }
      }
      return -1;

    }

    static Future<bool> checkFriendshipStatus(int userID, int friendID) async{
      final ref = FirebaseDatabase.instance.ref();
      final userFriends = await ref.child("Users/$userID/friends").get();
      if(userFriends.exists){
        for(var friend in userFriends.children){
          int DBFriendID = int.parse(friend.key!);
          if(DBFriendID == friendID){

            //users are friends
            return true;
          }
        }
      }
      //users aren't friends
      return false;
    }

    static Future<bool> addFriend(int userID ,String friendPhoneNumber) async{

      int friendID  = await checkUserExistsByPhone(friendPhoneNumber);
      if(friendID == -1){ //friend not found
        return false;
      }
      bool freindshipStatus = await checkFriendshipStatus(userID, friendID);
      if(freindshipStatus == true){ //user is already a friend
        return false;
      }

      //add friend to user's friends
      var ref = FirebaseDatabase.instance.ref("Users/$userID/friends");
      await ref.update({friendID.toString(): ""});      

      //add user to friends's friends
      ref = FirebaseDatabase.instance.ref("Users/$friendID/friends");
      await ref.update({userID.toString(): ""});            


      return true; 

    }


  
}