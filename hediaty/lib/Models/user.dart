import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hediaty/Models/DBManager.dart';
import 'package:hediaty/Models/event.dart';

class UserModel{
  String userID;
  late String userName;
  late String email;
  late String phone;
  late int eventCount;  
  //late Stirng 
  UserModel({required this.userID, required this.userName, required this.email, required this.phone, required this.eventCount});

  UserModel.fromID(this.userID);

  void initUserModelByID() async{
    final database = await DBManager.getDataBase();
    List<Map> user = await database.rawQuery("SELECT * FROM USERS WHERE id = $userID");
    this.userName = user[0]["name"];
    this.userName = user[0]["email"];
  }

  Future<void> initUserModelByIDFirebase() async{
    final ref = FirebaseDatabase.instance.ref();
    final user = await ref.child("Users/$userID").get();
    Map userMap = user.value as Map;
    this.userName = userMap["name"];
    this.email = userMap["email"];
  }

  static Future<UserModel> getUserByID(String userID) async{
    final ref = FirebaseDatabase.instance.ref();
    final user = await ref.child("Users/$userID").get();
    Map userMap = user.value as Map;
    return UserModel(email: userMap["email"],
                     userID: userID, 
                     userName: userMap["name"], 
                     phone: userMap["phone"],
                     eventCount: userMap["eventCount"]);
  }


  Future<List<UserModel>> getAllFriends() async{
    List<UserModel> friends = [];
    final database = await DBManager.getDataBase();
    List<Map> rawFriends = await database.rawQuery("SELECT * FROM USERS WHERE id in (SELECT friendID from FRIENDS where userID = $userID)");
    for(final rawFriend in rawFriends){
      //eventCount should be fixed later
      friends.add(UserModel(userID: rawFriend["ID"], userName: rawFriend["name"], email: rawFriend["email"], phone: rawFriend["phone"], eventCount: 0));
    }
    return friends;
  }

  static Future<List<UserModel>> getAllFriendsFirebase(String userID) async{
    List<UserModel> friends = [];
    final ref = FirebaseDatabase.instance.ref();

    //access friends of current UserModel
    final rawFriends = await ref.child("Users/$userID/friends").get();

    //loop over the children i.e.: the friend's ids as keys    
    for(final rawFriend in rawFriends.children){
      //get friend's data
      //NOTE: this line doesn't read the friend's list correctly
      //DO NOT USE TO READ FRIENDS
      var friendData = await ref.child("Users/${rawFriend.key}").get();
      Map friendMap = friendData.value as Map;
      friends.add(UserModel(userID: rawFriend.key!,
        userName: friendMap["name"],
        email: friendMap["email"],
        phone: friendMap["phone"],
        eventCount: friendMap["eventCount"]));
    }
    return friends;
  }


    static Future<String> getUserIDByPhone(String phoneNumber) async{
      final ref = FirebaseDatabase.instance.ref();
      final usersData = await ref.child("Users").get();
      if (usersData.exists) {
          for(var userData in usersData.children){
            Map userMap = userData.value as Map;
            //may need to change phone comparison
            if(userMap["phone"] == phoneNumber){
              return userData.key!;
            }
            
          }
      }
      return "";

    }

    static Future<bool> checkFriendshipStatus(String userID, String friendID) async{
      final ref = FirebaseDatabase.instance.ref();
      final userFriends = await ref.child("Users/$userID/friends").get();
      if(userFriends.exists){
        for(var friend in userFriends.children){
          String DBFriendID = friend.key!;
          if(DBFriendID == friendID){

            //users are friends
            return true;
          }
        }
      }
      //users aren't friends
      return false;
    }

    static Future<bool> addFriend(String userID ,String friendPhoneNumber) async{

      String friendID  = await getUserIDByPhone(friendPhoneNumber);
      if(friendID == ""){ //friend not found
        return false;
      }
      bool freindshipStatus = await checkFriendshipStatus(userID, friendID);
      if(freindshipStatus == true){ //user is already a friend
        return false;
      }

      //add friend to user's friends
      var ref = FirebaseDatabase.instance.ref("Users/$userID/friends");
      await ref.update({friendID: ""});      

      //add user to friends's friends
      ref = FirebaseDatabase.instance.ref("Users/$friendID/friends");
      await ref.update({userID: ""});            


      return true; 

    }


    static Future<String> getUserIDByEmail(String email) async{
      final ref = FirebaseDatabase.instance.ref();
      final usersData = await ref.child("Users").get();
      if (usersData.exists) {
          for(var userData in usersData.children){
            Map userMap = userData.value as Map;
            //may need to change phone comparison
            if(userMap["email"] == email){
              return userData.key!;
            }
            
          }
      }
      return "";      


    }

    static String getLoggedUserID(){
      return FirebaseAuth.instance.currentUser!.uid;
    }

    static Future<void> decrementEventCounter(String userID) async{
      var userRef = FirebaseDatabase.instance.ref("Users/$userID");
      int eventCount = (await userRef.child("eventCount").get()).value as int;
      await userRef.update({
       "eventCount": eventCount - 1 
      });

    }

  static void attachListenerForEventCount(String userID, void Function(int, String) callback){


      //listen for Changes on event count
      var eventCountRef = FirebaseDatabase.instance.ref("Users/$userID/eventCount");
      var eventCountListener = eventCountRef.onValue.listen((updatedCount) { 
          print("Event Count Changed!!");
          callback(updatedCount.snapshot.value as int, userID);
        }
      ,);    

  }

  
}