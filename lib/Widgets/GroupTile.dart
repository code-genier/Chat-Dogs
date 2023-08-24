import 'package:chat_app/Pages/ChatPage.dart';
import 'package:chat_app/Widgets/Widget.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  String userName;
  String groupId;
  String groupName;
  GroupTile({Key? key, required this.groupName, required this.groupId, required this.userName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),

      child: ListTile(
        onTap: (){
          nextScreen(context, ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
          ));
        },
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            widget.groupName[0].toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        title: Text(
            widget.groupName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
        ),
        subtitle: Text(
            "Joined as ${widget.userName}",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
        ),
      ),
    );
  }
}
