import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CleaningService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;

  CleaningService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
  });
}

class CleaningPage extends StatefulWidget {
  const CleaningPage({Key? key}) : super(key: key);

  @override
  _CleaningPageState createState() => _CleaningPageState();
}

class _CleaningPageState extends State<CleaningPage> with SingleTickerProviderStateMixin {
  // Services categories
  final Map<String, List<CleaningService>> _serviceCategories = {
    'General Cleaning': [
      CleaningService(
        name: 'Regular Cleaning',
        description: 'Standard cleaning service for your home',
        price: 49.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/regular_cleaning.jpg',
      ),
      CleaningService(
        name: 'Deep Cleaning',
        description: 'Thorough cleaning of your entire home',
        price: 89.99,
        icon: Icons.home_work_outlined,
        imageUrl: 'assets/images/deep_cleaning.jpg',
      ),
    ],
    'Specialized Cleaning': [
      CleaningService(
        name: 'Kitchen Cleaning',
        description: 'Deep clean for your kitchen, including appliances',
        price: 59.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/kitchen_cleaning.jpg',
      ),
      CleaningService(
        name: 'Bathroom Cleaning',
        description: 'Sanitize and deep clean bathrooms',
        price: 49.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/bathroom_cleaning.jpg',
      ),
      CleaningService(
        name: 'Bedroom Cleaning',
        description: 'Dust-free and fresh bedrooms',
        price: 39.99,
        icon: Icons.bedroom_parent_outlined,
        imageUrl: 'assets/images/bedroom_cleaning.jpg',
      ),
    ],
    'Specific Items': [
      CleaningService(
        name: 'Window Cleaning',
        description: 'Crystal clear windows, inside and out',
        price: 39.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_cleaning.jpg',
      ),
      CleaningService(
        name: 'Carpet Cleaning',
        description: 'Deep stain removal and refreshing for carpets',
        price: 69.99,
        icon: Icons.cleaning_services_outlined, // Changed from carpet_outlined
        imageUrl: 'assets/images/carpet_cleaning.jpg',
      ),
      CleaningService(
        name: 'Chimney Cleaning',
        description: 'Thorough cleaning and maintenance of chimney',
        price: 99.99,
        icon: Icons.fireplace_outlined,
        imageUrl: 'assets/images/chimney_cleaning.jpg',
      ),
      CleaningService(
        name: 'Sofa/Upholstery Cleaning',
        description: 'Deep clean for sofas and furniture',
        price: 79.99,
        icon: Icons.chair_outlined,
        imageUrl: 'assets/images/sofa_cleaning.jpg',
      ),
    ],
    'Additional Services': [
      CleaningService(
        name: 'Refrigerator Cleaning',
        description: 'Inside-out cleaning of refrigerator',
        price: 29.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/fridge_cleaning.jpg',
      ),
      CleaningService(
        name: 'Oven/Stove Cleaning',
        description: 'Degreasing and deep cleaning of cooking appliances',
        price: 34.99,
        icon: Icons.microwave_outlined,
        imageUrl: 'assets/images/oven_cleaning.jpg',
      ),
      CleaningService(
        name: 'Post-Construction',
        description: 'Cleaning after renovation or construction',
        price: 149.99,
        icon: Icons.construction_outlined,
        imageUrl: 'assets/images/post_construction.jpg',
      ),
    ],
  };

  // Selected services
  final Map<String, bool> _selectedServices = {};
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _additionalNotes = '';
  double _totalPrice = 0;
  int _currentStep = 0;
  late TabController _tabController;
  bool _showTotal = false;

  @override
  void initState() {
    super.initState();
    // Initialize all services as unselected
    for (var category in _serviceCategories.entries) {
      for (var service in category.value) {
        _selectedServices[service.name] = false;
      }
    }
    _tabController = TabController(
      length: _serviceCategories.length,
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
    for (var category in _serviceCategories.entries) {
      for (var service in category.value) {
        if (_selectedServices[service.name] == true) {
          total += service.price;
        }
      }
    }
    setState(() {
      _totalPrice = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: const Color(0xFF4A90E2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A90E2),
          primary: const Color(0xFF4A90E2),
          secondary: const Color(0xFF50C878),
          background: const Color(0xFFF5F7FA),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF4A90E2),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Color(0xFF4A90E2),
          labelColor: Color(0xFF4A90E2),
          unselectedLabelColor: Color(0xFF757575),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF333333),
          elevation: 0,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Cleaning Services',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: () {
                _showHelpDialog();
              },
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
                if (_currentStep == 2) {
                  _showTotal = true;
                }
              });
            } else {
              _bookService();
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
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text(
                        _currentStep < 2 ? 'Continue' : 'Book Now',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4A90E2),
                          side: const BorderSide(color: Color(0xFF4A90E2)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: const Text('Services'),
              content: _buildServicesSection(),
              isActive: _currentStep >= 0,
              state: _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text('Schedule'),
              content: _buildScheduleSection(),
              isActive: _currentStep >= 1,
              state: _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
            ),
            Step(
              title: const Text('Confirm'),
              content: _buildConfirmSection(),
              isActive: _currentStep >= 2,
              state: _currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
            ),
          ],
        ),
        bottomSheet: _showTotal
            ? Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: \$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
            : null,
      ),
    );
  }

  Widget _buildServicesSection() {
    List<String> categories = _serviceCategories.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Select Services',
          'Choose the cleaning services you need',
          Icons.cleaning_services_outlined,
        ),
        const SizedBox(height: 20),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories
              .map((category) => Tab(
            text: category,
          ))
              .toList(),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: TabBarView(
            controller: _tabController,
            children: categories.map((category) {
              return ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                itemCount: _serviceCategories[category]!.length,
                itemBuilder: (context, index) {
                  final service = _serviceCategories[category]![index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedServices[service.name] =
                          !(_selectedServices[service.name] ?? false);
                          _updateTotalPrice();
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                service.icon,
                                color: const Color(0xFF4A90E2),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    service.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${service.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF4A90E2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Checkbox(
                              value: _selectedServices[service.name] ?? false,
                              onChanged: (value) {
                                setState(() {
                                  _selectedServices[service.name] = value!;
                                  _updateTotalPrice();
                                });
                              },
                              activeColor: const Color(0xFF4A90E2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Schedule Your Cleaning',
          'Select your preferred date and time',
          Icons.calendar_today,
        ),
        const SizedBox(height: 20),
        // Date selection
        Card(
          child: InkWell(
            onTap: _selectDate,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF4A90E2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('EEEE, MMM d, yyyy').format(_selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Time selection
        Card(
          child: InkWell(
            onTap: _selectTime,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Time',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF4A90E2),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Additional notes
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Additional Notes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Any special instructions or details we should know?',
                    contentPadding: EdgeInsets.all(16),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _additionalNotes = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmSection() {
    // Get selected services
    List<CleaningService> selectedServicesList = [];
    for (var category in _serviceCategories.entries) {
      for (var service in category.value) {
        if (_selectedServices[service.name] == true) {
          selectedServicesList.add(service);
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          'Review Your Booking',
          'Please confirm your cleaning request',
          Icons.check_circle_outline,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected Services',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (selectedServicesList.isEmpty)
                  const Text(
                    'No services selected. Please go back and select at least one service.',
                    style: TextStyle(color: Colors.red),
                  )
                else
                  ...selectedServicesList.map((service) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                service.icon,
                                size: 20,
                                color: const Color(0xFF4A90E2),
                              ),
                              const SizedBox(width: 8),
                              Text(service.name),
                            ],
                          ),
                          Text(
                            '\$${service.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Color(0xFF4A90E2),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Date: ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 20,
                      color: Color(0xFF4A90E2),
                    ),
                    const SizedBox(width: 8),
                    Text('Time: ${_selectedTime.format(context)}'),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_additionalNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Notes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_additionalNotes),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF4A90E2),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4A90E2),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            timePickerTheme: TimePickerThemeData(
              dayPeriodBorderSide: const BorderSide(
                color: Color(0xFF4A90E2),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _bookService() {
    // Get selected services
    List<String> selectedServices = [];
    for (var entry in _selectedServices.entries) {
      if (entry.value) {
        selectedServices.add(entry.key);
      }
    }

    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one service'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Here you would implement the API call to book the service
    // For now, just show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Color(0xFF50C878),
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('Booking Confirmed!'),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Your cleaning service has been scheduled for ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)} at ${_selectedTime.format(context)}',
            ),
            const SizedBox(height: 16),
            const Text(
              'Selected Services:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...selectedServices.map((service) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.check,
                    size: 16,
                    color: Color(0xFF50C878),
                  ),
                  const SizedBox(width: 4),
                  Text(service),
                ],
              ),
            )),
            const SizedBox(height: 16),
            Text(
              'Total Amount: \$${_totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Reset form or navigate back
              setState(() {
                _currentStep = 0;
                for (var key in _selectedServices.keys) {
                  _selectedServices[key] = false;
                }
                _additionalNotes = '';
                _totalPrice = 0;
                _showTotal = false;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4A90E2),
            ),
            child: const Text('Done'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(
              Icons.help_outline,
              color: Color(0xFF4A90E2),
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text('Cleaning Services Help'),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHelpSection(
              'Services Selection',
              'Browse and select the cleaning services you need. You can select multiple services.',
              Icons.cleaning_services_outlined,
            ),
            const SizedBox(height: 12),
            _buildHelpSection(
              'Scheduling',
              'Choose your preferred date and time for the cleaning service.',
              Icons.calendar_today,
            ),
            const SizedBox(height: 12),
            _buildHelpSection(
              'Special Instructions',
              'Add any specific requirements or notes for the cleaning team.',
              Icons.description_outlined,
            ),
            const SizedBox(height: 12),
            _buildHelpSection(
              'Confirmation',
              'Review your booking details before finalizing.',
              Icons.check_circle_outline,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF4A90E2),
            ),
            child: const Text('Got it'),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildHelpSection(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF4A90E2),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}