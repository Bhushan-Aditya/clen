import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart'; // Ensure CartItem import

// Service model for Plumbing Services - UPDATED with id, color, serviceType
class PlumbingService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color; // Added color
  final String serviceType; // Added serviceType


  PlumbingService({
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

// The Plumbing Page Widget
class PlumbingPage extends StatefulWidget {
  const PlumbingPage({Key? key}) : super(key: key);

  @override
  _PlumbingPageState createState() => _PlumbingPageState();
}

class _PlumbingPageState extends State<PlumbingPage> with SingleTickerProviderStateMixin {
  final Map<String, List<PlumbingService>> _serviceCategories = {
    'Repairs': [
      PlumbingService(
        id: 'faucet_repair_plumbing', // Added ID
        name: 'Leaky Faucet Repair',
        description: 'Fix dripping or leaking faucets',
        price: 69.99,
        icon: Icons.water_drop_outlined,
        imageUrl: 'assets/images/faucet_repair.jpg',
        color: Colors.blue.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'drain_clear_plumbing', // Added ID
        name: 'Clogged Drain Clearing',
        description: 'Remove blockages from drains',
        price: 79.99,
        icon: Icons.plumbing,
        imageUrl: 'assets/images/drain_clearing.jpg',
        color: Colors.teal.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'toilet_repair_plumbing', // Added ID
        name: 'Toilet Repair',
        description: 'Fix running or clogged toilets',
        price: 89.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/toilet_repair.jpg',
        color: Colors.brown.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
    ],
    'Installations': [
      PlumbingService(
        id: 'sink_install_plumbing', // Added ID
        name: 'Sink Installation',
        description: 'Install new kitchen or bathroom sinks',
        price: 149.99,
        icon: Icons.kitchen,
        imageUrl: 'assets/images/sink_install.jpg',
        color: Colors.grey.shade600, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'faucet_install_plumbing', // Added ID
        name: 'Faucet Installation',
        description: 'Install new faucets or fixtures',
        price: 99.99,
        icon: Icons.water,
        imageUrl: 'assets/images/faucet_install.jpg',
        color: Colors.cyan.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'water_heater_plumbing', // Added ID
        name: 'Water Heater Installation',
        description: 'Remove old and install new water heaters',
        price: 249.99,
        icon: Icons.hot_tub_outlined,
        imageUrl: 'assets/images/water_heater.jpg',
        color: Colors.deepOrange.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
    ],
    'Maintenance': [
      PlumbingService(
        id: 'drain_clean_plumbing', // Added ID
        name: 'Drain Cleaning',
        description: 'Thorough cleaning of drains to prevent clogs',
        price: 119.99,
        icon: Icons.cleaning_services,
        imageUrl: 'assets/images/drain_cleaning.jpg',
        color: Colors.green.shade400, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'pipe_inspect_plumbing', // Added ID
        name: 'Pipe Inspection',
        description: 'Camera inspection of pipes to identify issues',
        price: 129.99,
        icon: Icons.search,
        imageUrl: 'assets/images/pipe_inspection.jpg',
        color: Colors.lime.shade700, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
    ],
    'Emergency': [
      PlumbingService(
        id: 'leak_response_plumbing', // Added ID
        name: 'Emergency Leak Response',
        description: 'Immediate service for water leaks',
        price: 179.99,
        icon: Icons.emergency,
        imageUrl: 'assets/images/emergency_leak.jpg',
        color: Colors.red.shade700, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
      PlumbingService(
        id: 'burst_pipe_plumbing', // Added ID
        name: 'Burst Pipe Repair',
        description: 'Urgent repair for burst pipes',
        price: 199.99,
        icon: Icons.broken_image_outlined,
        imageUrl: 'assets/images/burst_pipe.jpg',
        color: Colors.red.shade900, // Added color
        serviceType: 'Plumbing', // Added serviceType
      ),
    ],
  };

  List<PlumbingService> _allServices = []; // Flattened service list


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
        title: const Text('Plumbing Services'),
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