import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Unused import, can be removed

import 'cart_page.dart'; // Ensure this is correct
import 'providers/cart_provider.dart'; // Ensure this is correct
import 'models/cart_item.dart'; // Import CartItem model


// WaterproofingService model (Updated to match CleaningService model structure)
class WaterproofingService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color; // Added color to WaterproofingService model
  final String serviceType; // Added serviceType

  WaterproofingService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color, // Added color to constructor
    this.serviceType = 'Waterproofing', // Default serviceType
  });
}


// The Waterproofing Page Widget
class WaterproofingPage extends StatefulWidget {
  const WaterproofingPage({Key? key}) : super(key: key);

  @override
  _WaterproofingPageState createState() => _WaterproofingPageState();
}

class _WaterproofingPageState extends State<WaterproofingPage> {
  final Map<String, List<WaterproofingService>> _serviceCategories = {
    'Interior': [
      WaterproofingService(
        id: 'basement_waterproofing_interior',
        name: 'Basement Waterproofing',
        description: 'Complete interior basement waterproofing system',
        price: 12.99,
        icon: Icons.foundation,
        imageUrl: 'assets/images/basement_waterproofing.jpg',
        color: Colors.blue, // Example color
      ),
      WaterproofingService(
        id: 'bathroom_waterproofing_interior',
        name: 'Bathroom Waterproofing',
        description: 'Waterproofing for bathroom floors and walls',
        price: 8.99,
        icon: Icons.bathtub_outlined,
        imageUrl: 'assets/images/bathroom_waterproofing.jpg',
        color: Colors.teal, // Example color
      ),
      WaterproofingService(
        id: 'crawlspace_encapsulation_interior',
        name: 'Crawlspace Encapsulation',
        description: 'Complete moisture barrier for crawlspaces',
        price: 10.50,
        icon: Icons.home_work_outlined,
        imageUrl: 'assets/images/crawlspace_waterproofing.jpg',
        color: Colors.cyan, // Example color
      ),
    ],
    'Exterior': [
      WaterproofingService(
        id: 'foundation_waterproofing_exterior',
        name: 'Foundation Waterproofing',
        description: 'External foundation waterproofing and drainage',
        price: 18.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/foundation_waterproofing.jpg',
        color: Colors.green, // Example color
      ),
      WaterproofingService(
        id: 'roof_waterproofing_exterior',
        name: 'Roof Waterproofing',
        description: 'Waterproof coating for flat or low-slope roofs',
        price: 7.50,
        icon: Icons.roofing,
        imageUrl: 'assets/images/roof_waterproofing.jpg',
        color: Colors.lime, // Example color
      ),
      WaterproofingService(
        id: 'deck_waterproofing_exterior',
        name: 'Deck Waterproofing',
        description: 'Waterproof membrane for decks and balconies',
        price: 9.99,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_waterproofing.jpg',
        color: Colors.tealAccent, // Example color
      ),
    ],
    'Drainage': [
      WaterproofingService(
        id: 'french_drain_installation_drainage',
        name: 'French Drain Installation',
        description: 'Underground drainage system around foundation',
        price: 89.99,
        icon: Icons.waves_outlined,
        imageUrl: 'assets/images/french_drain.jpg',
        color: Colors.orange, // Example color
      ),
      WaterproofingService(
        id: 'sump_pump_installation_drainage',
        name: 'Sump Pump Installation',
        description: 'Sump pump system with battery backup',
        price: 1299.99,
        icon: Icons.invert_colors,
        imageUrl: 'assets/images/sump_pump.jpg',
        color: Colors.deepOrange, // Example color
      ),
      WaterproofingService(
        id: 'gutter_system_upgrade_drainage',
        name: 'Gutter System Upgrade',
        description: 'Enhanced gutter and downspout system',
        price: 12.99,
        icon: Icons.stream_outlined,
        imageUrl: 'assets/images/gutter_system.jpg',
        color: Colors.amber, // Example color
      ),
    ],
    'Repairs': [
      WaterproofingService(
        id: 'crack_injection_repairs',
        name: 'Crack Injection',
        description: 'Polyurethane or epoxy injection for foundation cracks',
        price: 39.99,
        icon: Icons.broken_image_outlined,
        imageUrl: 'assets/images/crack_injection.jpg',
        color: Colors.grey, // Example color
      ),
      WaterproofingService(
        id: 'mold_remediation_repairs',
        name: 'Mold Remediation',
        description: 'Professional mold removal and prevention',
        price: 5.99,
        icon: Icons.coronavirus_outlined,
        imageUrl: 'assets/images/mold_remediation.jpg',
        color: Colors.blueGrey, // Example color
      ),
      WaterproofingService(
        id: 'window_well_installation_repairs',
        name: 'Window Well Installation',
        description: 'Waterproof window well systems for basements',
        price: 279.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_well.jpg',
        color: Colors.brown, // Example color
      ),
    ],
  };

  List<WaterproofingService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Waterproofing Services'),
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