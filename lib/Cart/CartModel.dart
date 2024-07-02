import 'package:flutter/material.dart';

class CartItem {
  final String name;
  final String size;
  final double price;
  final int quantity;
  final List<String> toppings;

  CartItem({
    required this.name,
    required this.size,
    required this.price,
    this.quantity = 1,
    this.toppings = const [],
  });

  CartItem copyWith({
    String? name,
    String? size,
    double? price,
    int? quantity,
    List<String>? toppings,
  }) {
    return CartItem(
      name: name ?? this.name,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      toppings: toppings ?? this.toppings,
    );
  }
}

class CartModel extends ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (count, item) => count + item.quantity);

  double get totalPrice => _items.fold(0, (total, item) => total + (item.price * item.quantity));

  void addItem(CartItem item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].name == item.name && _items[i].size == item.size && _isSameToppings(_items[i].toppings, item.toppings)) {
        _items[i] = _items[i].copyWith(quantity: _items[i].quantity + item.quantity);
        notifyListeners();
        return;
      }
    }

    _items.add(item);
    notifyListeners();
  }

  void removeItem(CartItem item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].name == item.name && _items[i].size == item.size && _isSameToppings(_items[i].toppings, item.toppings)) {
        var newQuantity = _items[i].quantity - 1;
        if (newQuantity <= 0) {
          _items.removeAt(i);
        } else {
          _items[i] = _items[i].copyWith(quantity: newQuantity);
        }
        notifyListeners();
        return;
      }
    }
  }

  void increaseQuantity(CartItem item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].name == item.name && _items[i].size == item.size && _isSameToppings(_items[i].toppings, item.toppings)) {
        _items[i] = _items[i].copyWith(quantity: _items[i].quantity + 1);
        notifyListeners();
        return;
      }
    }
  }

  void decreaseQuantity(CartItem item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].name == item.name && _items[i].size == item.size && _isSameToppings(_items[i].toppings, item.toppings)) {
        var newQuantity = _items[i].quantity - 1;
        if (newQuantity <= 0) {
          _items.removeAt(i);
        } else {
          _items[i] = _items[i].copyWith(quantity: newQuantity);
        }
        notifyListeners();
        return;
      }
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool _isSameToppings(List<String> toppings1, List<String> toppings2) {
    if (toppings1.length != toppings2.length) return false;
    for (var topping in toppings1) {
      if (!toppings2.contains(topping)) return false;
    }
    return true;
  }
}
