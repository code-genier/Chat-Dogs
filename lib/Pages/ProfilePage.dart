import 'dart:ffi';

import 'package:chat_app/Pages/HomePage.dart';
import 'package:chat_app/Services/AuthService.dart';
import 'package:chat_app/Widgets/Widget.dart';
import 'package:flutter/material.dart';

import 'auth/LoginPage.dart';

class ProfilePage extends StatefulWidget {
  String userName;
  String email;
  ProfilePage({Key? key, required this.email, required this.userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 6.0,
        centerTitle: true,
        title: Text("Profile",
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
              widget.userName,
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
              onTap: () {
                nextScreenReplacement(context, HomePage());
              },
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
              onTap: () {},
              selected: true,
              selectedColor: Theme.of(context).primaryColor,
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
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
