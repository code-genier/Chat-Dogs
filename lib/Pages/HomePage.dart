import 'package:chat_app/Helper/HelperFunction.dart';
import 'package:chat_app/Pages/ProfilePage.dart';
import 'package:chat_app/Pages/Search.dart';
import 'package:chat_app/Pages/auth/LoginPage.dart';
import 'package:chat_app/Services/AuthService.dart';
import 'package:chat_app/Services/DatabaseService.dart';
import 'package:chat_app/Widgets/GroupTile.dart';
import 'package:chat_app/Widgets/Widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? group;
  bool _isloading = false;
  String enteredGroupName = "";


  /// string manipulation
  String getId(String st){
    return st.substring(0, st.indexOf("_"));
  }

  String getGroupName(String st){
    return st.substring(st.indexOf("_")+1);
  }

  @override
  void initState(){
    super.initState();
    gettingUserDataFrom();
  }

  gettingUserDataFrom() async {
    await HelperFunction.getUserUserEmail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunction.getUserUserName().then((value) {
      setState(() {
        userName = value!;
      });
    });

    /// getting list of shap shot in our stream
    /// 1) getting current user uid from firebase
    
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  logout() async {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Logout, Really!"),
            content: Text("You sure you want to logout??"),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              IconButton(onPressed: (){
                Navigator.pop(context);
              },
                  icon: Icon(Icons.cancel, color: Colors.red,)),
              IconButton(onPressed: (){
                authService.signOut().whenComplete(() {
                  nextScreenReplacement(context, LoginPage());
                });
              },
                  icon: Icon(Icons.done, color: Colors.green,)),
            ],
          );
    });
  }

  noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25,),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (){
                popUpDialog(context);
              },
                child: Icon(
                    Icons.add_circle,
                    color: Colors.grey[700],
                    size: 75,
                )
            ),
            SizedBox(height: 20,),
            Text("You've not joined any groups!!"),
            Text("Click here to create a group"),
          ],
        ),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
      stream: group,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                /// render all groups name
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseIndex = snapshot.data['groups'].length - index - 1;
                  /// using group tile widget
                  return GroupTile(
                      groupId: getId(snapshot.data['groups'][reverseIndex]),
                      groupName: getGroupName(snapshot.data['groups'][reverseIndex]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text(
              "Create a new group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isloading ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ) : TextField(
                  onChanged: (val){
                    setState(() {
                      enteredGroupName = val;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        "Cancel",
                      )
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if(enteredGroupName != ""){
                          setState(() {
                            _isloading = true;
                          });
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName, FirebaseAuth.instance.currentUser!.uid, enteredGroupName)
                          .whenComplete((){
                            setState(() {
                              _isloading = false;
                            });
                          });
                          Navigator.of(context).pop();
                          showSnackBar(context, Colors.grey, "Group Created Successfully!");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Create",
                      )
                  ),
                ],
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, SearchPage());
                },
                icon: Icon(Icons.search),
            ),
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 6.0,
          title: Text("Groups",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle, size: 150, color: Colors.grey,),
            SizedBox(
              height: 15,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 25,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              leading: Icon(Icons.group),
              title: Text(
                "Group",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplacement(context, ProfilePage(userName: userName, email: email,));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              leading: Icon(Icons.person),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                logout();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              leading: Icon(Icons.exit_to_app_rounded),
              title: Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          popUpDialog(context);
        },
        elevation: 2.0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
