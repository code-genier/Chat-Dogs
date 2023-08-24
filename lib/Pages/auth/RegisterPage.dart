import 'package:chat_app/Helper/HelperFunction.dart';
import 'package:chat_app/Pages/HomePage.dart';
import 'package:chat_app/Pages/auth/LoginPage.dart';
import 'package:chat_app/Services/AuthService.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../Widgets/Widget.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {

  final formKey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";
  String _fullname = "";
  bool _isloading = false;
  AuthService authService = AuthService();

  /// register function

  register() async{
    if(formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      await authService.registerUserWithEmailAndPassword(_fullname, _email, _password)
          .then((val) async {
            if(val == true){
              /// save the shared preference
              await HelperFunction.saveUserLoggedInStatus(true);
              await HelperFunction.saveUserNameSF(_fullname);
              await HelperFunction.saveUserEmailSF(_email);
              debugPrint("done");

              nextScreenReplacement(context, const HomePage());

            }else{
              showSnackBar(context, Colors.red, val);
              setState(() {
                _isloading = false;
              });
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading ? Center(child: CircularProgressIndicator(color:  Theme.of(context).primaryColor,),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Text("Groupie",
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Create your account !!",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
                Image.asset('assets/signup.png'),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Full Name",
                      prefixIcon: Icon(Icons.person, color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val) {
                    setState(() {
                      _fullname = val;
                    });
                  },

                  /// validation check

                  validator: (val) {
                    if(val!.isEmpty){
                      return "Please Enter your name";
                    }
                    else{
                      return null;
                    }
                  },

                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email, color: Theme.of(context).primaryColor,)
                  ),
                  onChanged: (val) {
                    setState(() {
                      _email = val;
                      // print(_email);
                    });
                  },

                  /// validation check

                  validator: (val) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").
                    hasMatch(val!) ? null : "Please enter valid Email";
                  },

                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.key, color: Theme.of(context).primaryColor,)
                  ),
                  validator: (value) {
                    // add your custom validation here.
                    if (value == null) {
                      return 'Please enter some text';
                    }
                    if (value.length < 6) {
                      return 'Must be atleast 6 charater';
                    }
                    else{
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox( /// this will take all available space, used here to widen the submit button
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      register();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text.rich(
                  /// use to create two text span side by side here,
                  /// don't have a account is one text span &
                  /// register here is other
                  /// else we can use row to style, but it will increase code work
                    TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                            fontSize: 14
                        ),
                        children: [
                          TextSpan(
                              text: "Login Here",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              recognizer: TapGestureRecognizer()..onTap = () {
                                nextScreen(context, LoginPage());
                              }
                          )
                        ]
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
