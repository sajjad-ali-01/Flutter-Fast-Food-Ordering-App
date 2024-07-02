import 'package:flutter/material.dart';
import 'package:mad_fastfoods/Pages/slider.dart';

import 'FoodCategories.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Deals',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.deepOrange,
          centerTitle: true,
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
                    isScrollable: false,
                    indicatorWeight: 4.0,
                    indicatorColor: Color(0xffff5722),
                    tabs: [
                      Tab(
                        text: 'See Our Best Deals',
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FoodCategoryTab(category: 'Deals'),
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
