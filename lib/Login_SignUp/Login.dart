import 'package:firebase_auth/firebase_auth.dart';
import 'package:mad_fastfoods/Login_SignUp/recover_password.dart';
import 'package:mad_fastfoods/Login_SignUp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Pages/Functions.dart';
import 'package:mad_fastfoods/Pages/Tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/Welcome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _hidePassword = true;
  bool _isLoading = false; // Loading state variable
  String PredixText = "+92";
  bool isLoggedIn = false;
  var phone = "";
  var email = "";
  Map<String, String> Login_Data = {
    'email': '',
    'password': ''
  };

  Future<void> _saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log In",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white38,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          iconSize: 35,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeStart()));
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Container(
              margin: EdgeInsets.fromLTRB(15, 20, 15, 60),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withOpacity(0.9),
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
                      Colors.white
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
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return RadialGradient(
                            center: Alignment.topRight,
                            radius: 1.5,
                            colors: <Color>[
                              Colors.black,
                              Colors.deepOrange.shade300
                            ],
                            tileMode: TileMode.decal,
                          ).createShader(bounds);
                        },
                        child: Image.asset(
                          "assets/images/3.png",
                          height: 250,
                          width: 200,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "LOG IN WITH Mobile No.",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: _mobileController,
                        onChanged: (value) {
                          phone = PredixText + value;
                        },
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: '$PredixText', // Prefix with country code
                          prefixStyle: TextStyle(fontSize: 17), // Adjust prefix font size
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.deepPurple,
                          ),
                          labelText: 'Phone',
                          labelStyle: TextStyle(fontSize: 17,color: Colors.indigo),
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
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black.withOpacity(0.9)),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_outline,
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
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        ),
                        validator: (value) {
                          RegExp passRegex = RegExp(r'^[a-zA-Z0-9]');
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.isEmpty) {
                            return "Wrong Password";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecoverPassword(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _isLoading
                          ? CircularProgressIndicator()
                          : buttons(context, true, () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true; // Start loading
                          });

                          email = phone + "@QuickBytes.com";
                          Login_Data['email'] = email;
                          Login_Data['password'] = _passwordController.text;

                          FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: email,
                            password: _passwordController.text,
                          )
                              .then((value) {
                            print("Logged in");

                            setState(() {
                              isLoggedIn = true;
                              _saveLoginStatus(isLoggedIn); // Save login status
                            });

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(isLoggedIn: isLoggedIn),
                              ),
                            );
                          }).catchError((error) {
                            setState(() {
                              _isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Login failed. User not found.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Enter Valid Phone number and password'),
                              backgroundColor: Colors.tealAccent,
                            ),
                          );
                        }
                      }, null),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
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
                                  builder: (context) => signUp(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
