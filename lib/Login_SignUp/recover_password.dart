import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Pages/Tabs.dart';

class RecoverPassword extends StatefulWidget {
  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  String verificationId = "";
  String PredixText = "+92";
  bool isLoggedIn = false;
  var phone = "";
  var email = "";
  bool otpSent = false;

  void sendOTP() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: _otpController.text,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      // Navigate to set new password screen or directly update password
      // (Firebase Auth handles verification, so the user is considered authenticated here)
      // Typically, update the password in Firestore here
      // For simplicity, we'll just navigate to another screen here.
      email = phone + "@QuickBytes.com";
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SetNewPassword(userIdentifier: email,)),
      );
    }).catchError((error) {
      print("Failed to verify OTP: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to verify OTP. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recover Password'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _phoneNumberController,
                onChanged: (value) {
                  phone = PredixText + value;
                },
                style: TextStyle(color: Colors.black.withOpacity(0.9)),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixText: '$PredixText', // Prefix with country code
                  prefixStyle: TextStyle(fontSize: 16), // Adjust prefix font size
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.deepPurple,
                  ),
                  labelText: 'Phone',
                  labelStyle: TextStyle(fontSize: 16),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                ),
                validator: (value) {
                  RegExp mobileRegex = RegExp(r'^\d{10}$');
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (!mobileRegex.hasMatch(value)) {
                    return 'Mobile No. is incorrect';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              if (!otpSent)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      sendOTP();
                    }
                  },
                  child: Text('Send OTP'),
                ),
              if (otpSent)
                Column(
                  children: [
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter OTP';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          verifyOTP();
                        }
                      },
                      child: Text('Verify OTP'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
class SetNewPassword extends StatefulWidget {
  final String userIdentifier; // This could be phone number or email used for OTP verification

  const SetNewPassword({Key? key, required this.userIdentifier}) : super(key: key);

  @override
  _SetNewPasswordState createState() => _SetNewPasswordState();
}

class _SetNewPasswordState extends State<SetNewPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set New Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _passwordController,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Reset password logic here
                    resetPassword(widget.userIdentifier, _passwordController.text);
                  }
                },
                child: Text('Set New Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void resetPassword(String userIdentifier, String newPassword) {
    // Implement your logic to update the password for the user in your backend
    // Example with Firebase Authentication:
    FirebaseAuth.instance
        .confirmPasswordReset(
      code: newPassword,
      newPassword: newPassword,
    )
        .then((_) {
      // Password reset successful
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Home(isLoggedIn: true,),
        ),
      );
    }).catchError((error) {
      // Handle password reset error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to set new password. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}

