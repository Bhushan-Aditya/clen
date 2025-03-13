import 'package:flutter/material.dart';

class CartItem {
  final String id; // Unique ID for each cart item
  final String name;
  final double price;
  int quantity;
  final String serviceType; // Add serviceType
  final String imageUrl;   // Add imageUrl
  final IconData icon;     // Add icon
  final Color color;       // Add color

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.serviceType, // Initialize serviceType
    required this.imageUrl,    // Initialize imageUrl
    required this.icon,        // Initialize icon
    required this.color,        // Initialize color
  });
}