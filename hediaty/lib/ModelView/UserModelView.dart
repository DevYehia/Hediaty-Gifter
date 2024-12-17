import 'package:hediaty/CustomWidgets/friend_widget.dart';
import 'package:hediaty/Models/event.dart';
import 'package:hediaty/Models/user.dart';

class UserViewModel{
  static List<FriendWidget>? friendList;
  void Function(String?)? UIAddEvent;
  void Function()? UIDeleteEvent;
  void Function() refreshCallback;
  UserViewModel({this.UIAddEvent, this.UIDeleteEvent, required this.refreshCallback});

  Future<List<FriendWidget>> initFriendsList() async{

    if(friendList == null){
      UserModel loggedInUser = await UserModel.getUserByID(UserModel.getLoggedUserID());

      List<UserModel> friendModelList = await UserModel.getAllFriendsFirebase(loggedInUser.userID);
      friendList = friendModelList.map((friend) => FriendWidget(friend: friend, eventCount: friend.eventCount, viewModel: this,),).toList();
    }
    return friendList!;
  }

  Future<void> addFriend(String phone) async{
      await UserModel.addFriend(UserModel.getLoggedUserID(),phone);    
  }

  List<FriendWidget> get allFriendList{
    return friendList??[];
  }

  void listenForEventCount(String friendID){
    UserModel.attachListenerForEventCount(friendID, compareEventCountWithRemote);
  }

  void compareEventCountWithRemote(int newEventCount, String friendID) async {
    //user added an event
    print("New Event Count is $newEventCount");
    FriendWidget friend = friendList!.where((friendWidg) => friendWidg.friend.userID == friendID).toList()[0];
    int oldEventCount = friend.eventCount;
    String friendName = friend.friend.userName;
      if (newEventCount > oldEventCount) {
        print("Am called");
        friendList![friendList!.indexWhere((friendWidg) => friendWidg.friend.userID == friendID)].eventCount = newEventCount;
        refreshCallback();
        if (UIAddEvent != null) UIAddEvent!(friendName);
      }

      //user deleted an event
      else if (newEventCount < oldEventCount) {
        print("Am called");
        friendList![friendList!.indexWhere((friendWidg) => friendWidg.friend.userID == friendID)].eventCount = newEventCount;
        refreshCallback();
        if (UIDeleteEvent != null) UIDeleteEvent!();
      }
  }
  
}