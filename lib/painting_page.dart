import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // Unused import, can be removed

import 'cart_page.dart'; // Ensure this is correct
import 'providers/cart_provider.dart'; // Ensure this is correct
import 'models/cart_item.dart'; // Import CartItem model


// CleaningService model (Moved to top-level, outside of state class) // Renamed to PaintingService to reflect file name and updated properties to match Painting Service
class PaintingService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color; // Added color to PaintingService
  final String serviceType;

  PaintingService({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    required this.color, // Added color to constructor
    this.serviceType = 'Painting', // Default serviceType
  });
}


// The Painting Page Widget
class PaintingPage extends StatefulWidget {
  const PaintingPage({Key? key}) : super(key: key);

  @override
  _PaintingPageState createState() => _PaintingPageState();
}

class _PaintingPageState extends State<PaintingPage> {
  final Map<String, List<PaintingService>> _serviceCategories = {
    'Interior': [
      PaintingService(
        id: 'wall_painting_interior',
        name: 'Wall Painting',
        description: 'Professional wall painting with premium paint',
        price: 299.99,
        icon: Icons.format_paint,
        imageUrl: 'assets/images/wall_painting.jpg',
        color: Colors.blue, // Example Color
      ),
      PaintingService(
        id: 'ceiling_painting_interior',
        name: 'Ceiling Painting',
        description: 'Ceiling painting with anti-moisture formulations',
        price: 249.99,
        icon: Icons.wb_sunny_outlined,
        imageUrl: 'assets/images/ceiling_painting.jpg',
        color: Colors.lightBlue, // Example Color
      ),
      PaintingService(
        id: 'trim_baseboards_interior',
        name: 'Trim & Baseboards',
        description: 'Detailed painting of trim, baseboards, and moldings',
        price: 129.99,
        icon: Icons.border_style,
        imageUrl: 'assets/images/trim_painting.jpg',
        color: Colors.cyan, // Example Color
      ),
    ],
    'Exterior': [
      PaintingService(
        id: 'exterior_walls_exterior',
        name: 'Exterior Walls',
        description: 'Weatherproof painting for home exterior',
        price: 3.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/exterior_painting.jpg',
        color: Colors.green, // Example Color
      ),
      PaintingService(
        id: 'door_window_frames_exterior',
        name: 'Door & Window Frames',
        description: 'Painting of exterior door and window frames',
        price: 79.99,
        icon: Icons.door_front_door_outlined,
        imageUrl: 'assets/images/door_painting.jpg',
        color: Colors.lime, // Example Color
      ),
      PaintingService(
        id: 'deck_fence_staining_exterior',
        name: 'Deck & Fence Staining',
        description: 'Staining and sealing of wooden decks and fences',
        price: 2.49,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_staining.jpg',
        color: Colors.tealAccent, // Example Color
      ),
    ],
    'Specialty': [
      PaintingService(
        id: 'cabinet_refinishing_specialty',
        name: 'Cabinet Refinishing',
        description: 'Sand, prime and paint kitchen or bathroom cabinets',
        price: 899.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/cabinet_painting.jpg',
        color: Colors.orange, // Example Color
      ),
      PaintingService(
        id: 'accent_wall_specialty',
        name: 'Accent Wall',
        description: 'Create a stylish accent wall with color or texture',
        price: 199.99,
        icon: Icons.wallpaper_outlined,
        imageUrl: 'assets/images/accent_wall.jpg',
        color: Colors.deepOrangeAccent, // Example Color
      ),
      PaintingService(
        id: 'decorative_finishes_specialty',
        name: 'Decorative Finishes',
        description: 'Faux finishes, textures, or decorative techniques',
        price: 5.99,
        icon: Icons.brush_outlined,
        imageUrl: 'assets/images/decorative_finish.jpg',
        color: Colors.amber, // Example Color
      ),
    ],
    'Prep Work': [
      PaintingService(
        id: 'surface_preparation_prep',
        name: 'Surface Preparation',
        description: 'Cleaning, sanding, and repairing surfaces',
        price: 149.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/surface_prep.jpg',
        color: Colors.grey, // Example Color
      ),
      PaintingService(
        id: 'wallpaper_removal_prep',
        name: 'Wallpaper Removal',
        description: 'Removal of existing wallpaper and surface preparation',
        price: 2.99,
        icon: Icons.wallpaper,
        imageUrl: 'assets/images/wallpaper_removal.jpg',
        color: Colors.blueGrey, // Example Color
      ),
      PaintingService(
        id: 'drywall_repair_prep',
        name: 'Drywall Repair',
        description: 'Patch holes and repair damaged drywall',
        price: 89.99,
        icon: Icons.build_outlined,
        imageUrl: 'assets/images/drywall_repair.jpg',
        color: Colors.brown, // Example Color
      ),
    ],
  };

  List<PaintingService> _allServices = [];

  @override
  void initState() {
    super.initState();
    _allServices = _serviceCategories.values.expand((list) => list).toList();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painting Services'),
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