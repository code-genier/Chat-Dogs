import 'package:flutter/material.dart';

import 'Pages/HomePage.dart';
import 'Pages/auth/LoginPage.dart';
import 'Shared/Constants.dart';
class  Random extends StatelessWidget {
  Random ({Key? key,required this.isSignedIn}) : super(key: key);
  final bool isSignedIn;
  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
  primaryColor: Constants().primaryColor,
  scaffoldBackgroundColor: Colors.white,
  ),
  title: 'Chat App',
  home: isSignedIn ? HomePage() : LoginPage(),
  );
  }
}
