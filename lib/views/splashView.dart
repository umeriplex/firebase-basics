import 'package:firebase_abcd/firebaseServices/splashServices.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashServices _splashServices = SplashServices();
  @override
  void initState() {
    _splashServices.isLogin(context);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Splash View',style: TextStyle(fontSize: 34),),
      ),
    );
  }
}
