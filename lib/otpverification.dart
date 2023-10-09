import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:video_app/login.dart';
import 'package:video_app/utils.dart';



class otpverification extends StatefulWidget {
  final verificationId;
  const otpverification({Key? key , required this.verificationId}) : super(key: key);

  @override
  State<otpverification> createState() => _otpverificationState();
}

class _otpverificationState extends State<otpverification> {

  final _formKey = GlobalKey<FormState>();

  final _otpController = TextEditingController();
  void dispose_a (){

    _otpController.dispose();
    super.dispose();
  }


  int _remainingTime = 60;
  late Timer _timer;

  bool _isLoading = false;

  void _handleLock (){
   setState(() {
     _isLoading = true;
     Future.delayed( Duration( seconds: 2 ),
             () {
       setState( () {
         _isLoading = false;
         Navigator.push(context, MaterialPageRoute(builder: (context){return login();}));
       }  );
     }

     );
   });
  }

  void initState(){
    super.initState();
    startTimer();
  }

  void startTimer(){
    const onSec = Duration(seconds: 1);
    _timer = Timer.periodic(onSec, (Timer timer) {
    if ( _remainingTime == 0 ){
      setState(() {
        timer.cancel();
      });
    }
    else{
       setState( () {
        _remainingTime--;
      }  );
           }
              }
                 );
                    }
    String formatTime ( int seconds ){
    int minutes = ( seconds / 60 ).floor();
    int remaningSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2,"0");
    String secondsStr = remaningSeconds.toString().padLeft(2,"0");
    return "$minutesStr:$secondsStr";
                    }
  void resendOtp() {
    if (_remainingTime == 0) {
      _remainingTime = 60;
      startTimer();
    }
  }
  void dispose_b (){
    _timer.cancel();    // it removes the Timer.periodic method
    super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/images/otpverificationbackground.jpeg"),
          fit: BoxFit.cover,
        ),
      ),

        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0,bottom: 0),
                      child: Lottie.asset("assets/animations/otpanimation.json",
                          height: 340,
                        width: 340

                      ),
                    ),
                    Container(
                      height: 380,
                      width: 340,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(width: 2,color: Colors.white,),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 4,left: 0,right: 0),
                            child: Container(
                              width: 200,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _otpController,
                                    validator: (value){
                                      if( value!.isEmpty){
                                        return "Please enter otp";
                                      }if(value.length < 4 ){
                                        return "Please enter valid otp";
                                      }
                                      else{
                                        return null;
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(4),
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(

                                      errorStyle: TextStyle(color: Colors.blue,),  // error text color
                                      errorBorder: OutlineInputBorder(             // error textfield border
                                          borderRadius: BorderRadius.circular(21),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                            width: 1,
                                          ),

                                      ),
                                      disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(21),
                                          borderSide: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                          )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(21),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1,
                                          )

                                      ),
                                    ),

                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18,bottom: 0,left: 0,right: 0),
                                    child: Text("Enter your OTP code here",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25,bottom: 0,left: 0,right: 0),
                            child: SizedBox(
                              height: 60,
                              width: 320,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null
                                    :(){
                                  if( _formKey.currentState!.validate() ) {
                                    _handleLock();
                                }
                                     },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),

                                  ),
                                ),
                                child: _isLoading
                                  ? CircularProgressIndicator()
                                    : Text("Verify"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 18,bottom: 0,left: 0,right: 0),
                            child: Column(
                              children: [
                                Text("Did't receive the verification code?",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                                Text( formatTime(_remainingTime),
                                  style: TextStyle(fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: resendOtp,
                                  child: Text("Resend again",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
