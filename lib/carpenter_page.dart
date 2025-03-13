import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Unused import, can be removed

import 'cart_page.dart'; // Ensure this is correct
import 'providers/cart_provider.dart'; // Ensure this is correct
import 'models/cart_item.dart'; // Import CartItem model


// CarpentryService model
class CarpentryService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color;
  final String serviceType;


  CarpentryService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color,
    this.serviceType = 'Carpentry', // Default serviceType
  });
}


// The Carpentry Page Widget
class CarpentryPage extends StatefulWidget {
  const CarpentryPage({Key? key}) : super(key: key);

  @override
  _CarpentryPageState createState() => _CarpentryPageState();
}

class _CarpentryPageState extends State<CarpentryPage> {
  // Services categories (Similar to CleaningPage structure)
  final Map<String, List<CarpentryService>> _serviceCategories = {
    'Furniture': [
      CarpentryService(
        id: 'furniture_repair_carpentry',
        name: 'Furniture Repair',
        description: 'Fix broken chairs, tables, and furniture',
        price: 89.99,
        icon: Icons.chair_outlined,
        imageUrl: 'assets/images/furniture_repair.jpg',
        color: Colors.brown.shade400,
      ),
      CarpentryService(
        id: 'furniture_assembly_carpentry',
        name: 'Furniture Assembly',
        description: 'Assemble flatpack or kit furniture',
        price: 79.99,
        icon: Icons.inventory_2_outlined,
        imageUrl: 'assets/images/furniture_assembly.jpg',
        color: Colors.brown.shade600,
      ),
      CarpentryService(
        id: 'custom_furniture_carpentry',
        name: 'Custom Furniture',
        description: 'Design and build custom furniture pieces',
        price: 299.99,
        icon: Icons.design_services,
        imageUrl: 'assets/images/custom_furniture.jpg',
        color: Colors.brown.shade800,
      ),
    ],
    'Home Improvements': [
      CarpentryService(
        id: 'door_installation_carpentry',
        name: 'Door Installation',
        description: 'Install new interior or exterior doors',
        price: 149.99,
        icon: Icons.door_sliding_outlined,
        imageUrl: 'assets/images/door_installation.jpg',
        color: Colors.deepOrange.shade300,
      ),
      CarpentryService(
        id: 'window_framing_carpentry',
        name: 'Window Framing',
        description: 'Frame new windows or repair frames',
        price: 179.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_framing.jpg',
        color: Colors.deepOrange.shade500,
      ),
      CarpentryService(
        id: 'crown_molding_carpentry',
        name: 'Crown Molding',
        description: 'Install decorative crown molding and trim',
        price: 129.99,
        icon: Icons.architecture,
        imageUrl: 'assets/images/crown_molding.jpg',
        color: Colors.deepOrange.shade700,
      ),
    ],
    'Cabinetry': [
      CarpentryService(
        id: 'kitchen_cabinets_carpentry',
        name: 'Kitchen Cabinets',
        description: 'Install or repair kitchen cabinets',
        price: 249.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/kitchen_cabinets.jpg',
        color: Colors.lime.shade400,
      ),
      CarpentryService(
        id: 'bathroom_vanities_carpentry',
        name: 'Bathroom Vanities',
        description: 'Bathroom vanity installation',
        price: 189.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/bathroom_vanity.jpg',
        color: Colors.lime.shade600,
      ),
      CarpentryService(
        id: 'built_in_shelving_carpentry',
        name: 'Built-in Shelving',
        description: 'Custom built-in bookshelves',
        price: 219.99,
        icon: Icons.shelves,
        imageUrl: 'assets/images/built_in_shelving.jpg',
        color: Colors.lime.shade800,
      ),
    ],
    'Structural Work': [
      CarpentryService(
        id: 'deck_construction_carpentry',
        name: 'Deck Construction',
        description: 'Build new outdoor decks',
        price: 799.99,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_construction.jpg',
        color: Colors.grey.shade500,
      ),
      CarpentryService(
        id: 'framing_carpentry',
        name: 'Framing',
        description: 'Structural framing for renovations',
        price: 599.99,
        icon: Icons.grid_on_outlined,
        imageUrl: 'assets/images/framing.jpg',
        color: Colors.grey.shade600,
      ),
      CarpentryService(
        id: 'staircase_construction_carpentry',
        name: 'Staircase Construction',
        description: 'Build or repair interior staircases',
        price: 699.99,
        icon: Icons.stairs_outlined,
        imageUrl: 'assets/images/staircase.jpg',
        color: Colors.grey.shade700,
      ),
    ],
  };

  List<CarpentryService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carpentry Services'),
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