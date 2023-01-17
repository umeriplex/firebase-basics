import 'package:firebase_abcd/views/auth/loginView.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/toasts_messages.dart';
import '../../widgets/rounded_button.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  bool loading = false ;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final  _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();

  }

  // void signUp(){
  //   setState(() {
  //     loading = true ;
  //   });
  //
  //   // _auth.sendSignInLinkToEmail(
  //   //   email: emailController.text.toString(),
  //   //   actionCodeSettings: ActionCodeSettings(
  //   //     url: 'https://flutterauth.page.link/',
  //   //     handleCodeInApp: true,
  //   //     iOSBundleId: 'com.techease.dumy',
  //   //     androidPackageName: 'com.techease.dumy',
  //   //     androidMinimumVersion: "1",
  //   //   ),
  //   //
  //   // ).then((value){
  //   // }).onError((error, stackTrace){
  //   //   print(error.toString());
  //   // });
  //
  //   // _auth.createUserWithEmailAndPassword(
  //   //     email: emailController.text.toString(),
  //   //     password: passwordController.text.toString()).then((value){
  //   //   setState(() {
  //   //     loading = false ;
  //   //   });
  //   // }).onError((error, stackTrace){
  //   //   Utils().toastMessage(error.toString());
  //   //   setState(() {
  //   //     loading = false ;
  //   //   });
  //   // });
  // }

  void signUp(){
    setState(() {
      loading = true ;
    });
    _auth.createUserWithEmailAndPassword(
        email: emailController.text.toString(),
        password: passwordController.text.toString()
    ).then((value)  {
      ToastMessage.show('Account created successfully');
      setState(() {
        loading = false ;
      });
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
    }).onError((error, stackTrace) {
      ToastMessage.show(error.toString());
      setState(() {
        loading = false ;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const  InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter email';
                        }
                        return null ;
                      },
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: const  InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.lock_open)
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Enter password';
                        }
                        return null ;
                      },
                    ),

                  ],
                )
            ),
            const SizedBox(height: 50,),
            RoundButton(
              title: 'Sign up',
              loading: loading ,
              onTap: (){
                if(_formKey.currentState!.validate()){
                  signUp();
                }
              },
            ),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder:(context) => const LoginView())
                  );
                },
                    child: const Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
