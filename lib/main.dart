import 'package:chat_app/Helper/HelperFunction.dart';
import 'package:chat_app/Pages/HomePage.dart';
import 'package:chat_app/random.dart';
import 'package:flutter/material.dart';
import 'Pages/auth/LoginPage.dart';
import 'Shared/Constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// color : yellow #F9A826
/// black : #1E1E1D
///



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
   bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    /// *impt*
    /// initialize the firebase
    Firebase.initializeApp();
    debugPrint("here we go again");
    getUserLoggedInStatus();
  }


  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) => {
      if(value != null){
        setState(() {
          isSignedIn = value;
          debugPrint('\nsignedin Status $isSignedIn');
        })
      }
    });
  }

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
