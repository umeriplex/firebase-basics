import 'package:firebase_abcd/views/post_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../utils/toasts_messages.dart';
import '../../widgets/rounded_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId ;
  const VerifyCodeScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false ;
  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80,),
            PinCodeTextField(
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                cursorColor: Colors.deepPurple,
                controller: verificationCodeController,
                enabled: true,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeColor: Colors.deepPurple,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.black
                ),
                onChanged: (value) {}
            ),
            const SizedBox(height: 80,),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: ()async{
              setState(() {
                loading = true ;
              });
              final crediantials = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verificationCodeController.text.toString()
              );
              try{
                await auth.signInWithCredential(crediantials);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> const PostView()), (route) => false);
              }catch(e){
                setState(() {
                  loading = false ;
                });
                ToastMessage.show(e.toString());
              }
            }
            )
          ],
        ),
      ),
    );
  }
}