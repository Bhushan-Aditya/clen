import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Unused import, can be removed

import 'cart_page.dart'; // Ensure this is correct
import 'providers/cart_provider.dart'; // Ensure this is correct
import 'models/cart_item.dart'; // Import CartItem model


// PestControlService model (Updated to match CleaningService model)
class PestControlService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color;
  final String serviceType;


  PestControlService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color,
    this.serviceType = 'Pest Control', // Default serviceType
  });
}


// The Pest Control Page Widget
class PestControlPage extends StatefulWidget {
  const PestControlPage({Key? key}) : super(key: key);

  @override
  _PestControlPageState createState() => _PestControlPageState();
}

class _PestControlPageState extends State<PestControlPage> {
  // Services categories (Similar to CleaningPage structure)
  final Map<String, List<PestControlService>> _serviceCategories = {
    'Residential': [
      PestControlService(
        id: 'general_pest_control_residential',
        name: 'General Pest Control',
        description: 'Treatment for ants, roaches, and spiders',
        price: 149.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/general_pest_control.jpg',
        color: Colors.green.shade300,
      ),
      PestControlService(
        id: 'rodent_control_residential',
        name: 'Rodent Control',
        description: 'Treatment for mice and rats including trapping',
        price: 249.99,
        icon: Icons.pest_control_rodent_outlined,
        imageUrl: 'assets/images/rodent_control.jpg',
        color: Colors.green.shade500,
      ),
      PestControlService(
        id: 'bed_bug_treatment_residential',
        name: 'Bed Bug Treatment',
        description: 'Specialized treatment to eliminate bed bugs',
        price: 399.99,
        icon: Icons.bedroom_parent_outlined,
        imageUrl: 'assets/images/bed_bug_treatment.jpg',
        color: Colors.green.shade700,
      ),
    ],
    'Commercial': [
      PestControlService(
        id: 'restaurant_pest_management_commercial',
        name: 'Restaurant Pest Management',
        description: 'Pest control compliant for restaurants and cafes',
        price: 299.99,
        icon: Icons.restaurant_outlined,
        imageUrl: 'assets/images/restaurant_pest_control.jpg',
        color: Colors.lime.shade400,
      ),
      PestControlService(
        id: 'office_building_treatment_commercial',
        name: 'Office Building Treatment',
        description: 'Effective pest management for office environments',
        price: 249.99,
        icon: Icons.business_outlined,
        imageUrl: 'assets/images/office_pest_control.jpg',
        color: Colors.lime.shade600,
      ),
      PestControlService(
        id: 'warehouse_storage_protection_commercial',
        name: 'Warehouse & Storage Protection',
        description: 'Pest management for large storage facilities',
        price: 0.12,
        icon: Icons.warehouse_outlined,
        imageUrl: 'assets/images/warehouse_pest_control.jpg',
        color: Colors.lime.shade800,
      ),
    ],
    'Specialty': [
      PestControlService(
        id: 'termite_treatment_specialty',
        name: 'Termite Treatment',
        description: 'Termite colony elimination and prevention',
        price: 799.99,
        icon: Icons.pest_control_outlined,
        imageUrl: 'assets/images/termite_treatment.jpg',
        color: Colors.orange.shade400,
      ),
      PestControlService(
        id: 'mosquito_control_specialty',
        name: 'Mosquito Control',
        description: 'Yard treatment to reduce mosquito populations',
        price: 179.99,
        icon: Icons.coronavirus_outlined,
        imageUrl: 'assets/images/mosquito_control.jpg',
        color: Colors.orange.shade600,
      ),
      PestControlService(
        id: 'wildlife_removal_specialty',
        name: 'Wildlife Removal',
        description: 'Humane removal of wildlife and exclusion services',
        price: 349.99,
        icon: Icons.pets_outlined,
        imageUrl: 'assets/images/wildlife_removal.jpg',
        color: Colors.orange.shade800,
      ),
    ],
    'Prevention': [
      PestControlService(
        id: 'quarterly_protection_plan_prevention',
        name: 'Quarterly Protection Plan',
        description: 'Seasonal treatments every 3 months for protection',
        price: 399.99,
        icon: Icons.calendar_today_outlined,
        imageUrl: 'assets/images/quarterly_plan.jpg',
        color: Colors.amber.shade400,
      ),
      PestControlService(
        id: 'monthly_protection_plan_prevention',
        name: 'Monthly Protection Plan',
        description: 'Monthly treatments for ongoing pest management',
        price: 69.99,
        icon: Icons.repeat_outlined,
        imageUrl: 'assets/images/monthly_plan.jpg',
        color: Colors.amber.shade600,
      ),
      PestControlService(
        id: 'preventative_perimeter_defense_prevention',
        name: 'Preventative Perimeter Defense',
        description: 'Protective barrier to stop pests before entry',
        price: 249.99,
        icon: Icons.security_outlined,
        imageUrl: 'assets/images/perimeter_defense.jpg',
        color: Colors.amber.shade800,
      ),
    ],
  };

  List<PestControlService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Control Services'),
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