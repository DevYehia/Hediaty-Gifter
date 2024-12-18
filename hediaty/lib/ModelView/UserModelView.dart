import 'package:firebase_database/firebase_database.dart';
import 'package:hediaty/CustomWidgets/friend_widget.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';

class UserViewModel {
  List<FriendWidget>? friendList;
  void Function(String?)? UIAddEvent;
  void Function()? UIDeleteEvent;
  void Function() refreshCallback;
  UserViewModel(
      {this.UIAddEvent, this.UIDeleteEvent, required this.refreshCallback});

  Future<List<FriendWidget>> initFriendsList() async {

      UserModel loggedInUser =
          await UserModel.getUserByID(UserModel.getLoggedUserID());
    if (friendList == null) {


      List<UserModel> friendModelList =
          await UserModel.getAllFriendsFirebase(loggedInUser.userID);
      friendList = friendModelList
          .map(
            (friend) => FriendWidget(
              friend: friend,
              eventCount: friend.eventCount,
              viewModel: this,
            ),
          )
          .toList();
    }
    UserModel.attachListenerForFriends(loggedInUser.userID, compareFriendsCountWithRemote);
    return friendList!;
  }

  Future<void> addFriend(String phone) async {
    bool addResult = await UserModel.addFriend(UserModel.getLoggedUserID(), phone);

    if(addResult == true){

    }
    else{
      //UI Update to indicate incorrect phone number
    }
  }

  List<FriendWidget> get allFriendList {
    return friendList ?? [];
  }

  void listenForEventCount(String friendID) {
    UserModel.attachListenerForEventCount(
        friendID, compareEventCountWithRemote);
  }

  void compareEventCountWithRemote(int newEventCount, String friendID) async {
    if (friendList != null) {
      //user added an event
      print("New Event Count is $newEventCount");
      FriendWidget friend = friendList!
          .where((friendWidg) => friendWidg.friend.userID == friendID)
          .toList()[0];
      int oldEventCount = friend.eventCount;
      String friendName = friend.friend.userName;
      if (newEventCount > oldEventCount) {
        print("Am called");
        friendList![friendList!.indexWhere(
                (friendWidg) => friendWidg.friend.userID == friendID)]
            .eventCount = newEventCount;
        refreshCallback();
        if (UIAddEvent != null) UIAddEvent!(friendName);
      }

      //user deleted an event
      else if (newEventCount < oldEventCount) {
        print("Am called");
        friendList![friendList!.indexWhere(
                (friendWidg) => friendWidg.friend.userID == friendID)]
            .eventCount = newEventCount;
        refreshCallback();
        if (UIDeleteEvent != null) UIDeleteEvent!();
      }
    }
  }

  void compareFriendsCountWithRemote(int newFriendsCount){
    if(friendList != null){
      if(friendList!.length != newFriendsCount){
        friendList = null;
        refreshCallback();
      }
    }
  }

  static Future<bool> checkIfPhoneExists(String phone, Function() phoneExistsUI) async{
    bool result = await UserModel.checkIfPhoneExistsFirebase(phone);
    if(result){
      phoneExistsUI();
    }
    return result;
  }

}
