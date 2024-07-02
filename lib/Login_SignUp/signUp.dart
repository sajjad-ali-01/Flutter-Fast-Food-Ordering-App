import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mad_fastfoods/Login_SignUp/Login.dart';
import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Pages/Functions.dart';
import 'Otp.dart';

class signUp extends StatefulWidget {
  const signUp({Key? key}) : super(key: key);
  @override
  State<signUp> createState() => _signUpState();
}

class _signUpState extends State<signUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _FNameTextController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _LNameTextController = TextEditingController();
  bool _hidePassword = true;
  var phone="";
  String PredixText="+92";
  late DatabaseReference dbref;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            iconSize: 35,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.amber,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 50, 10, 70),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 60),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amberAccent,
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Create an account",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _emailTextController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType:
                            TextInputType.emailAddress, // Set keyboardType here
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline, // Corrected usage of Icons
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.indigo.withOpacity(0.9),
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //borderSide: const BorderSide(width: 0,style: BorderStyle.none),
                          ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0)
                        ),
                        validator: (value) {
                          RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          else if (!emailRegex.hasMatch(value)|| value.isEmpty) {
                            return 'Please Enter the valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _FNameTextController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType:
                        TextInputType.name, // Set keyboardType here
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_outline, // Corrected usage of Icons
                            color: Colors.deepPurple,
                          ),
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                            color: Colors.indigo.withOpacity(0.9),
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //borderSide: const BorderSide(width: 0,style: BorderStyle.none),
                          ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0)

                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter First Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _LNameTextController,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType:
                            TextInputType.name, // Set keyboardType here
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person, // Corrected usage of Icons
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                            color: Colors.indigo.withOpacity(0.9),
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            //borderSide: const BorderSide(width: 0,style: BorderStyle.none),
                          ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0)

                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Last Name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      //
                      TextFormField(
                        controller: _mobileController,
                        onChanged: (value){
                          phone= PredixText+value;
                        },
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: '$PredixText', // Prefix with country code
                          prefixStyle: TextStyle(fontSize: 17), // Adjust prefix font size
                          prefixIcon: Icon(
                            Icons.phone, // Corrected usage of Icons
                            color: Colors.deepPurple,
                          ),
                          //hintText: "Phone",
                          //contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Adjust padding for visual balance
                          labelText: 'Phone', // Optional: Add label for accessibility
                          labelStyle: TextStyle(fontSize: 17,color: Colors.indigo),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),// Optional: Adjust label font size
                        ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0)

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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText:
                            _hidePassword, // Controls password visibility
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline, // Corrected usage of Icons
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.indigo.withOpacity(0.9),
                          ),
                          filled: true,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(_hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _hidePassword =
                                    !_hidePassword; // Toggle password visibility
                              });
                            },
                          ),
                            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0)

                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }  else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter,\n one lowercase letter, and Numbers';
                          }
                          return null;
                        },

                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buttons(context, false, () async {
                        if (_formKey.currentState!.validate()) {
                          // Pass necessary data to OTP screen
                          String phoneNumber = phone;
                          String email = _emailTextController.text;
                          String mail = phoneNumber+"@QuickBytes.com";
                          String password = _passwordController.text;
                          String First_Name=_FNameTextController.text;
                          String Last_Name=_LNameTextController.text;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Otp(
                                phoneNumber: phoneNumber,
                                email: email,
                                password: password,
                                 FName: First_Name,
                                 LName: Last_Name,
                                 mail: mail,
                              ),
                            ),

                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please fill valid data in all input Fields'),
                              backgroundColor: Colors.tealAccent,
                            ),
                          );
                        }
                      }, null),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )));
  }
}
