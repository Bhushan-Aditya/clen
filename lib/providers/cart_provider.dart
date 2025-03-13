import 'package:flutter/material.dart';
import '../models/cart_item.dart'; // Import CartItem model

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    for (var cartItem in _items) {
      total += cartItem.price * cartItem.quantity;
    }
    return total;
  }

  void addItem(String serviceId, String name, double price, String serviceType, String imageUrl, IconData icon, Color color) {
    final newItem = CartItem(
        id: serviceId,
        name: name,
        price: price,
        serviceType: serviceType,
        imageUrl: imageUrl,
        icon: icon,
        color: color);

    int existingIndex = _items.indexWhere((element) => element.id == serviceId);

    if (existingIndex >= 0) {
      // Item already exists, increase quantity
      _items[existingIndex].quantity++;
    } else {
      // Item does not exist, add new
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  // ADD THIS METHOD TO YOUR CART PROVIDER:
  void decrementItem(String itemId) {
    final existingIndex = _items.indexWhere((item) => item.id == itemId);
    if (existingIndex < 0) {
      return; // Item not found, nothing to decrement
    }
    if (_items[existingIndex].quantity > 1) {
      _items[existingIndex].quantity--; // Decrease quantity if more than 1
    } else {
      _items.removeAt(existingIndex); // Remove item if quantity becomes 1
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void updateQuantity(String id, int newQuantity) {
    int index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }
}