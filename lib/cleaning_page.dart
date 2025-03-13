import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'cart_page.dart'; // Ensure this is correct
import 'providers/cart_provider.dart'; // Ensure this is correct
import 'models/cart_item.dart'; // Import CartItem model


class CleaningPage extends StatefulWidget {
  const CleaningPage({Key? key}) : super(key: key);

  @override
  _CleaningPageState createState() => _CleaningPageState();
}

class _CleaningPageState extends State<CleaningPage> {
  // Services categories (Same as before, but now using CleaningService model)
  final Map<String, List<CleaningService>> _serviceCategories = {
    'General Cleaning': [
      CleaningService(
        name: 'Regular Cleaning',
        description: 'Standard cleaning service for your home',
        price: 49.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/regular_cleaning.jpg',
        id: 'regular_cleaning',
        color: Colors.blue,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Deep Cleaning',
        description: 'Thorough cleaning of your entire home',
        price: 89.99,
        icon: Icons.home_work_outlined,
        imageUrl: 'assets/images/deep_cleaning.jpg',
        id: 'deep_cleaning',
        color: Colors.teal,
        serviceType: 'Cleaning', // Added serviceType
      ),
    ],
    'Specialized Cleaning': [
      CleaningService(
        name: 'Kitchen Cleaning',
        description: 'Deep clean for your kitchen, including appliances',
        price: 59.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/kitchen_cleaning.jpg',
        id: 'kitchen_cleaning',
        color: Colors.orange,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Bathroom Cleaning',
        description: 'Sanitize and deep clean bathrooms',
        price: 49.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/bathroom_cleaning.jpg',
        id: 'bathroom_cleaning_specialized',
        color: Colors.green,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Bedroom Cleaning',
        description: 'Dust-free and fresh bedrooms',
        price: 39.99,
        icon: Icons.bedroom_parent_outlined,
        imageUrl: 'assets/images/bedroom_cleaning.jpg',
        id: 'bedroom_cleaning',
        color: Colors.purple,
        serviceType: 'Cleaning', // Added serviceType
      ),
    ],
    'Specific Items': [
      CleaningService(
        name: 'Window Cleaning',
        description: 'Crystal clear windows, inside and out',
        price: 39.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_cleaning.jpg',
        id: 'window_cleaning',
        color: Colors.cyan,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Carpet Cleaning',
        description: 'Deep stain removal and refreshing for carpets',
        price: 69.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/carpet_cleaning.jpg',
        id: 'carpet_cleaning',
        color: Colors.lime,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Chimney Cleaning',
        description: 'Thorough cleaning and maintenance of chimney',
        price: 99.99,
        icon: Icons.fireplace_outlined,
        imageUrl: 'assets/images/chimney_cleaning.jpg',
        id: 'chimney_cleaning',
        color: Colors.brown,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Sofa/Upholstery Cleaning',
        description: 'Deep clean for sofas and furniture',
        price: 79.99,
        icon: Icons.chair_outlined,
        imageUrl: 'assets/images/sofa_cleaning.jpg',
        id: 'sofa_cleaning',
        color: Colors.amber,
        serviceType: 'Cleaning', // Added serviceType
      ),
    ],
    'Additional Services': [
      CleaningService(
        name: 'Refrigerator Cleaning',
        description: 'Inside-out cleaning of refrigerator',
        price: 29.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/fridge_cleaning.jpg',
        id: 'refrigerator_cleaning',
        color: Colors.indigo,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Oven/Stove Cleaning',
        description: 'Degreasing and deep cleaning of cooking appliances',
        price: 34.99,
        icon: Icons.microwave_outlined,
        imageUrl: 'assets/images/oven_cleaning.jpg',
        id: 'oven_cleaning',
        color: Colors.deepOrange,
        serviceType: 'Cleaning', // Added serviceType
      ),
      CleaningService(
        name: 'Post-Construction',
        description: 'Cleaning after renovation or construction',
        price: 149.99,
        icon: Icons.construction_outlined,
        imageUrl: 'assets/images/post_construction.jpg',
        id: 'post_construction_cleaning',
        color: Colors.grey,
        serviceType: 'Cleaning', // Added serviceType
      ),
    ],
  };

  List<CleaningService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleaning Services'),
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
                              // Add to cart
                              final cart = Provider.of<CartProvider>(
                                  context,
                                  listen: false
                              );
                              cart.addItem( // Correct addItem call
                                  service.id,
                                  service.name,
                                  service.price,
                                  service.serviceType, // Pass serviceType
                                  service.imageUrl,    // Pass imageUrl
                                  service.icon,        // Pass icon
                                  service.color         // Pass color
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


// CleaningService model (Moved to top-level, outside of state class)
class CleaningService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color;
  final String serviceType; // Added serviceType to model


  CleaningService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color,
    required this.serviceType, // Initialize in constructor
  });
}