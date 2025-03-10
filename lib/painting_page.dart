import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Painting Services
class PaintingService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final String priceUnit;

  PaintingService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    this.priceUnit = 'per room',
  });
}

// The Painting Page Widget
class PaintingPage extends StatefulWidget {
  const PaintingPage({Key? key}) : super(key: key);

  @override
  _PaintingPageState createState() => _PaintingPageState();
}

class _PaintingPageState extends State<PaintingPage> with SingleTickerProviderStateMixin {
  final Map<String, List<PaintingService>> _serviceCategories = {
    'Interior': [
      PaintingService(
        name: 'Wall Painting',
        description: 'Professional wall painting with premium paint',
        price: 299.99,
        icon: Icons.format_paint,
        imageUrl: 'assets/images/wall_painting.jpg',
      ),
      PaintingService(
        name: 'Ceiling Painting',
        description: 'Ceiling painting with anti-moisture formulations',
        price: 249.99,
        icon: Icons.wb_sunny_outlined,
        imageUrl: 'assets/images/ceiling_painting.jpg',
      ),
      PaintingService(
        name: 'Trim & Baseboards',
        description: 'Detailed painting of trim, baseboards, and moldings',
        price: 129.99,
        icon: Icons.border_style,
        imageUrl: 'assets/images/trim_painting.jpg',
        priceUnit: 'per room',
      ),
    ],
    'Exterior': [
      PaintingService(
        name: 'Exterior Walls',
        description: 'Weatherproof painting for home exterior',
        price: 3.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/exterior_painting.jpg',
        priceUnit: 'per sq ft',
      ),
      PaintingService(
        name: 'Door & Window Frames',
        description: 'Painting of exterior door and window frames',
        price: 79.99,
        icon: Icons.door_front_door_outlined,
        imageUrl: 'assets/images/door_painting.jpg',
        priceUnit: 'per unit',
      ),
      PaintingService(
        name: 'Deck & Fence Staining',
        description: 'Staining and sealing of wooden decks and fences',
        price: 2.49,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_staining.jpg',
        priceUnit: 'per sq ft',
      ),
    ],
    'Specialty': [
      PaintingService(
        name: 'Cabinet Refinishing',
        description: 'Sand, prime and paint kitchen or bathroom cabinets',
        price: 899.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/cabinet_painting.jpg',
        priceUnit: 'standard kitchen',
      ),
      PaintingService(
        name: 'Accent Wall',
        description: 'Create a stylish accent wall with color or texture',
        price: 199.99,
        icon: Icons.wallpaper_outlined,
        imageUrl: 'assets/images/accent_wall.jpg',
        priceUnit: 'per wall',
      ),
      PaintingService(
        name: 'Decorative Finishes',
        description: 'Faux finishes, textures, or decorative techniques',
        price: 5.99,
        icon: Icons.brush_outlined,
        imageUrl: 'assets/images/decorative_finish.jpg',
        priceUnit: 'per sq ft',
      ),
    ],
    'Prep Work': [
      PaintingService(
        name: 'Surface Preparation',
        description: 'Cleaning, sanding, and repairing surfaces',
        price: 149.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/surface_prep.jpg',
        priceUnit: 'per room',
      ),
      PaintingService(
        name: 'Wallpaper Removal',
        description: 'Removal of existing wallpaper and surface preparation',
        price: 2.99,
        icon: Icons.wallpaper,
        imageUrl: 'assets/images/wallpaper_removal.jpg',
        priceUnit: 'per sq ft',
      ),
      PaintingService(
        name: 'Drywall Repair',
        description: 'Patch holes and repair damaged drywall',
        price: 89.99,
        icon: Icons.build_outlined,
        imageUrl: 'assets/images/drywall_repair.jpg',
        priceUnit: 'per patch',
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

  // Painting specific properties
  String _selectedPaintQuality = 'Premium';
  String _selectedPaintFinish = 'Eggshell';
  bool _needsColorConsultation = false;
  bool _providingOwnPaint = false;
  int _numberOfRooms = 1;
  int _squareFootage = 500;
  String _roomSize = 'Medium';
  int _ceilingHeight = 8;

  // Dropdown options
  final List<String> _paintQualities = ['Economy', 'Standard', 'Premium', 'Designer'];
  final List<String> _paintFinishes = ['Flat', 'Eggshell', 'Satin', 'Semi-Gloss', 'High-Gloss'];
  final List<String> _roomSizes = ['Small', 'Medium', 'Large', 'Extra Large'];
  final Map<String, int> _roomSizeFootage = {
    'Small': 150,
    'Medium': 250,
    'Large': 400,
    'Extra Large': 600,
  };

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
    Map<String, int> unitServices = {};
    Map<String, int> roomServices = {};
    Map<String, int> wallServices = {};
    Map<String, int> patchServices = {};
    bool hasKitchenCabinets = false;

    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key) {
              switch (service.priceUnit) {
                case 'per sq ft':
                  sqFtServices[service.name] = service.price;
                  break;
                case 'per unit':
                  unitServices[service.name] = 0;
                  break;
                case 'per room':
                  roomServices[service.name] = service.price.toInt();
                  break;
                case 'per wall':
                  wallServices[service.name] = service.price.toInt();
                  break;
                case 'per patch':
                  patchServices[service.name] = service.price.toInt();
                  break;
                case 'standard kitchen':
                  hasKitchenCabinets = true;
                  total += service.price;
                  break;
              }
            }
          }
        }
      }
    });

    // Apply room calculations
    roomServices.forEach((name, price) {
      total += price * _numberOfRooms;
    });

    // Apply square footage calculations
    int calculatedSqFt = _squareFootage;
    if (_squareFootage == 0) {
      calculatedSqFt = _numberOfRooms * _roomSizeFootage[_roomSize]!;
    }

    sqFtServices.forEach((name, pricePerSqFt) {
      total += pricePerSqFt * calculatedSqFt;
    });

    // Apply wall calculations assuming 4 walls per room by default
    wallServices.forEach((name, price) {
      // User selects number of accent walls in UI
      total += price * 1; // Default to 1 accent wall
    });

    // Apply unit calculations based on UI inputs
    if (unitServices.containsKey('Door & Window Frames')) {
      // Assuming 1 door per room and 2 windows
      int units = _numberOfRooms + (_numberOfRooms * 2);
      total += 79.99 * units;
    }

    // Apply patch calculations (user specified in UI)
    if (patchServices.containsKey('Drywall Repair')) {
      // Default to 3 patches
      total += 89.99 * 3;
    }

    // Apply paint quality multiplier
    double qualityMultiplier = 1.0;
    switch (_selectedPaintQuality) {
      case 'Economy':
        qualityMultiplier = 0.85;
        break;
      case 'Standard':
        qualityMultiplier = 1.0;
        break;
      case 'Premium':
        qualityMultiplier = 1.25;
        break;
      case 'Designer':
        qualityMultiplier = 1.5;
        break;
    }

    // Don't apply quality multiplier if providing own paint
    if (!_providingOwnPaint) {
      total = total * qualityMultiplier;
    } else {
      // Discount if customer provides own paint
      total = total * 0.85;
    }

    // Add for color consultation
    if (_needsColorConsultation) {
      total += 75;
    }

    // Apply ceiling height adjustment
    if (_ceilingHeight > 8) {
      // Add 10% per foot over 8ft
      double heightFactor = 1.0 + ((_ceilingHeight - 8) * 0.1);
      total = total * heightFactor;
    }

    setState(() {
      _totalPrice = total;
    });
  }

  void _bookAppointment() {
    if (_selectedServices.values.every((value) => value == false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one painting service'),
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
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentStep = 0;
                _selectedServices.keys.forEach((key) {
                  _selectedServices[key] = false;
                });
                _numberOfRooms = 1;
                _roomSize = 'Medium';
                _ceilingHeight = 8;
                _providingOwnPaint = false;
                _needsColorConsultation = false;
                _totalPrice = 0;
                _showTotal = false;
              });
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painting Services'),
        backgroundColor: Colors.blue[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens_outlined),
            onPressed: _showPaintInfoDialog,
            tooltip: 'About Our Painting Services',
          ),
        ],
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
                    child: TextButton(
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
            title: const Text('Services'),
            content: _buildServicesSection(),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Project Details'),
            content: _buildProjectDetailsSection(),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Confirm'),
            content: _buildConfirmSection(),
            isActive: _currentStep >= 2,
            state: StepState.complete,
          ),
        ],
      ),
      bottomSheet: _showTotal
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }


  void _showPaintInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.color_lens, color: Colors.blue[700]),
            const SizedBox(width: 8),
            const Text('About Our Painting Services'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our professional painting services include thorough preparation, premium materials, and expert application.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Paint Quality Options:'),
            const SizedBox(height: 8),
            const Text('• Economy: Affordable coverage for rental properties'),
            const Text('• Standard: Good quality, washable paint for most homes'),
            const Text('• Premium: Durable, one-coat coverage with excellent finish'),
            const Text('• Designer: Top-tier brands with superior color depth and longevity'),
            const SizedBox(height: 16),
            const Text('Paint Finish Guide:'),
            const SizedBox(height: 8),
            const Text('• Flat: No shine, hides imperfections, for ceilings and low-traffic areas'),
            const Text('• Eggshell: Slight sheen, easy to clean, perfect for living areas'),
            const Text('• Satin: Velvet-like finish, highly washable, ideal for kids\' rooms'),
            const Text('• Semi-Gloss: Shiny finish, moisture-resistant, great for kitchens/baths'),
            const Text('• High-Gloss: Very shiny, highly durable, for trim and high-wear surfaces'),
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
                  'Select the painting services you need. Pricing varies based on size, paint quality, and finish.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
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
              List<PaintingService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  PaintingService service = services[index];
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
                              style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold
                              )
                          ),
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
    bool hasInteriorServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Interior']!
        .any((service) => service.name == entry.key));

    bool hasExteriorServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Exterior']!
        .any((service) => service.name == entry.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Specifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (hasInteriorServices) ...[
          const Text('Interior Project Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Room Size',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _roomSize,
                  items: _roomSizes.map((String size) {
                    return DropdownMenuItem<String>(
                      value: size,
                      child: Text(size),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _roomSize = newValue!;
                      _updateTotalPrice();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Number of Rooms',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _numberOfRooms.toString(),
                  onChanged: (value) {
                    setState(() {
                      _numberOfRooms = int.tryParse(value) ?? 1;
                      _updateTotalPrice();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Ceiling Height (feet)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            initialValue: _ceilingHeight.toString(),
            onChanged: (value) {
              setState(() {
                _ceilingHeight = int.tryParse(value) ?? 8;
                _updateTotalPrice();
              });
            },
          ),
        ],
        if (hasExteriorServices) ...[
          const SizedBox(height: 24),
          const Text('Exterior Project Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Square Footage (approx.)',
              border: OutlineInputBorder(),
              helperText: 'For exterior walls, deck or fence',
            ),
            keyboardType: TextInputType.number,
            initialValue: _squareFootage.toString(),
            onChanged: (value) {
              setState(() {
                _squareFootage = int.tryParse(value) ?? 500;
                _updateTotalPrice();
              });
            },
          ),
        ],
        const SizedBox(height: 24),
        const Text('Paint Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Paint Quality',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: _selectedPaintQuality,
                items: _paintQualities.map((String quality) {
                  return DropdownMenuItem<String>(
                    value: quality,
                    child: Text(quality),
                  );
                }).toList(),
                onChanged: !_providingOwnPaint ? (String? newValue) {
                  setState(() {
                    _selectedPaintQuality = newValue!;
                    _updateTotalPrice();
                  });
                } : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Paint Finish',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: _selectedPaintFinish,
                items: _paintFinishes.map((String finish) {
                  return DropdownMenuItem<String>(
                    value: finish,
                    child: Text(finish),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaintFinish = newValue!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Providing My Own Paint'),
          subtitle: const Text('15% discount on labor when you supply your own paint'),
          value: _providingOwnPaint,
          activeColor: Colors.blue,
          onChanged: (bool value) {
            setState(() {
              _providingOwnPaint = value;
              _updateTotalPrice();
            });
          },
        ),
        SwitchListTile(
          title: const Text('Need Color Consultation'),
          subtitle: const Text('Professional advice on color schemes (+\$75)'),
          value: _needsColorConsultation,
          activeColor: Colors.blue,
          onChanged: (bool value) {
            setState(() {
              _needsColorConsultation = value;
              _updateTotalPrice();
            });
          },
        ),
        const Divider(height: 32),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Preferred Start Date'),
          subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now().add(const Duration(days: 3)),
              lastDate: DateTime.now().add(const Duration(days: 60)),
            );
            if (picked != null) {
              setState(() {
                _selectedDate = picked;
              });
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Preferred Start Time'),
          subtitle: Text(_selectedTime.format(context)),
          onTap: () async {
            TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
            );
            if (picked != null) {
              setState(() {
                _selectedTime = picked;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Additional Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Notes',
            hintText: 'Specific paint colors, existing conditions, or special requests',
          ),
          maxLines: 3,
          onChanged: (value) {
            setState(() {
              _additionalNotes = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConfirmSection() {
    bool hasInteriorServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Interior']!
        .any((service) => service.name == entry.key));

    bool hasExteriorServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Exterior']!
        .any((service) => service.name == entry.key));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selected Services:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ..._selectedServices.entries
                      .where((entry) => entry.value)
                      .map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(child: Text(entry.key)),
                      ],
                    ),
                  ))
                      .toList(),
                  const Divider(height: 24),
                  if (hasInteriorServices) ...[
                    const Text('Interior Details:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Number of Rooms: $_numberOfRooms'),
                          Text('Room Size: $_roomSize'),
                          Text('Ceiling Height: $_ceilingHeight ft'),
                        ],
                      ),
                    ),
                  ],
                  if (hasExteriorServices) ...[
                    const Text('Exterior Details:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Square Footage: $_squareFootage sq ft'),
                        ],
                      ),
                    ),
                  ],
                  const Text('Paint Preferences:',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quality: $_selectedPaintQuality'),
                        Text('Finish: $_selectedPaintFinish'),
                        Text(_providingOwnPaint ? 'You will provide your own paint' : 'We will provide the paint'),
                        if (_needsColorConsultation)
                          const Text('Color consultation included'),
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  const Text('Schedule:',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}'),
                        Text('Time: ${_selectedTime.format(context)}'),
                      ],
                    ),
                  ),
                  if (_additionalNotes.isNotEmpty) ...[
                    const Text('Additional Notes:',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
                      child: Text(_additionalNotes),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price Breakdown:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (hasInteriorServices) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Interior Painting:'),
                        Text('\$${(_totalPrice * 0.6).toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                  if (hasExteriorServices) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Exterior Painting:'),
                        Text('\$${(_totalPrice * 0.4).toStringAsFixed(2)}'),
                      ],
                    ),
                  ],
                  if (_needsColorConsultation) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Color Consultation:'),
                        const Text('\$75.00'),
                      ],
                    ),
                  ],
                  if (_providingOwnPaint) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Customer Paint Discount:'),
                        const Text('-15%'),
                      ],
                    ),
                  ],
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimate:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${_totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Final price may vary based on actual conditions. Our painter will confirm upon inspection.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.format_paint_outlined, color: Colors.blue[700]),
            ),
            title: const Text('Our Painting Guarantee'),
            subtitle: const Text('We stand behind our work with a 2-year warranty on labor and materials'),
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.access_time, color: Colors.blue[700]),
            ),
            title: const Text('Project Timeline'),
            subtitle: Text(hasInteriorServices && _numberOfRooms > 3 ||
                hasExteriorServices && _squareFootage > 1000
                ? 'Estimated 3-5 days for completion'
                : 'Estimated 1-2 days for completion'),
          ),
        ]
    );
  }
}