import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Pages/slider.dart';
import 'FoodCategories.dart';

class Category extends StatefulWidget {
  final int initialTabIndex;

  const Category({super.key, required this.initialTabIndex});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      initialIndex: widget.initialTabIndex, // Set the initial tab index
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: GestureDetector(
            // Close the menu when tapping inside
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageSlider(),
                  SizedBox(height: 2),
                  TabBar(
                    labelColor: Color(0xffff5722),
                    unselectedLabelColor: Colors.black,
                    isScrollable: true,
                    indicatorWeight: 4.0,
                    indicatorColor: Color(0xffff5722),
                    tabs: [
                      Tab(
                        icon: Image.asset(
                          'assets/images/burger.png',
                          width: 30, // Adjust width and height as needed
                          height: 30,
                        ),
                        text: 'Burger',
                      ),
                      Tab(
                        icon: Image.asset(
                          'assets/images/pizza.png',
                          width: 30,
                          height: 30,
                        ),
                        text: 'Pizza',
                      ),
                      Tab(
                        icon: Image.asset(
                          'assets/images/french-fries.png',
                          width: 30,
                          height: 30,
                        ),
                        text: 'Sides',
                      ),
                      Tab(
                        icon: Image.asset(
                          'assets/images/sandwich.png',
                          width: 30, // Adjust width and height as needed
                          height: 30,
                        ),
                        text: 'Meltz',
                      ),
                      Tab(
                        icon: Image.asset(
                          'assets/images/ice-cream.png',
                          width: 30,
                          height: 30,
                        ),
                        text: 'Deserts',
                      ),
                      Tab(
                        icon: Image.asset(
                          'assets/images/soda-bottle.png',
                          width: 30,
                          height: 30,
                        ),
                        text: 'Drinks',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FoodCategoryTab(category: 'Burger'),
                        FoodCategoryTab(category: 'Pizza'),
                        FoodCategoryTab(category: 'Sides'),
                        FoodCategoryTab(category: 'Meltz'), // Adding additional tabs
                        FoodCategoryTab(category: 'Deserts'), // Adding additional tabs
                        FoodCategoryTab(category: 'Drinks'), // Adding additional tabs
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
