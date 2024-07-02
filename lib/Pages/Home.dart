import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:mad_fastfoods/Pages/slider.dart';
import 'package:mad_fastfoods/Pages/userDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login_SignUp/Login.dart';
import 'Categories.dart';
import 'DealsScreen.dart';
import 'Favourite_Foods.dart';
import 'FoodDetails.dart';
import 'Tables.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool _isMenuOpen = false; // Track menu state
  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }
  void _closeMenu() {
    setState(() {
      _isMenuOpen = false;
    });
  }
  void _showSubscriptionDialog(String name, String price, String imageUrl, String description, String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: EdgeInsets.zero, // This removes default padding
          content:  Container(
              width: MediaQuery.of(context).size.width * 0.9, // 90% of screen width
              child: FoodDetailScreen(
                name: name,
                price: price,
                image: imageUrl,
                description: description,
                category: category,
              ),
            ),

        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _closeMenu,
      child: Stack(
        children: [
          DefaultTabController(
            length: 6,
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(65),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .where('UserId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error.toString()}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No data found'));
                    }

                    final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                    String firstName = data['FName'];
                    String imageUrl = data['ImageUrl'];

                    return AppBar(
                      backgroundColor: Colors.red[800],
                      elevation: 0,
                      flexibleSpace: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Colors.white,
                                      backgroundImage: imageUrl != null
                                          ? NetworkImage(imageUrl)
                                          : AssetImage("assets/images/profileLogo.jpg") as ImageProvider<Object>,
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16),
                                Text(
                                  firstName,
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                                Spacer(),
                                IconButton(
                                  icon: Icon(Icons.menu, color: Colors.white),
                                  onPressed: _toggleMenu,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              backgroundColor: Colors.red[800],
              body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 5),

                      color: Colors.red[800],

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Best Foods ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amberAccent,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Around You',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Image.asset("assets/images/3.png",height: 150,),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10.0, 5, 10, 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35.0),
                          topRight: Radius.circular(35.0),
                        ),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: _closeMenu, // Close the menu when tapping inside
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Categories',
                                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(initialTabIndex: 0)));
                                      },
                                      child: Text('See all', style: TextStyle(fontSize: 17, color: Colors.orange[900], fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 120, // Fixed height for the row of buttons
                                        child: Row(
                                          children: [
                                            _buildTabButton(context, 'Burger', 'assets/images/burger.png', 0),
                                            _buildTabButton(context, 'Pizza', 'assets/images/pizza.png', 1),
                                            _buildTabButton(context, 'Sides', 'assets/images/french-fries.png', 2),
                                            _buildTabButton(context, 'Meltz', 'assets/images/sandwich.png', 3),
                                            _buildTabButton(context, 'Deserts', 'assets/images/ice-cream.png', 4),
                                            _buildTabButton(context, 'Drinks', 'assets/images/soda-bottle.png', 5),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                ImageSlider(),
                                SizedBox(height: 7),
                                Text('Book Your Table', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Container(
                                  height: 130, // Set the height of the container
                                  width: double.infinity, // Set the width of the container to full width
                                  child: Image.asset(
                                    'assets/images/table.jpg',
                                    fit: BoxFit.cover, // Ensure the image covers the entire container
                                    width: double.infinity, // Ensure the image takes the full width of the container
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingPage()));
                                      },
                                      child: Text('Book Now', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Popular Deals', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => DealsScreen()));
                                      },
                                      child: Text('See all', style: TextStyle(fontSize: 17, color: Colors.orange[900])),
                                    ),
                                  ],
                                ),
                                // New section to display cards with data from Firestore
                                SizedBox(height: 10),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('Deals').snapshots(),
                                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(child: Text('Error: ${snapshot.error.toString()}'));
                                    }
                                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                      return Center(child: Text('No deals found'));
                                    }

                                    return Container(
                                      height: 180,  // Set a fixed height for the container
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: snapshot.data!.docs.map((doc) {
                                          final item = doc.data() as Map<String, dynamic>;
                                          return Card(
                                            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Image.network(
                                                    item['imageUrl'],
                                                    width: 120,
                                                    height: 200,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Container(
                                                    width: 190, // Set a fixed width for the container
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          item['Name'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                          item['description'],
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                        Text('Price: ${item['Price'].toString()} PKR'),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            _showSubscriptionDialog(
                                                              item['Name'],
                                                              item['Price'].toString(),
                                                              item['imageUrl'],
                                                              item['description'],
                                                              item['category'],
                                                            );
                                                          },
                                                          child: Text(
                                                            'Add to Cart',
                                                            style: TextStyle(color: Colors.white),
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Colors.red[800],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  },
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
          _buildMenu(), // Add the sliding menu
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      right: _isMenuOpen ? 0 : -MediaQuery.of(context).size.width * 0.8,
      top: 0,
      bottom: 0,
      child: Material(
        elevation: 16,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.deepOrangeAccent, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'My Account',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Adjust the color to match the design
                      ),
                    ),
                    SizedBox(height: 60),
                    buildAccountOption(context, 'My Details', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UserScreen()));
                    }),
                    buildAccountOption(context, 'My Favourites', () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FavoritesScreen()));
                    }),
                    Spacer(),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Handle log out
                          await FirebaseAuth.instance.signOut();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isLoggedIn', false); // Update login status in SharedPreferences
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()), // Navigate back to the login screen
                                (Route<dynamic> route) => false, // Clear all routes in the stack
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 90, vertical: 16),
                          backgroundColor: Colors.indigo,
                        ),
                        child: Text(
                          'Log Out',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 8,
                top: 30,
                child: IconButton(
                  icon: Icon(Icons.close_outlined),
                  color: Colors.white,
                  iconSize: 35,
                  onPressed: _closeMenu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAccountOption(BuildContext context, String title, VoidCallback onPressed) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(color: Colors.black, width: 1),
      ),
      child: ListTile(
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onPressed,
      ),
    );
  }
}

Widget _buildTabButton(BuildContext context, String label, String imagePath, int tabIndex) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5.0),
    child: TextButton(
      onPressed: () {
        // Navigate to the Category screen with the specified tab index
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Category(initialTabIndex: tabIndex)),
        );
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.white54),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: Colors.black),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    ),
  );
}
