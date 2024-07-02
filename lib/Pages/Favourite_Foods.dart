import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'FoodDetails.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: FavoriteItemsList(),
    );
  }
}

class FavoriteItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Center(
        child: Text('You need to be logged in to view favorites.'),
      );
    }

    final userId = user.uid;
    final favoritesCollection = FirebaseFirestore.instance
        .collection('favorites')
        .doc(userId)
        .collection('userFavorites');

    return StreamBuilder(
      stream: favoritesCollection.snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Colors.amber));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<DocumentSnapshot> favorites = snapshot.data!.docs;

        if (favorites.isEmpty) {
          return Center(
            child: Text('No favorites yet.'),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            var favoriteData = favorites[index].data() as Map<String, dynamic>;

            // Print the data to debug
            print(favoriteData);

            // Ensure all required fields are present and not null
            final imageUrl = favoriteData['imageUrl'] ?? '';
            final name = favoriteData['name'] ?? 'Unnamed Item';
            final description = favoriteData['description'] ?? 'No description available';
            final price = favoriteData['price'] ?? 0;
            final category = favoriteData['category'] ?? 'Unknown';

            return ListTile(
              leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : null,
              title: Text(name),
              subtitle: Text(description),
              trailing: Text(
                'Rs. $price',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(
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
          },
        );
      },
    );
  }
}
