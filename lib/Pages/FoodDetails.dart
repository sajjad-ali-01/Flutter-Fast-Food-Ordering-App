import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Cart/CartModel.dart';

class FoodDetailScreen extends StatefulWidget {
  final String name;
  final String price;
  final String image;
  final String description;
  final String category; // New property for category

  FoodDetailScreen({
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.category, // Initialize category
  });

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  String _selectedSize = 'Small';
  String _selectedCrust = 'Hand Tossed';
  Map<String, bool> _selectedToppings = {
    'Cheese': false,
    'Peri Peri Chicken': false,
    'Tex-Mex Chicken': false,
    'Mughlai Topping': false,
  };
  int _quantity = 1;

  Map<String, double> _pizzaSizePrices = {};
  Map<String, double> _drinkSizePrices = {};

  @override
  void initState() {
    super.initState();
    double basePrice = double.parse(widget.price);
    _pizzaSizePrices = {
      'Small': basePrice,
      'Medium': basePrice * 3,
      'Large': basePrice * 4,
      'Extra Large': basePrice * 5,
    };
    _drinkSizePrices = {
      '0.5 Liter(s)': basePrice,
      '1.0 Liter(s)': basePrice * 2,
      '1.5 Liter(s)': basePrice * 3,
      '2 Liter(s)': basePrice * 4,
    };

    // Initialize _selectedSize based on the category
    if (widget.category == 'Drinks') {
      _selectedSize = '0.5 Liter(s)'; // Default to the first size for drinks
    } else {
      _selectedSize = 'Small'; // Default to the first size for pizza
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showSizeCrustToppings = widget.category == 'Pizza';
    bool showDrinkSize = widget.category == 'Drinks';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          // Add your favorite button here
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      widget.image,
                      height: 200,
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_quantity > 1) _quantity--;
                            });
                          },
                          icon: Icon(Icons.remove, color: Colors.red),
                        ),
                        Text('$_quantity', style: TextStyle(fontSize: 18)),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _quantity++;
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      showDrinkSize
                          ? _drinkSizePrices[_selectedSize]!.toStringAsFixed(2)
                          : _pizzaSizePrices[_selectedSize]!.toStringAsFixed(2),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.description,
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (showDrinkSize) ...[
                    SizedBox(height: 16),
                    Text('Size'),
                    Column(
                      children: _drinkSizePrices.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text('${entry.key} (\Rs. ${entry.value.toStringAsFixed(2)})'),
                          value: entry.key,
                          groupValue: _selectedSize,
                          onChanged: (value) {
                            setState(() {
                              _selectedSize = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  if (showSizeCrustToppings) ...[
                    SizedBox(height: 16),
                    Text('Size'),
                    Column(
                      children: _pizzaSizePrices.entries.map((entry) {
                        return RadioListTile<String>(
                          title: Text('${entry.key} (\Rs. ${entry.value.toStringAsFixed(2)})'),
                          value: entry.key,
                          groupValue: _selectedSize,
                          onChanged: (value) {
                            setState(() {
                              _selectedSize = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Text('Crust'),
                    Column(
                      children: ['Hand Tossed', 'Pan'].map((crust) {
                        return RadioListTile<String>(
                          title: Text(crust),
                          value: crust,
                          groupValue: _selectedCrust,
                          onChanged: (value) {
                            setState(() {
                              _selectedCrust = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    Text('Extra Toppings'),
                    Column(
                      children: _selectedToppings.keys.map((topping) {
                        return CheckboxListTile(
                          title: Text(topping),
                          value: _selectedToppings[topping],
                          onChanged: (value) {
                            setState(() {
                              _selectedToppings[topping] = value!;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                  TextButton(
                    onPressed: () {
                      // Show nutritional info
                    },
                    child: Text('View Nutritional Info & Allergens'),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (_quantity > 1) _quantity--;
                        });
                      },
                      icon: Icon(Icons.remove, color: Colors.red),
                    ),
                    Text('$_quantity', style: TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: Icon(Icons.add, color: Colors.red),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Collect selected toppings
                    List<String> selectedToppings = _selectedToppings.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    // Add to cart functionality
                    final cartItem = CartItem(
                      name: widget.name,
                      size: _selectedSize,
                      price: _pizzaSizePrices[_selectedSize]! * _quantity,
                      quantity: _quantity,
                      toppings: selectedToppings,
                    );
                    context.read<CartModel>().addItem(cartItem);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Item added to cart')),
                    );
                  },
                  child: Text('Add To Cart',style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
