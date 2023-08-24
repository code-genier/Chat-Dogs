import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
  /// when user is typing
  focusedBorder: OutlineInputBorder(
    borderSide:  BorderSide(
      color: Color.fromRGBO(249, 168, 38, 1),
      width: 2,
    ),
  ),
  /// default border
  enabledBorder: OutlineInputBorder(
    borderSide:  BorderSide(
      color: Color.fromRGBO(249, 168, 38, 1),
      width: 2,
    ),
  ),
  /// error border
  errorBorder: OutlineInputBorder(
    borderSide:  BorderSide(
      color: Color.fromRGBO(249, 168, 38, 1),
      width: 2,
    ),
  ),
);


/// context => current loaction
/// pager ==> redirect to? page

void nextScreen(context, page){
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplacement(context, page){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackBar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message,
    style: TextStyle(fontSize: 14),),
    backgroundColor: color,
    duration: Duration(seconds: 2),
    action: SnackBarAction(label: "OK", onPressed: (){}, textColor: Colors.white,),
  ));
}