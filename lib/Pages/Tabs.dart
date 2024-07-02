import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Pages/DealsScreen.dart';
import 'package:provider/provider.dart';
import '../Cart/CartModel.dart';
import '../Recipes Api/recipe_screen.dart';
import 'Home.dart';
import '../Cart/MyCart.dart';

class Home extends StatefulWidget {
  final bool isLoggedIn;

  const Home({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

  Future<bool> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit'),
        content: Text('Are you sure you want to exit the app?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Exit the app completely
              Navigator.of(context).pop(true);
              exit(0);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            children: <Widget>[
              // Menu Tab
              HomePage(),
              // Deals Tab
              DealsScreen(),
              // recipe Tab
              RecipesHomeScreen(),
              // My Cart Tab
              CartPage(),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.deepOrange,
            unselectedItemColor: Colors.grey,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: AnimatedIconWidget(
                  icon: Icons.home,
                  isSelected: _selectedIndex == 0,
                ),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: AnimatedIconWidget(
                  icon: Icons.percent_sharp,
                  isSelected: _selectedIndex == 1,
                ),
                label: 'Deals',
              ),
              BottomNavigationBarItem(
                icon: AnimatedIconWidget(
                  icon: Icons.receipt,
                  isSelected: _selectedIndex == 2,
                ),
                label: 'Recipes',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    AnimatedIconWidget(
                      icon: Icons.shopping_cart,
                      isSelected: _selectedIndex == 3,
                    ),
                    if (context.watch<CartModel>().itemCount > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 7,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${context.watch<CartModel>().itemCount}',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Cart',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedIconWidget extends StatelessWidget {
  final IconData icon;
  final bool isSelected;

  const AnimatedIconWidget({Key? key, required this.icon, required this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: isSelected ? EdgeInsets.all(8.0) : EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.deepOrange.withOpacity(0.2) : Colors.transparent,
      ),
      child: Icon(
        icon,
        size: isSelected ? 27.0 : 24.0,
        color: isSelected ? Colors.deepOrange : Colors.blueGrey,
      ),
    );
  }
}
