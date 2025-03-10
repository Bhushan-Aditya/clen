import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


// Service model for Salon and Spa
class SalonService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;

  SalonService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
  });
}

// The Salon and Spa Page
class SalonSpaPage extends StatefulWidget { // Renamed from SalonAndSpaPage to SalonSpaPage to be consistent with navigation in HomePage
  const SalonSpaPage({Key? key}) : super(key: key);

  @override
  _SalonSpaPageState createState() => _SalonSpaPageState(); // Renamed from _SalonAndSpaPageState to _SalonSpaPageState
}

class _SalonSpaPageState extends State<SalonSpaPage> with SingleTickerProviderStateMixin { // Renamed from _SalonAndSpaPageState to _SalonSpaPageState
  final Map<String, List<SalonService>> _serviceCategories = {
    'Hair': [
      SalonService(
        name: 'Haircut',
        description: 'Professional haircut and styling',
        price: 24.99,
        icon: Icons.content_cut,
        imageUrl: 'assets/images/haircut.jpg',
      ),
      SalonService(
        name: 'Hair Coloring',
        description: 'Custom colors and highlights',
        price: 49.99,
        icon: Icons.brush,
        imageUrl: 'assets/images/hair_coloring.jpg',
      ),
      SalonService(
        name: 'Hair Treatment',
        description: 'Rejuvenation and repair for your hair',
        price: 34.99,
        icon: Icons.spa,
        imageUrl: 'assets/images/hair_treatment.jpg',
      ),
    ],
    'Face': [
      SalonService(
        name: 'Facial',
        description: 'Cleansing and rejuvenation for your skin',
        price: 39.99,
        icon: Icons.face,
        imageUrl: 'assets/images/facial.jpg',
      ),
      SalonService(
        name: 'Eyebrows',
        description: 'Eyebrow shaping and threading',
        price: 14.99,
        icon: Icons.architecture_outlined,
        imageUrl: 'assets/images/eyebrows.jpg',
      ),
    ],
    'Nails': [
      SalonService(
        name: 'Manicure',
        description: 'Complete nail care',
        price: 24.99,
        icon: Icons.handshake,
        imageUrl: 'assets/images/manicure.jpg',
      ),
      SalonService(
        name: 'Pedicure',
        description: 'Comfortable foot and nail care',
        price: 29.99,
        icon: FontAwesomeIcons.spa,
        imageUrl: 'assets/images/pedicure.jpg',
      ),
    ],
    'Spa': [
      SalonService(
        name: 'Massage Therapy',
        description: 'Relaxing and rejuvenating massage',
        price: 59.99,
        icon: Icons.self_improvement,
        imageUrl: 'assets/images/massage.jpg',
      ),
      SalonService(
        name: 'Body Scrub',
        description: 'Exfoliation and revitalization for your body',
        price: 49.99,
        icon: Icons.cleaning_services_outlined,
        imageUrl: 'assets/images/body_scrub.jpg',
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
            const Text('Your salon and spa appointment has been scheduled with the following details:'),
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
        title: const Text('Salon and Spa Services'),
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
              String category = entry.key;
              List<SalonService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  SalonService service = services[index];
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
          trailing: const Icon(Icons.arrow_forward_ios),
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
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.access_time),
          title: const Text('Appointment Time'),
          subtitle: Text(_selectedTime.format(context)),
          trailing: const Icon(Icons.arrow_forward_ios),
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
        const Text(
          'Selected Services:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._selectedServices.entries
            .where((entry) => entry.value)
            .map((entry) => Text('- ${entry.key}', style: const TextStyle(fontSize: 14)))
            .toList(),
        const Divider(height: 24),
        Text('Appointment Date: ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}'),
        Text('Appointment Time: ${_selectedTime.format(context)}'),
        const SizedBox(height: 16),
        Text(
          'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}