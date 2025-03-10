import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Plumbing Services
class PlumbingService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;

  PlumbingService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
  });
}

// The Plumbing Page Widget
class PlumbingPage extends StatefulWidget {
  const PlumbingPage({Key? key}) : super(key: key);

  @override
  _PlumbingPageState createState() => _PlumbingPageState();
}

class _PlumbingPageState extends State<PlumbingPage> with SingleTickerProviderStateMixin {
  final Map<String, List<PlumbingService>> _serviceCategories = {
    'Repairs': [
      PlumbingService(
        name: 'Leaky Faucet Repair',
        description: 'Fix dripping or leaking faucets',
        price: 69.99,
        icon: Icons.water_drop_outlined,
        imageUrl: 'assets/images/faucet_repair.jpg',
      ),
      PlumbingService(
        name: 'Clogged Drain Clearing',
        description: 'Remove blockages from drains',
        price: 79.99,
        icon: Icons.plumbing,
        imageUrl: 'assets/images/drain_clearing.jpg',
      ),
      PlumbingService(
        name: 'Toilet Repair',
        description: 'Fix running or clogged toilets',
        price: 89.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/toilet_repair.jpg',
      ),
    ],
    'Installations': [
      PlumbingService(
        name: 'Sink Installation',
        description: 'Install new kitchen or bathroom sinks',
        price: 149.99,
        icon: Icons.kitchen,
        imageUrl: 'assets/images/sink_install.jpg',
      ),
      PlumbingService(
        name: 'Faucet Installation',
        description: 'Install new faucets or fixtures',
        price: 99.99,
        icon: Icons.water,
        imageUrl: 'assets/images/faucet_install.jpg',
      ),
      PlumbingService(
        name: 'Water Heater Installation',
        description: 'Remove old and install new water heaters',
        price: 249.99,
        icon: Icons.hot_tub_outlined,
        imageUrl: 'assets/images/water_heater.jpg',
      ),
    ],
    'Maintenance': [
      PlumbingService(
        name: 'Drain Cleaning',
        description: 'Thorough cleaning of drains to prevent clogs',
        price: 119.99,
        icon: Icons.cleaning_services,
        imageUrl: 'assets/images/drain_cleaning.jpg',
      ),
      PlumbingService(
        name: 'Pipe Inspection',
        description: 'Camera inspection of pipes to identify issues',
        price: 129.99,
        icon: Icons.search,
        imageUrl: 'assets/images/pipe_inspection.jpg',
      ),
    ],
    'Emergency': [
      PlumbingService(
        name: 'Emergency Leak Response',
        description: 'Immediate service for water leaks',
        price: 179.99,
        icon: Icons.emergency,
        imageUrl: 'assets/images/emergency_leak.jpg',
      ),
      PlumbingService(
        name: 'Burst Pipe Repair',
        description: 'Urgent repair for burst pipes',
        price: 199.99,
        icon: Icons.broken_image_outlined,
        imageUrl: 'assets/images/burst_pipe.jpg',
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
  bool _isEmergency = false;

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

  void _toggleEmergencyService(bool? value) {
    setState(() {
      _isEmergency = value ?? false;
      if (_isEmergency) {
        // Auto-select today's date for emergency services
        _selectedDate = DateTime.now();

        // Add emergency fee
        _totalPrice += 50.0;
      } else if (_totalPrice >= 50.0) {
        // Remove emergency fee if toggled off
        _totalPrice -= 50.0;
      }
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
            const Text('Your plumbing service appointment has been scheduled:'),
            const SizedBox(height: 16),
            Text('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}'),
            Text('Time: ${_selectedTime.format(context)}'),
            if (_isEmergency)
              const Text('Service Type: EMERGENCY (Priority Response)',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._selectedServices.entries
                .where((entry) => entry.value)
                .map((entry) => Text('- ${entry.key}', style: const TextStyle(fontSize: 14)))
                .toList(),
            const SizedBox(height: 16),
            if (_isEmergency)
              const Text('Emergency Service Fee: \$50.00', // Corrected line: changed \\$ to \$
                  style: TextStyle(color: Colors.red)),
            Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('A professional plumber will contact you shortly to confirm the details.'),
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
                _isEmergency = false;
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
        title: const Text('Plumbing Services'),
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
        // Emergency Service Toggle
        SwitchListTile(
          title: const Text('Emergency Service Needed?'),
          subtitle: const Text('Additional \$50 fee for urgent same-day service'),
          secondary: const Icon(Icons.warning_amber_rounded, color: Colors.red),
          value: _isEmergency,
          onChanged: _toggleEmergencyService,
        ),
        const Divider(),
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
              List<PlumbingService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  PlumbingService service = services[index];
                  return Card(
                    child: CheckboxListTile(
                      title: Text(service.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.description),
                          const SizedBox(height: 4),
                          Text('\$${service.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ],
                      ),
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
        if (_isEmergency)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Row(
              children: const [
                Icon(Icons.priority_high, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Emergency service will be dispatched today with priority. A plumber will contact you shortly after booking.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ListTile(
          enabled: !_isEmergency,
          leading: const Icon(Icons.calendar_today),
          title: const Text('Appointment Date'),
          subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
          onTap: _isEmergency ? null : () async {
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
          title: const Text('Preferred Time'),
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
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Additional Notes',
            hintText: 'Describe your plumbing issue or provide special instructions',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isEmergency)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Row(
              children: const [
                Icon(Icons.priority_high, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'EMERGENCY SERVICE',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._selectedServices.entries
            .where((entry) => entry.value)
            .map((entry) => Text('- ${entry.key}', style: const TextStyle(fontSize: 14)))
            .toList(),
        const Divider(height: 24),
        Text('Appointment Date: ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}'),
        Text('Appointment Time: ${_selectedTime.format(context)}'),
        if (_additionalNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Additional Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_additionalNotes),
        ],
        const Divider(height: 24),
        if (_isEmergency)
          const Text('Emergency Service Fee: \$50.00', // Corrected line: changed \\$ to \$
              style: TextStyle(color: Colors.red)),
        Text(
          'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}