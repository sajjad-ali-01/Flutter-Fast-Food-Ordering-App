import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import '../Pages/Functions.dart';
import '../Pages/Tabs.dart';
import '../Pages/Firebase.dart';

class Otp extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final String password;
  final String FName;
  final String LName;
  final String mail;

  const Otp({required this.phoneNumber, required this.email, required this.password,required this.FName, required this.LName,required this.mail});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late final TextEditingController _otpController;
  late final FirebaseAuth _auth;
  late Timer _timer;
  int _countdown = 60; // Initial countdown value in seconds
  bool isLoggedIn = false; // Add a variable to track login status
  late String _verificationId;
  late bool _codeSent;
  late Timer _resendTimer;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _auth = FirebaseAuth.instance;
    _verifyPhoneNumber();
    startTimer();
    _codeSent = false;
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_countdown == 0) {
          setState(() {
            timer.cancel(); // Cancel the timer when countdown reaches 0
          });
        } else {
          setState(() {
            _countdown--;
          });
        }
      },
    );
  }

  void _verifyPhoneNumber() async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    // Check if email already exists
    QuerySnapshot emailSnapshot = await users.where('Email', isEqualTo: widget.email).get();
    if (emailSnapshot.docs.isNotEmpty) {
      print('Error: Email already exists');
      _showMessageBox(context, "Email already exists");
      return; // Exit the function since email already exists
    }

    // Check if phone number already exists
    QuerySnapshot phoneSnapshot = await users.where('Phone', isEqualTo: widget.phoneNumber).get();
    if (phoneSnapshot.docs.isNotEmpty) {
      print('Error: Phone number already exists');
      _showMessageBox(context, "Phone number already exists");
      return; // Exit the function since phone number already exists
    }

    // Proceed with phone number verification since email and phone number are unique
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto verification completed (unlikely in manual flow)
      },
      verificationFailed: (FirebaseAuthException e) {
        // Verification failed
        print('Verification failed: ${e.message}');
        _showMessageBox(context, "Verification Failed Time Out");
      },
      codeSent: (String verificationId, int? resendToken) {
        // OTP code sent
        _verificationId = verificationId;
        setState(() {
          _codeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Called when the auto-sms-code-retrieval timer has expired
      },
    );
  }


  void _signInWithPhoneNumber(String smsCode, String verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
      // Verification successful, navigate to the home screen
      FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: widget.mail,
          password: widget.password).then((value){
        addUserToFirestore(widget.FName, widget.LName, widget.email, widget.phoneNumber, widget.password,'DD/MM/YYYY','Select Gender');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(isLoggedIn: true,)));
      });

    } catch (e) {
      _showMessageBox(context, "Verification Failed Time out");
      print('Error verifying OTP: $e');

    }
  }
  void _showMessageBox(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _onButtonPressed(BuildContext context) {
    String otpCode = _otpController.text.trim();
    if (otpCode.isEmpty) {
      _showMessageBox(context, "Please enter the OTP code");
    } else {
      // Perform your action when the button is pressed
    }
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 22,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_outlined, color: Colors.black, size: 27),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(25, 50, 25, 0),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/otp.png",
                height: 220,
                width: 220,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "We need to register your Phone before getting started !",
                style: TextStyle(
                  fontSize: 17,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
          Pinput(
                controller: _otpController,
                length: 6,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) => _signInWithPhoneNumber(pin, _verificationId),
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                validator: (value){
                  if(value==null){
                    print("enter Otp code");
                  }
                },
              ),
              SizedBox(height: 10),
              buttons(
                context,
                false,
                    () {
                  _onButtonPressed(context);
                },
                Icons.verified_outlined,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: _countdown == 0 ? () {
                        _verifyPhoneNumber();
                        _countdown = 90; // Reset countdown
                        startTimer(); // Start timer again
                      } : null,
                      child: Text(
                        _countdown == 0 ? "Resend Code" : "Resend Code ($_countdown)",
                        style: TextStyle(
                          fontSize: 16,
                          color: _countdown == 0 ? Colors.blue : Colors.grey,
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Edit Phone Number?",
                        style: TextStyle(
                            fontSize: 16
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
