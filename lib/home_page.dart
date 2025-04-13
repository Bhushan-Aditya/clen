import 'package:clen/painting_page.dart';
import 'package:clen/pest_control_page.dart';
import 'package:clen/plumbing_page.dart' show PlumbingPage;
import 'package:clen/waterproofing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cleaning_page.dart'; // Import the cleaning_page.dart file
import 'salon_spa_page.dart'; // Import the salon_spa_page.dart file
import 'electrician_page.dart';
import 'carpenter_page.dart';
import 'package:provider/provider.dart'; // Import provider
import 'cart_page.dart'; // Assuming you have a cart_page.dart
import 'providers/cart_provider.dart'; // Import CartProvider

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeBannerIndex = 0;
  final PageController _bannerController = PageController();
  String _searchQuery = ''; // Added search query state

  final List<Map<String, dynamic>> _promotions = [
    {
      'title': 'Summer Cleaning Sale',
      'subtitle': 'Get 30% off on deep cleaning services',
      'color': const Color(0xFF6366F1),
      'icon': Icons.cleaning_services,
    },
    {
      'title': 'Professional Plumbers',
      'subtitle': 'Book now and get same-day service',
      'color': const Color(0xFF0EA5E9),
      'icon': Icons.plumbing,
    },
    {
      'title': 'Home Renovation',
      'subtitle': 'Transform your home now from ₹6,999 only',
      'color': const Color(0xFFEC4899),
      'icon': Icons.home_work,
    },
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Cleaning',
      'icon': Icons.cleaning_services_rounded,
      'color': const Color(0xFF00B4D8),
      'gradient': [const Color(0xFF00B4D8), const Color(0xFF0077B6)],
    },
    {
      'name': 'Salon & Spa',
      'icon': Icons.spa_rounded,
      'color': const Color(0xFFEC4899),
      'gradient': [const Color(0xFFEC4899), const Color(0xFFBE123C)],
    },
    {
      'name': 'Electrician',
      'icon': Icons.electrical_services_rounded,
      'color': const Color(0xFFFBBF24),
      'gradient': [const Color(0xFFFBBF24), const Color(0xFFD97706)],
    },
    {
      'name': 'Plumbing',
      'icon': Icons.plumbing_rounded,
      'color': const Color(0xFF60A5FA),
      'gradient': [const Color(0xFF60A5FA), const Color(0xFF2563EB)],
    },
    {
      'name': 'Carpenter',
      'icon': Icons.handyman_rounded,
      'color': const Color(0xFFA78BFA),
      'gradient': [const Color(0xFFA78BFA), const Color(0xFF7C3AED)],
    },
    {
      'name': 'Painting',
      'icon': Icons.format_paint_rounded,
      'color': const Color(0xFFF87171),
      'gradient': [const Color(0xFFF87171), const Color(0xFFDC2626)],
    },
    {
      'name': 'Waterproofing',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF34D399),
      'gradient': [const Color(0xFF34D399), const Color(0xFF059669)],
    },
    {
      'name': 'Pest Control',
      'icon': Icons.pest_control_rounded,
      'color': const Color(0xFFFCD34D),
      'gradient': [const Color(0xFFFCD34D), const Color(0xFFD97706)],
    },
  ];

  final List<Map<String, dynamic>> _quickServices = [
    {
      'id': 'ac_repair_quick', // Added ID
      'name': 'AC Repair',
      'price': 399.0, // Price as double
      'rating': 4.8,
      'image': 'assets/ac_repair.jpg',
      'icon': Icons.ac_unit_rounded,
      'color': const Color(0xFF60A5FA),
      'serviceType': 'Quick Service', // Added serviceType
    },
    {
      'id': 'bathroom_cleaning_quick', // Added ID
      'name': 'Bathroom Cleaning',
      'price': 299.0, // Price as double
      'rating': 4.7,
      'image': 'assets/bathroom.jpg',
      'icon': Icons.bathroom_rounded,
      'color': const Color(0xFF34D399),
      'serviceType': 'Quick Service', // Added serviceType
    },
    {
      'id': 'furniture_assembly_quick', // Added ID
      'name': 'Furniture Assembly',
      'price': 599.0, // Price as double
      'rating': 4.9,
      'image': 'assets/furniture.jpg',
      'icon': Icons.chair_rounded,
      'color': const Color(0xFFA78BFA),
      'serviceType': 'Quick Service', // Added serviceType
    },
    {
      'id': 'electrical_wiring_quick', // Added ID
      'name': 'Electrical Wiring',
      'price': 499.0, // Price as double
      'rating': 4.8,
      'image': 'assets/wiring.jpg',
      'icon': Icons.cable_rounded,
      'color': const Color(0xFFFBBF24),
      'serviceType': 'Quick Service', // Added serviceType
    },
  ];

  final List<Map<String, dynamic>> _topRated = [
    {
      'id': 'luxury_home_cleaning_top_rated',  // Added ID
      'name': 'Luxury Home Cleaning and Deep Sanitization Service',
      'price': 1999.0,  // Price as double
      'rating': 4.9,
      'reviews': 345,
      'image': 'assets/luxury_cleaning.jpg',
      'time': '4 hrs',
      'icon': Icons.cleaning_services_rounded,
      'color': const Color(0xFF00B4D8),
      'serviceType': 'Top Rated', // Added serviceType
    },
    {
      'id': 'bathroom_renovation_top_rated', // Added ID
      'name': 'Bathroom Renovation',
      'price': 15999.0, // Price as double
      'rating': 4.8,
      'reviews': 213,
      'image': 'assets/bathroom_reno.jpg',
      'time': '3 days',
      'icon': Icons.bathroom_rounded,
      'color': const Color(0xFF0EA5E9),
      'serviceType': 'Top Rated', // Added serviceType
    },
    {
      'id': 'full_home_painting_top_rated', // Added ID
      'name': 'Full Home Painting',
      'price': 12999.0, // Price as double
      'rating': 4.9,
      'reviews': 189,
      'image': 'assets/home_painting.jpg',
      'time': '2 days',
      'icon': Icons.format_paint_rounded,
      'color': const Color(0xFFF87171),
      'serviceType': 'Top Rated', // Added serviceType
    },
  ];

  // Add to your _HomePageState class
  String _selectedLocation = 'Select Location';

  // Sample list of Chennai localities
  final List<String> _chennaiLocalities = [
    'Anna Nagar',
    'T. Nagar',
    'Adyar',
    'Velachery',
    'Tambaram',
    'Chromepet',
    'Porur',
    'Mylapore',
    'Nungambakkam',
    'Kodambakkam',
    'OMR',
    'ECR',
    'Guduvanchery',
    'Sholinganallur',
    'Pallikaranai',
    'Thoraipakkam',
    'Perungudi',
    'Perambur',
    'Vadapalani',
    'Guindy',
  ];

  // Function to show location selection modal
  void _showLocationSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search localities...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _chennaiLocalities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(_chennaiLocalities[index]),
                      onTap: () {
                        setState(() {
                          _selectedLocation = _chennaiLocalities[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Auto slide banner
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _startBannerAutoScroll();
      }
    });
  }

  void _startBannerAutoScroll() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        if (_activeBannerIndex < _promotions.length - 1) {
          setState(() {
            _activeBannerIndex++;
          });
        } else {
          setState(() {
            _activeBannerIndex = 0;
          });
        }
        _bannerController.animateToPage(
          _activeBannerIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startBannerAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    List<Map<String, dynamic>> _filteredQuickServices = _searchQuery.isEmpty
        ? _quickServices
        : _quickServices.where((service) => (service['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    List<Map<String, dynamic>> _filteredTopRatedServices = _searchQuery.isEmpty
        ? _topRated
        : _topRated.where((service) => (service['name'] as String).toLowerCase().contains(_searchQuery.toLowerCase())).toList();


    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.home_repair_service,
                      color: Theme.of(context).primaryColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ClenZo',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications_outlined, size: 26),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: const Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    // Show notifications
                  },
                ),
                Consumer<CartProvider>(
                  builder: (_, cart, __) => Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
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
                GestureDetector(
                  onTap: () => _showProfileOptions(context),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person_outline,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8), // Adjusted padding here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _showLocationSelector(context),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _selectedLocation,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            offset: const Offset(0, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search for services...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade600,
                          ),
                          suffixIcon: Icon(
                            Icons.mic,
                            color: Theme.of(context).primaryColor,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onChanged: (value) {  // Added onChanged callback
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220, // Increased height from 200
                child: PageView.builder(
                  controller: _bannerController,
                  onPageChanged: (index) {
                    setState(() {
                      _activeBannerIndex = index;
                    });
                  },
                  itemCount: _promotions.length,
                  itemBuilder: (context, index) {
                    final promotion = _promotions[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjusted horizontal padding here
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                promotion['color'] as Color,
                                (promotion['color'] as Color).withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -20,
                                bottom: -20,
                                child: Icon(
                                  promotion['icon'] as IconData,
                                  size: 150,
                                  color: Colors.white.withOpacity(0.15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16), // Reduced padding from 20
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        'LIMITED OFFER',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      promotion['title'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20, // Reduced font size from 22
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      promotion['subtitle'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13, // Reduced font size from 14
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: promotion['color'] as Color,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Book Now',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _promotions.length,
                        (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _activeBannerIndex == index
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 12, 8), // Adjusted padding here
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12), // Adjusted padding here
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    return GestureDetector(
                      onTap: () {
                        if (service['name'] == 'Cleaning') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CleaningPage()),
                          );
                        } else if (service['name'] == 'Salon & Spa') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SalonSpaPage()),
                          );
                        } else if (service['name'] == 'Electrician') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ElectricianPage()),
                          );
                        } else if (service['name'] == 'Plumbing') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PlumbingPage()),
                          );
                        } else if (service['name'] == 'Carpenter') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CarpentryPage()),
                          );
                        } else if (service['name'] == 'Painting') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaintingPage()),
                          );
                        } else if (service['name'] == 'Waterproofing') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const WaterproofingPage()),
                          );
                        } else if (service['name'] == 'Pest Control') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PestControlPage()),
                          );
                        } else {
                          print('${service['name']} service tapped');
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: service['gradient'] as List<Color>,
                              ),
                            ),
                            child: Icon(
                              service['icon'] as IconData,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            service['name'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 0), // Adjusted padding here
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).primaryColor,
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey.shade700,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(text: 'Quick Services'),
                          Tab(text: 'Top Rated'),
                          Tab(text: 'New Offers'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 300,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filteredQuickServices.length, // Use filtered list here
                            itemBuilder: (context, index) {
                              final service = _filteredQuickServices[index]; // Use filtered list here
                              return Container(
                                width: 190, // Reduced width here
                                margin: const EdgeInsets.only(right: 10), // Reduced right margin here
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Container(
                                        height: 120,
                                        color: (service['color'] as Color).withOpacity(0.2),
                                        child: Center(
                                          child: Icon(
                                            service['icon'] as IconData,
                                            size: 50,
                                            color: service['color'] as Color,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service['name'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '₹${service['price'].toStringAsFixed(0)}', // Display price from double
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(
                                                ' • 60 mins',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 16,
                                                color: Colors.amber,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${service['rating']} • 100+ bookings',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton.icon( // Changed to ElevatedButton.icon
                                            onPressed: () {
                                              final cart = Provider.of<CartProvider>(context, listen: false);
                                              cart.addItem(
                                                service['id'] as String,
                                                service['name'] as String,
                                                service['price'] as double,
                                                service['serviceType'] as String,
                                                service['image'] as String, // You may need to adjust image path
                                                service['icon'] as IconData,
                                                service['color'] as Color,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${service['name']} added to cart'),
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
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              minimumSize: const Size(double.infinity, 36),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white,), // Added icon
                                            label: const Text('Add to Cart', style: TextStyle(color: Colors.white)), // Changed text
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _filteredTopRatedServices.length, // Use filtered list here
                            itemBuilder: (context, index) {
                              final service = _filteredTopRatedServices[index]; // Use filtered list here
                              return Container(
                                width: 270, // Reduced width here
                                margin: const EdgeInsets.only(right: 10), // Reduced right margin here
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade200,
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                      child: Container(
                                        height: 140,
                                        color: (service['color'] as Color).withOpacity(0.2),
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: Icon(
                                                service['icon'] as IconData,
                                                size: 60,
                                                color: service['color'] as Color,
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.6),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.star,
                                                      size: 14,
                                                      color: Colors.amber,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${service['rating']}',
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' (${service['reviews']})',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            service['name'] as String,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '₹${service['price'].toStringAsFixed(0)}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.timer_outlined,
                                                    size: 14,
                                                    color: Colors.grey,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    service['time'] as String,
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton.icon( // Changed to ElevatedButton.icon
                                            onPressed: () {
                                              final cart = Provider.of<CartProvider>(context, listen: false);
                                              cart.addItem(
                                                service['id'] as String,
                                                service['name'] as String,
                                                service['price'] as double,
                                                service['serviceType'] as String,
                                                service['image'] as String, // You may need to adjust image path
                                                service['icon'] as IconData,
                                                service['color'] as Color,
                                              );
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('${service['name']} added to cart'),
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
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Theme.of(context).primaryColor,
                                              minimumSize: const Size(double.infinity, 36),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            icon: const Icon(Icons.add_shopping_cart, color: Colors.white,),  // Added icon
                                            label: const Text('Add to Cart', style: TextStyle(color: Colors.white)), // Changed text
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_offer_outlined,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'New offers coming soon!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 80),
            ),
          ],
        ),
      ),
      // BOTTOM NAVIGATION BAR REMOVED
    );
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person_outline,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                title: const Text('My Profile'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to profile page
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  child: const Icon(
                    Icons.history,
                    color: Colors.orange,
                  ),
                ),
                title: const Text('Order History'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to order history
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withOpacity(0.1),
                  child: const Icon(
                    Icons.settings_outlined,
                    color: Colors.green,
                  ),
                ),
                title: const Text('Settings'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to settings
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.withOpacity(0.1),
                  child: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                ),
                title: const Text('Logout'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  // Logout user
                },
              ),
            ],
          ),
        );
      },
    );
  }
}