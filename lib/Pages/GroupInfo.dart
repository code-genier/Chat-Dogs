import 'package:chat_app/Pages/HomePage.dart';
import 'package:chat_app/Widgets/Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Services/DatabaseService.dart';

class GroupInfo extends StatefulWidget {

  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo({Key? key, required this.groupName, required this.groupId, required this.adminName}) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;
  String currUserId = "";

  @override
  void initState(){
    super.initState();
    getMembers();
    getCurrUserId();
  }

  String getName(String st){
    String currMemberId = st.substring(0, st.indexOf("_"));
    if(currMemberId == currUserId) return "You";
    return st.substring(st.indexOf("_")+ 1);
  }

  String getId(String st){
    return st.substring(0, st.indexOf("_"));
  }

  getCurrUserId(){
    setState(() {
      currUserId = FirebaseAuth.instance.currentUser!.uid;
    });
  }

  getMembers(){
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMember(widget.groupId)
        .then((val){
          setState(() {
            members = val;
          });
    });
  }

  leaveGroup() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Leaving, Really!"),
            content: Text("You sure you want to leave??"),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              },
                  icon: Icon(Icons.cancel, color: Colors.red,)),
              IconButton(onPressed: (){
                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                    .toggleGroupJoin(widget.groupId, getName(widget.adminName), widget.groupName)
                    .whenComplete(() {
                      nextScreenReplacement(context, HomePage());
                });
              },
                  icon: Icon(Icons.done, color: Colors.green,)),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Group Info."),
        elevation: 6.0,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(onPressed: (){
            leaveGroup();
          },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor.withOpacity(0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group Name: ${widget.groupName}",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Created By: ${getName(widget.adminName)}")
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }


  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ));
        }
      },
    );
  }
}
