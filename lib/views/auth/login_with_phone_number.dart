import 'package:firebase_abcd/utils/toasts_messages.dart';
import 'package:firebase_abcd/views/auth/verify_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/widgets/fading_entrances/fade_in_down.dart';
import '../../widgets/rounded_button.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';


class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {

  bool loading = false ;
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance ;
  String code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network('https://ouch-cdn2.icons8.com/n9XQxiCMz0_zpnfg9oldMbtSsG7X6NwZi_kLccbLOKw/rs:fit:392:392/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9zdmcvNDMv/MGE2N2YwYzMtMjQw/NC00MTFjLWE2MTct/ZDk5MTNiY2IzNGY0/LnN2Zw.png', fit: BoxFit.cover, width: 280, ),
                const SizedBox(height: 50,),
                FadeInDown(
                  child: Text('REGISTER',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade900),),
                ),
                FadeInDown(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
                    child: Text('Enter your phone number to continue, we will send you OTP to verify.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                  ),
                ),
                const SizedBox(height: 30,),
                FadeInDown(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black.withOpacity(0.13)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffeeeeee),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            code = number.dialCode!;
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: const TextStyle(color: Colors.black),
                          textFieldController: phoneNumberController,
                          formatInput: false,
                          maxLength: 10,
                          keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                          cursorColor: Colors.black,
                          inputDecoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15, left: 0),
                            border: InputBorder.none,
                            hintText: 'Phone Number',
                            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                          ),
                        ),
                        Positioned(
                          left: 90,
                          top: 8,
                          bottom: 8,
                          child: Container(
                            height: 40,
                            width: 1,
                            color: Colors.black.withOpacity(0.13),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 100,),
                FadeInDown(
                  child: RoundButton(
                    loading: loading,
                    title: 'Request OTP',
                    onTap: () {
                      setState(() {
                        loading = true ;
                      });
                      if (kDebugMode) {
                        print(code.toString() + phoneNumberController.text.toString());
                      }
                      auth.verifyPhoneNumber(
                        phoneNumber: code.toString() + phoneNumberController.text.toString(),
                          verificationCompleted: (_){
                            setState(() {
                              loading = false ;
                            });
                          },
                          verificationFailed: (e){
                            setState(() {
                              loading = false ;
                            });
                            ToastMessage.show(e.message.toString());
                          },
                          codeSent: (String verificationId, int? resendToken){
                            setState(() {
                              loading = false ;
                            });
                            Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyCodeScreen(verificationId: verificationId,)));
                          },
                          codeAutoRetrievalTimeout: (e){
                            setState(() {
                              loading = false ;
                            });
                            ToastMessage.show(e.toString());
                          }
                      );
                      },
                  ),
                ),

              ],
            ),
          ),
        )
    );
  }
}
