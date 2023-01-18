import 'dart:async';

import 'package:firebase_abcd/views/post_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fire_store_database/firestore_list_view.dart';
import '../views/auth/loginView.dart';

class SplashServices{
  void isLogin(BuildContext context){
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    if(user != null) {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FireStoreListView()));
      });
    }else{
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const LoginView()));
      });
    }
  }
}