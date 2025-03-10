import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Electrician Services
class ElectricianService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;

  ElectricianService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
  });
}

// The Electrician Page Widget
class ElectricianPage extends StatefulWidget {
  const ElectricianPage({Key? key}) : super(key: key);

  @override
  _ElectricianPageState createState() => _ElectricianPageState();
}

class _ElectricianPageState extends State<ElectricianPage> with SingleTickerProviderStateMixin {
  final Map<String, List<ElectricianService>> _serviceCategories = {
    'Wiring': [
      ElectricianService(
        name: 'New Wiring Installation',
        description: 'Professional setup of new electrical wiring',
        price: 149.99,
        icon: Icons.electrical_services,
        imageUrl: 'assets/images/wiring_installation.jpg',
      ),
      ElectricianService(
        name: 'Rewiring',
        description: 'Upgrade or repair old electrical wiring',
        price: 99.99,
        icon: Icons.build,
        imageUrl: 'assets/images/rewiring.jpg',
      ),
    ],
    'Appliance Repair': [
      ElectricianService(
        name: 'Air Conditioner Repair',
        description: 'Fix your AC for smooth performance',
        price: 79.99,
        icon: Icons.ac_unit,
        imageUrl: 'assets/images/ac_repair.jpg',
      ),
      ElectricianService(
        name: 'Refrigerator Repair',
        description: 'Solve cooling or malfunctioning issues',
        price: 89.99,
        icon: Icons.kitchen,
        imageUrl: 'assets/images/fridge_repair.jpg',
      ),
    ],
    'Lighting': [
      ElectricianService(
        name: 'Light Fixture Installation',
        description: 'Install new light fixtures safely',
        price: 49.99,
        icon: Icons.lightbulb_outline,
        imageUrl: 'assets/images/lighting_install.jpg',
      ),
      ElectricianService(
        name: 'Lighting Repair',
        description: 'Fix flickering or broken lights',
        price: 29.99,
        icon: Icons.wb_incandescent_outlined,
        imageUrl: 'assets/images/lighting_repair.jpg',
      ),
    ],
  };

  final Map<String, bool> _selectedServices = {};
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  String _additionalNotes = '';
  double _totalPrice = 0;
  int _currentStep = 0;
  late TabController _tabController;
  bool _showTotal = false;

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
    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key) {
              total += service.price;
            }
          }
        }
      }
    });
    setState(() {
      _totalPrice = total;
    });
  }

  void _bookAppointment() {
    if (_selectedServices.values.every((value) => value == false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one service before booking'),
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
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Your electrician appointment is successfully booked with these details:'),
            const SizedBox(height: 16),
            Text('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}'),
            Text('Time: ${_selectedTime.format(context)}'),
            const SizedBox(height: 16),
            const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._selectedServices.entries
                .where((entry) => entry.value)
                .map((entry) => Text('- ${entry.key}', style: const TextStyle(fontSize: 14)))
                .toList(),
            const SizedBox(height: 16),
            Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentStep = 0;
                _selectedServices.keys.forEach((key) {
                  _selectedServices[key] = false;
                });
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
        title: const Text('Electrician Services'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 2) {
            setState(() {
              _currentStep += 1;
              if (_currentStep == 2) _showTotal = true;
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
        steps: [
          Step(
            title: const Text('Services'),
            content: _buildServicesSection(),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text('Schedule'),
            content: _buildScheduleSection(),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text('Confirm'),
            content: _buildConfirmSection(),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    List<String> categories = _serviceCategories.keys.toList();
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 300,
          child: TabBarView(
            controller: _tabController,
            children: _serviceCategories.entries.map((entry) {
              List<ElectricianService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  ElectricianService service = services[index];
                  return Card(
                    child: CheckboxListTile(
                      title: Text(service.name),
                      subtitle: Text(service.description),
                      secondary: Icon(service.icon),
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

  Widget _buildScheduleSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Appointment Date'),
          subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
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
          title: const Text('Appointment Time'),
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
      ],
    );
  }

  Widget _buildConfirmSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._selectedServices.entries
            .where((entry) => entry.value)
            .map((entry) => Text('- ${entry.key}', style: const TextStyle(fontSize: 14)))
            .toList(),
        const Divider(height: 24),
        Text('Appointment Date: ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}'),
        Text('Appointment Time: ${_selectedTime.format(context)}'),
        const Divider(height: 24),
        Text(
          'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
