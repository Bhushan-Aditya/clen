import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart'; // Ensure CartItem import is present


// Service model for Electrician Services - UPDATED with id, color, serviceType
class ElectricianService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color; // Added color
  final String serviceType; // Added serviceType

  ElectricianService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color, // Initialize color
    required this.serviceType, // Initialize serviceType
  });
}

// The Electrician Page Widget
class ElectricianPage extends StatefulWidget {
  const ElectricianPage({Key? key}) : super(key: key);

  @override
  _ElectricianPageState createState() => _ElectricianPageState();
}

class _ElectricianPageState extends State<ElectricianPage> with SingleTickerProviderStateMixin {
  final Map<String, List<ElectricianService>> _serviceCategories = {
    'Wiring': [
      ElectricianService(
        id: 'new_wiring_electrician', // Added ID
        name: 'New Wiring Installation',
        description: 'Professional setup of new electrical wiring',
        price: 149.99,
        icon: Icons.electrical_services,
        imageUrl: 'assets/images/wiring_installation.jpg',
        color: Colors.yellow.shade700, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
      ElectricianService(
        id: 'rewiring_electrician', // Added ID
        name: 'Rewiring',
        description: 'Upgrade or repair old electrical wiring',
        price: 99.99,
        icon: Icons.build,
        imageUrl: 'assets/images/rewiring.jpg',
        color: Colors.orange.shade700, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
    ],
    'Appliance Repair': [
      ElectricianService(
        id: 'ac_repair_electrician', // Added ID
        name: 'Air Conditioner Repair',
        description: 'Fix your AC for smooth performance',
        price: 79.99,
        icon: Icons.ac_unit,
        imageUrl: 'assets/images/ac_repair.jpg',
        color: Colors.lightBlue.shade400, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
      ElectricianService(
        id: 'fridge_repair_electrician', // Added ID
        name: 'Refrigerator Repair',
        description: 'Solve cooling or malfunctioning issues',
        price: 89.99,
        icon: Icons.kitchen,
        imageUrl: 'assets/images/fridge_repair.jpg',
        color: Colors.blueGrey.shade400, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
    ],
    'Lighting': [
      ElectricianService(
        id: 'light_install_electrician', // Added ID
        name: 'Light Fixture Installation',
        description: 'Install new light fixtures safely',
        price: 49.99,
        icon: Icons.lightbulb_outline,
        imageUrl: 'assets/images/lighting_install.jpg',
        color: Colors.lime.shade600, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
      ElectricianService(
        id: 'light_repair_electrician', // Added ID
        name: 'Lighting Repair',
        description: 'Fix flickering or broken lights',
        price: 29.99,
        icon: Icons.wb_incandescent_outlined,
        imageUrl: 'assets/images/lighting_repair.jpg',
        color: Colors.yellow.shade400, // Added color
        serviceType: 'Electrician', // Added serviceType
      ),
    ],
  };

  List<ElectricianService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrician Services'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  },
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _allServices.length,
        itemBuilder: (context, index) {
          final service = _allServices[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: service.color.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      service.icon,
                      size: 70,
                      color: service.color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '₹${service.price}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              final cart = Provider.of<CartProvider>(
                                  context,
                                  listen: false
                              );
                              cart.addItem(
                                  service.id,
                                  service.name,
                                  service.price,
                                  service.serviceType,
                                  service.imageUrl,
                                  service.icon,
                                  service.color
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${service.name} added to cart'),
                                  duration: const Duration(seconds: 2),
                                  action: SnackBarAction(
                                    label: 'VIEW CART',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const CartPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Add to Cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}