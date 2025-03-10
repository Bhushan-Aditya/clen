import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Waterproofing Services
class WaterproofingService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final String priceUnit;

  WaterproofingService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    this.priceUnit = 'per sq ft',
  });
}

// The Waterproofing Page Widget
class WaterproofingPage extends StatefulWidget {
  const WaterproofingPage({Key? key}) : super(key: key);

  @override
  _WaterproofingPageState createState() => _WaterproofingPageState();
}

class _WaterproofingPageState extends State<WaterproofingPage> with SingleTickerProviderStateMixin {
  final Map<String, List<WaterproofingService>> _serviceCategories = {
    'Interior': [
      WaterproofingService(
        name: 'Basement Waterproofing',
        description: 'Complete interior basement waterproofing system',
        price: 12.99,
        icon: Icons.foundation,
        imageUrl: 'assets/images/basement_waterproofing.jpg',
      ),
      WaterproofingService(
        name: 'Bathroom Waterproofing',
        description: 'Waterproofing for bathroom floors and walls',
        price: 8.99,
        icon: Icons.bathtub_outlined,
        imageUrl: 'assets/images/bathroom_waterproofing.jpg',
      ),
      WaterproofingService(
        name: 'Crawlspace Encapsulation',
        description: 'Complete moisture barrier for crawlspaces',
        price: 10.50,
        icon: Icons.home_work_outlined,
        imageUrl: 'assets/images/crawlspace_waterproofing.jpg',
      ),
    ],
    'Exterior': [
      WaterproofingService(
        name: 'Foundation Waterproofing',
        description: 'External foundation waterproofing and drainage',
        price: 18.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/foundation_waterproofing.jpg',
      ),
      WaterproofingService(
        name: 'Roof Waterproofing',
        description: 'Waterproof coating for flat or low-slope roofs',
        price: 7.50,
        icon: Icons.roofing,
        imageUrl: 'assets/images/roof_waterproofing.jpg',
      ),
      WaterproofingService(
        name: 'Deck Waterproofing',
        description: 'Waterproof membrane for decks and balconies',
        price: 9.99,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_waterproofing.jpg',
      ),
    ],
    'Drainage': [
      WaterproofingService(
        name: 'French Drain Installation',
        description: 'Underground drainage system around foundation',
        price: 89.99,
        icon: Icons.waves_outlined,
        imageUrl: 'assets/images/french_drain.jpg',
        priceUnit: 'per linear ft',
      ),
      WaterproofingService(
        name: 'Sump Pump Installation',
        description: 'Sump pump system with battery backup',
        price: 1299.99,
        icon: Icons.invert_colors,
        imageUrl: 'assets/images/sump_pump.jpg',
        priceUnit: 'per system',
      ),
      WaterproofingService(
        name: 'Gutter System Upgrade',
        description: 'Enhanced gutter and downspout system',
        price: 12.99,
        icon: Icons.stream_outlined,
        imageUrl: 'assets/images/gutter_system.jpg',
        priceUnit: 'per linear ft',
      ),
    ],
    'Repairs': [
      WaterproofingService(
        name: 'Crack Injection',
        description: 'Polyurethane or epoxy injection for foundation cracks',
        price: 39.99,
        icon: Icons.broken_image_outlined,
        imageUrl: 'assets/images/crack_injection.jpg',
        priceUnit: 'per linear ft',
      ),
      WaterproofingService(
        name: 'Mold Remediation',
        description: 'Professional mold removal and prevention',
        price: 5.99,
        icon: Icons.coronavirus_outlined,
        imageUrl: 'assets/images/mold_remediation.jpg',
      ),
      WaterproofingService(
        name: 'Window Well Installation',
        description: 'Waterproof window well systems for basements',
        price: 279.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_well.jpg',
        priceUnit: 'per window',
      ),
    ],
  };

  final Map<String, bool> _selectedServices = {};
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 5));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  String _additionalNotes = '';
  double _totalPrice = 0;
  int _currentStep = 0;
  late TabController _tabController;
  bool _showTotal = false;

  // Waterproofing specific properties
  String _selectedWaterproofingGrade = 'Standard';
  bool _needsInspection = true;
  bool _hasExistingWaterDamage = false;
  int _squareFootage = 500;
  int _linearFootage = 100;
  int _areaDepth = 8;
  bool _needsDrainage = false;
  bool _isEmergency = false;
  String _waterproofingType = 'Preventative';

  // Dropdown options
  final List<String> _waterproofingGrades = ['Economy', 'Standard', 'Premium', 'Commercial Grade'];
  final List<String> _waterproofingTypes = ['Preventative', 'Remedial', 'Emergency'];

  @override
  void initState() {
    super.initState();

    for (var category in _serviceCategories.values) {
      for (var service in category) {
        _selectedServices[service.name] = false;
      }
    }

    _tabController = TabController(
      length: _serviceCategories.keys.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTotalPrice() {
    double total = 0;
    Map<String, double> sqFtServices = {};
    Map<String, double> linearFtServices = {};
    Map<String, double> unitServices = {};

    // Inspection fee (waived if service purchased)
    double inspectionFee = _needsInspection ? 149.99 : 0.0;

    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key) {
              switch (service.priceUnit) {
                case 'per sq ft':
                  sqFtServices[service.name] = service.price;
                  break;
                case 'per linear ft':
                  linearFtServices[service.name] = service.price;
                  break;
                case 'per system':
                case 'per window':
                  unitServices[service.name] = service.price;
                  break;
              }
            }
          }
        }
      }
    });

    // Apply square footage calculations
    sqFtServices.forEach((name, pricePerSqFt) {
      total += pricePerSqFt * _squareFootage;
    });

    // Apply linear footage calculations
    linearFtServices.forEach((name, pricePerLinearFt) {
      total += pricePerLinearFt * _linearFootage;
    });

    // Apply unit calculations
    unitServices.forEach((name, price) {
      if (name == 'Window Well Installation') {
        // Assume number of windows is calculated elsewhere or is fixed
        total += price * 2; // Default to 2 windows
      } else {
        total += price;
      }
    });

    // Apply waterproofing grade multiplier
    double gradeMultiplier = 1.0;
    switch (_selectedWaterproofingGrade) {
      case 'Economy':
        gradeMultiplier = 0.8;
        break;
      case 'Standard':
        gradeMultiplier = 1.0;
        break;
      case 'Premium':
        gradeMultiplier = 1.3;
        break;
      case 'Commercial Grade':
        gradeMultiplier = 1.5;
        break;
    }

    total = total * gradeMultiplier;

    // Apply water damage multiplier
    if (_hasExistingWaterDamage) {
      total *= 1.25; // 25% additional for existing damage remediation
    }

    // Apply drainage surcharge if needed
    if (_needsDrainage && !_selectedServices.containsKey('French Drain Installation') &&
        !_selectedServices.containsKey('Sump Pump Installation')) {
      total += 750; // Basic drainage solution
    }

    // Apply emergency surcharge
    if (_isEmergency) {
      total *= 1.4; // 40% premium for emergency service
    }

    // Apply area depth adjustment
    if (_areaDepth > 8) {
      // Add 5% per foot over 8ft
      double depthFactor = 1.0 + ((_areaDepth - 8) * 0.05);
      total = total * depthFactor;
    }

    // Add inspection fee if needed
    total += inspectionFee;

    setState(() {
      _totalPrice = total;
      _showTotal = true;
    });
  }

  void _bookAppointment() {
    if (_selectedServices.values.every((value) => value == false) && !_needsInspection) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one waterproofing service or inspection'),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('Booking Confirmed!'),
          ],
        ),
        content: _buildConfirmSection(), // Replaced with _buildConfirmSection widget tree
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waterproofing Services'),
        backgroundColor: Colors.blue[700],
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
              if (_currentStep == 2) _showTotal = true;
              _updateTotalPrice();
            });
          } else {
            _bookAppointment();
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
              _showTotal = false;
            });
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(_currentStep == 2 ? 'Book Now' : 'Continue'),
                  ),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('Select Services'),
            content: _buildServicesSection(),
            isActive: _currentStep >= 0,
          ),
          Step(
            title: const Text('Project Details'),
            content: _buildProjectDetailsSection(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Confirm Details'),
            content: _buildConfirmSection(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
      bottomSheet: _showTotal
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('\$${_totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[800])),
            ],
          ),
        ),
      )
          : null,
    );
  }


  void _showWaterproofingInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.water_damage, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text('About Our Waterproofing Services'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our waterproofing services protect your property from water damage through professional installation and high-quality materials.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Waterproofing Grade Options:'),
            const SizedBox(height: 8),
            const Text('• Economy: Basic protection for low-risk areas'),
            const Text('• Standard: Comprehensive solution for most residential needs'),
            const Text('• Premium: Enhanced protection with extended warranty'),
            const Text('• Commercial Grade: Industrial-strength solutions for maximum protection'),
            const SizedBox(height: 16),
            const Text('Service Types:'),
            const SizedBox(height: 8),
            const Text('• Preventative: Proactive waterproofing before problems occur'),
            const Text('• Remedial: Addressing existing moisture issues and preventing recurrence'),
            const Text('• Emergency: Rapid response to active water intrusion'),
            const SizedBox(height: 16),
            const Text('All services include:'),
            const SizedBox(height: 8),
            const Text('• Detailed inspection and moisture assessment'),
            const Text('• Written report with recommendations'),
            const Text('• Professional installation by certified technicians'),
            const Text('• Quality materials with manufacturer warranties'),
            const Text('• Follow-up inspection to ensure effectiveness'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    List<String> categories = _serviceCategories.keys.toList();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue[700]),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Select the waterproofing services you need. Pricing varies based on area size, material grade, and existing conditions.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              TextButton(
                onPressed: _showWaterproofingInfoDialog,
                child: const Text('Learn More'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('I need a professional inspection first'),
          subtitle: const Text('Comprehensive moisture assessment (\$149.99, waived with service purchase)'),
          value: _needsInspection,
          activeColor: Colors.blue,
          onChanged: (bool value) {
            setState(() {
              _needsInspection = value;
              _updateTotalPrice();
            });
          },
        ),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
          labelColor: Colors.blue[800],
          indicatorColor: Colors.blue,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 350,
          child: TabBarView(
            controller: _tabController,
            children: _serviceCategories.entries.map((entry) {
              List<WaterproofingService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  WaterproofingService service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: CheckboxListTile(
                      title: Text(service.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.description),
                          const SizedBox(height: 4),
                          Text('\$${service.price.toStringAsFixed(2)} ${service.priceUnit}',
                              style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                        ],
                      ),
                      secondary: Icon(service.icon, color: Colors.blue[600]),
                      value: _selectedServices[service.name],
                      onChanged: (bool? selected) {
                        setState(() {
                          _selectedServices[service.name] = selected!;
                          _updateTotalPrice();
                        });
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectDetailsSection() {
    return const Center(child: Text("content"));
  }

  Widget _buildConfirmSection() {
    return const Center(child: Text("confirm section"));
  }
}