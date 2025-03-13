import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'providers/cart_provider.dart'; // Import CartProvider
import 'models/cart_item.dart'; // Import CartItem

// Service model for Salon and Spa - Updated with id, color, serviceType
class SalonService {
  final String id;
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final Color color; // Added color
  final String serviceType; // Added serviceType

  SalonService({
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

// The Salon and Spa Page
class SalonSpaPage extends StatefulWidget {
  const SalonSpaPage({Key? key}) : super(key: key);

  @override
  _SalonSpaPageState createState() => _SalonSpaPageState();
}

class _SalonSpaPageState extends State<SalonSpaPage> with SingleTickerProviderStateMixin {
  final Map<String, List<SalonService>> _serviceCategories = {
    'Hair': [
      SalonService(
        id: 'haircut_salon', // Added ID
        name: 'Haircut',
        description: 'Professional haircut and styling',
        price: 24.99,
        icon: Icons.content_cut,
        imageUrl: 'assets/images/haircut.jpg',
        color: Colors.pink.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
      SalonService(
        id: 'hair_coloring_salon', // Added ID
        name: 'Hair Coloring',
        description: 'Custom colors and highlights',
        price: 49.99,
        icon: Icons.brush,
        imageUrl: 'assets/images/hair_coloring.jpg',
        color: Colors.orange.shade400, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
      SalonService(
        id: 'hair_treatment_salon', // Added ID
        name: 'Hair Treatment',
        description: 'Rejuvenation and repair for your hair',
        price: 34.99,
        icon: Icons.spa,
        imageUrl: 'assets/images/hair_treatment.jpg',
        color: Colors.green.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
    ],
    'Face': [
      SalonService(
        id: 'facial_salon', // Added ID
        name: 'Facial',
        description: 'Cleansing and rejuvenation for your skin',
        price: 39.99,
        icon: Icons.face,
        imageUrl: 'assets/images/facial.jpg',
        color: Colors.purple.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
      SalonService(
        id: 'eyebrows_salon', // Added ID
        name: 'Eyebrows',
        description: 'Eyebrow shaping and threading',
        price: 14.99,
        icon: Icons.architecture_outlined,
        imageUrl: 'assets/images/eyebrows.jpg',
        color: Colors.teal.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
    ],
    'Nails': [
      SalonService(
        id: 'manicure_salon', // Added ID
        name: 'Manicure',
        description: 'Complete nail care',
        price: 24.99,
        icon: Icons.handshake,
        imageUrl: 'assets/images/manicure.jpg',
        color: Colors.amber.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
      SalonService(
        id: 'pedicure_salon', // Added ID
        name: 'Pedicure',
        description: 'Comfortable foot and nail care',
        price: 29.99,
        icon: FontAwesomeIcons.spa,
        imageUrl: 'assets/images/pedicure.jpg',
        color: Colors.cyan.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
    ],
    'Spa': [
      SalonService(
        id: 'massage_salon', // Added ID
        name: 'Massage Therapy',
        description: 'Relaxing and rejuvenating massage',
        price: 59.99,
        icon: Icons.self_improvement,
        imageUrl: 'assets/images/massage.jpg',
        color: Colors.blue.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
      SalonService(
        id: 'body_scrub_salon', // Added ID
        name: 'Body Scrub',
        description: 'Exfoliation and revitalization for your body',
        price: 49.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/body_scrub.jpg',
        color: Colors.deepOrange.shade300, // Added color
        serviceType: 'Salon & Spa', // Added serviceType
      ),
    ],
  };

  List<SalonService> _allServices = []; // Flattened service list

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
        title: const Text('Salon & Spa Services'),
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
                                service.color,
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