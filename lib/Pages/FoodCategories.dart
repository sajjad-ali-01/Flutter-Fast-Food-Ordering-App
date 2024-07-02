import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'FoodDetails.dart';

class FoodCategoryTab extends StatelessWidget {
  final String category;

  FoodCategoryTab({required this.category});

  @override
  Widget build(BuildContext context) {
    return Expanded( // Wrap in Expanded to provide constraints
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Foods')
            .where('category', isEqualTo: category).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: Colors.amber),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<DocumentSnapshot> items = snapshot.data!.docs;

          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.66,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index].data() as Map<String, dynamic>;
              return FoodItem(
                name: item['Name'],
                price: item['Price'].toString(),
                description: item['description'],
                imageUrl: item['imageUrl'],
                category: item['category'],
              );
            },
          );
        },
      ),
    );
  }
}

class FoodItem extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String description;
  final String category;

  FoodItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {

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

    return GestureDetector(
      onTap: () {
        _showSubscriptionDialog(
          name,
          price,
          imageUrl,
          description,
          category
        );
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.9),
              spreadRadius: 0,
              blurRadius: 7,
                offset: Offset(0, 5)
            )
          ]
        ),
        child: Card(
          color: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    imageUrl,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                    ),
                    FavoriteButton(
                      name: name,
                      price: price,
                      imageUrl: imageUrl,
                      description: description,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Text('From Rs. ' + price, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final String description;

  FavoriteButton({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final favoritesCollection = FirebaseFirestore.instance.collection('favorites').doc(userId).collection('userFavorites');
      final querySnapshot = await favoritesCollection
          .where('name', isEqualTo: widget.name)
          .where('price', isEqualTo: widget.price)
          .where('imageUrl', isEqualTo: widget.imageUrl)
          .where('description', isEqualTo: widget.description)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          isFavorite = true;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userId = user.uid;
      final favoritesCollection = FirebaseFirestore.instance.collection('favorites').doc(userId).collection('userFavorites');

      final favoriteItem = {
        'name': widget.name,
        'price': widget.price,
        'imageUrl': widget.imageUrl,
        'description': widget.description,
      };

      try {
        if (isFavorite) {
          final querySnapshot = await favoritesCollection
              .where('name', isEqualTo: widget.name)
              .where('price', isEqualTo: widget.price)
              .where('imageUrl', isEqualTo: widget.imageUrl)
              .where('description', isEqualTo: widget.description)
              .get();

          for (var doc in querySnapshot.docs) {
            await doc.reference.delete();
          }
          setState(() {
            isFavorite = false;
          });
        } else {
          await favoritesCollection.add(favoriteItem);
          setState(() {
            isFavorite = true;
          });
        }
      } catch (e) {
        print('Error toggling favorite status: $e');
      }
    } else {
      print('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      color: Colors.red,
      onPressed: _toggleFavorite,
    );
  }
}
