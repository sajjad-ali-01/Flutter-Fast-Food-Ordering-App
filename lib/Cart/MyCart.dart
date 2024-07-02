import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CartModel.dart';
import 'package:uuid/uuid.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _manualAddressController = TextEditingController();
  String _selectedPaymentMethod = 'Cash on Delivery';
  String _selectedDeliveryAddress = '';

  Future<void> _saveOrder(BuildContext context) async {
    var cart = context.read<CartModel>();
    var uuid = Uuid();
    var orderId = uuid.v4(); // Generate a unique order ID

    try {
      if (cart.items.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Order Not Confirmed'),
              content: Text('Please select items to confirm order.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      if (_selectedDeliveryAddress.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Delivery Address'),
              content: Text('Please select or enter a delivery address.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      // Prepare order data
      final orderData = {
        'id': orderId,
        'items': cart.items.map((item) {
          return {
            'name': item.name,
            'size': item.size,
            'price': item.price,
            'quantity': item.quantity,
            'toppings': item.toppings,
          };
        }).toList(),
        'total': cart.totalPrice,
        'deliveryInstructions': _instructionsController.text,
        'date': DateTime.now().toIso8601String(),
        'status': 'Processing',
        'paymentMethod': _selectedPaymentMethod,
        'deliveryAddress': _selectedDeliveryAddress,
      };

      // Save order to Firestore
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set(orderData);

      // Clear the cart
      cart.clear();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order confirmed. Thank you!')),
      );
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save order: $e')),
      );
    }
  }

  void _selectAddress(BuildContext context) async {
    final List<String> addresses = [
      '123 Main St, Cityville',
      '456 Oak Ave, Townsville',
      '789 Pine Dr, Villagetown',
    ];

    final String? selectedAddress = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select or Enter Delivery Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select Address'),
              ...addresses.map((String address) {
                return SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context, address);
                  },
                  child: Text(address),
                );
              }).toList(),
              TextField(
                controller: _manualAddressController,
                decoration: InputDecoration(
                  hintText: 'Or enter a new address',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, _manualAddressController.text);
              },
              child: Text('Enter'),
            ),
          ],
        );
      },
    );

    if (selectedAddress != null && selectedAddress.isNotEmpty) {
      setState(() {
        _selectedDeliveryAddress = selectedAddress;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(8.0),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Text(
                      'Select your delivery address',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red

                      ),
                      onPressed: () => _selectAddress(context),
                      child: Text('Select',style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ),
              Text(_selectedDeliveryAddress.isNotEmpty ? _selectedDeliveryAddress : 'No address selected'),
              Divider(
                color: Colors.grey,
              ),
              SizedBox(height: 20),
              Text("PAYMENT METHOD",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),),
              ExpansionTile(
                title: Text('Select Payment Method'),
                initiallyExpanded: false,
                children: [
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Cash on Delivery'),
                    trailing: Radio<String>(
                      value: 'Cash on Delivery',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.payment),
                    title: Text('Jazz Cash'),
                    trailing: Radio<String>(
                      value: 'Jazz Cash',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('DELIVERY TIME'),
                initiallyExpanded: true,
                children: [
                  ListTile(
                    leading: Icon(Icons.timer,color: Colors.indigo,),
                    title: Text('ASAP'),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text('ITEMS'),
                initiallyExpanded: true,
                children: cart.items.map((item) {
                  return ListTile(
                    title: Text('${item.name} | ${item.size}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rs. ${item.price.toStringAsFixed(2)}'),
                        if (item.toppings.isNotEmpty)
                          Text('Toppings: ${item.toppings.join(', ')}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            context.read<CartModel>().decreaseQuantity(item);
                          },
                        ),
                        Text('${item.quantity}'),
                        IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            context.read<CartModel>().increaseQuantity(item);
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPECIAL INSTRUCTIONS (OPTIONAL)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        hintText: 'Add any comment, e.g. about allergies, or delivery instructions here.',
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Total: Rs. ${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Delivery Charges: Rs. 0.0'),
                    Text('Grand Total (Incl. Tax): Rs. ${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 2,
            left: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: () => _saveOrder(context),
              child: Text(
                'Place Order',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
