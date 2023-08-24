import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // create reference of structure
  /// this will create a user collection if not found in db else use the existing one
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  // group collection
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  // updating/saving user data
  Future savingUserData(String fullname, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullname,
      "email": email,
      "groups": [],
      "uid": uid,
    });
  }

  // getting the user data

  Future gettingUserData(String email) async {
    // debugPrint('emial is $email');
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();

    final allData = snapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  /// get groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }


  /// creating a group

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": "",
    });

  /// v get grouup id after creating the group so
  /// after saving the group we need to update group id

  await groupDocumentReference.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": groupDocumentReference.id,
  });


  /// go to user collection and update the groups field

  DocumentReference userDocumentReference = userCollection.doc(uid);
  await userDocumentReference.update({
    "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  });
  }
  
  /// get chats and admin info
 getChats(String groupId) async {
    return groupCollection.doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
 }

 Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await d.get();

    return documentSnapshot['admin'];
 }

 /// get group memeber info
 getGroupMember(String groupId) async {
    return groupCollection.doc(groupId)
        .snapshots();
 }


 /// search
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }


  /// function -> bool
  Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  /// toggling the group join/exit
  Future toggleGroupJoin(
      String groupId, String userName, String groupName) async {
    // doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups -> then remove then or also in other part re join
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  /// send msg
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['Time'].toString(),
    });
  }
}