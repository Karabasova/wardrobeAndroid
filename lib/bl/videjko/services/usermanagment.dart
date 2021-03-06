import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class UserManagement {
  storeNewUser(user,context,String name){
    Firestore.instance.collection('/users').add({
      'email':user.email,
      'uid':user.uid,
      'name':name,
    }).then((value){
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Navigator.of(context).pop();
          Navigator.of(context).pushReplacementNamed('/homepage');
    })
        .catchError((e){
      print(e);
    });
  }
}