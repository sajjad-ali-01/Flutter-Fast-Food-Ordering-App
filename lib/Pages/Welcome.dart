import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Login_SignUp/Login.dart';
import 'package:mad_fastfoods/Pages/Tabs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeStart extends StatefulWidget {
  const HomeStart({super.key});

  @override
  State<HomeStart> createState() => _HomeStartState();
}
class _HomeStartState extends State<HomeStart> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  void _handleGetStartedPress() {
    if (_isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(isLoggedIn: true)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(420),
          child: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            backgroundColor: Colors.amber,
            flexibleSpace: Container(
              height: 550,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
                child: Image.asset(
                  'assets/images/Sajjad.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'GET',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.indigo,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'SET',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.amber,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'BITE',
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.red,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  'WHERE YOUR CRAVINGS FIND THEIR HAPPY PLACE!',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 300,
                height: 70,
                child: ElevatedButton(
                  onPressed: _handleGetStartedPress,
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFF800000)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
