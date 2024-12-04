import 'package:flutter/material.dart';
import 'package:hediaty/CustomWidgets/friend_widget.dart';

class FriendSearchDelegate extends SearchDelegate<FriendWidget> {
  // Dummy list
  final List<FriendWidget> friendWidgetList;

  FriendSearchDelegate({required this.friendWidgetList});
  // These methods are mandatory you cannot skip them.

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
    Widget buildLeading(BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
          // Exit from the search screen.
      );
    }

  @override
  Widget buildResults(BuildContext context) {
    final List<FriendWidget> searchResults = friendWidgetList
        .where((item) => item.friend.userName.toLowerCase().contains(query.toLowerCase()))
        .toList();
        return SingleChildScrollView(
          child: Center( child: Column(
            children: searchResults
            )
          )
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<FriendWidget> suggestionList = query.isEmpty
        ? []
        : friendWidgetList
            .where((item) => item.friend.userName.toLowerCase().contains(query.toLowerCase()))
            .toList();

        return SingleChildScrollView(
          child: Center( child: Column(
            children: suggestionList
            )
          )
        );
  }
}