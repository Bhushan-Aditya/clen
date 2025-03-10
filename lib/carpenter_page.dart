import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Carpentry Services
class CarpentryService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final bool isCustomQuote;

  CarpentryService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    this.isCustomQuote = false,
  });
}

// The Carpentry Page Widget
class CarpentryPage extends StatefulWidget {
  const CarpentryPage({Key? key}) : super(key: key);

  @override
  _CarpentryPageState createState() => _CarpentryPageState();
}

class _CarpentryPageState extends State<CarpentryPage> with SingleTickerProviderStateMixin {
  final Map<String, List<CarpentryService>> _serviceCategories = {
    'Furniture': [
      CarpentryService(
        name: 'Furniture Repair',
        description: 'Fix broken chairs, tables, and other wooden furniture',
        price: 89.99,
        icon: Icons.chair_outlined,
        imageUrl: 'assets/images/furniture_repair.jpg',
      ),
      CarpentryService(
        name: 'Furniture Assembly',
        description: 'Professional assembly of flatpack or kit furniture',
        price: 79.99,
        icon: Icons.inventory_2_outlined,
        imageUrl: 'assets/images/furniture_assembly.jpg',
      ),
      CarpentryService(
        name: 'Custom Furniture',
        description: 'Design and build custom wooden furniture pieces',
        price: 299.99,
        icon: Icons.design_services,
        imageUrl: 'assets/images/custom_furniture.jpg',
        isCustomQuote: true,
      ),
    ],
    'Home Improvements': [
      CarpentryService(
        name: 'Door Installation',
        description: 'Remove old doors and install new ones',
        price: 149.99,
        icon: Icons.door_sliding_outlined,
        imageUrl: 'assets/images/door_installation.jpg',
      ),
      CarpentryService(
        name: 'Window Framing',
        description: 'Frame new windows or repair existing frames',
        price: 179.99,
        icon: Icons.window_outlined,
        imageUrl: 'assets/images/window_framing.jpg',
      ),
      CarpentryService(
        name: 'Crown Molding',
        description: 'Install decorative crown molding and trim',
        price: 129.99,
        icon: Icons.architecture,
        imageUrl: 'assets/images/crown_molding.jpg',
      ),
    ],
    'Cabinetry': [
      CarpentryService(
        name: 'Kitchen Cabinets',
        description: 'Install, repair or refinish kitchen cabinets',
        price: 249.99,
        icon: Icons.kitchen_outlined,
        imageUrl: 'assets/images/kitchen_cabinets.jpg',
      ),
      CarpentryService(
        name: 'Bathroom Vanities',
        description: 'Custom bathroom vanity installation',
        price: 189.99,
        icon: Icons.bathroom_outlined,
        imageUrl: 'assets/images/bathroom_vanity.jpg',
      ),
      CarpentryService(
        name: 'Built-in Shelving',
        description: 'Custom built-in bookshelves and storage solutions',
        price: 219.99,
        icon: Icons.shelves,
        imageUrl: 'assets/images/built_in_shelving.jpg',
        isCustomQuote: true,
      ),
    ],
    'Structural Work': [
      CarpentryService(
        name: 'Deck Construction',
        description: 'Build new outdoor decks or repair existing ones',
        price: 799.99,
        icon: Icons.deck_outlined,
        imageUrl: 'assets/images/deck_construction.jpg',
        isCustomQuote: true,
      ),
      CarpentryService(
        name: 'Framing',
        description: 'Structural framing for additions or renovations',
        price: 599.99,
        icon: Icons.grid_on_outlined,
        imageUrl: 'assets/images/framing.jpg',
        isCustomQuote: true,
      ),
      CarpentryService(
        name: 'Staircase Construction',
        description: 'Build or repair interior or exterior staircases',
        price: 699.99,
        icon: Icons.stairs_outlined,
        imageUrl: 'assets/images/staircase.jpg',
        isCustomQuote: true,
      ),
    ],
  };

  final Map<String, bool> _selectedServices = {};
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _additionalNotes = '';
  double _totalPrice = 0;
  int _currentStep = 0;
  late TabController _tabController;
  bool _showTotal = false;
  bool _needsMeasurements = false;
  String _projectScope = 'Small';

  final List<String> _projectScopes = ['Small', 'Medium', 'Large', 'Commercial'];
  final Map<String, String> _scopeDescriptions = {
    'Small': 'Single item or small repair (1-4 hours)',
    'Medium': 'Multiple items or medium project (1-2 days)',
    'Large': 'Room remodeling or extensive work (3+ days)',
    'Commercial': 'Business or commercial property work',
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
    bool hasCustomQuote = false;

    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key) {
              if (service.isCustomQuote) {
                hasCustomQuote = true;
              } else {
                total += service.price;
              }
            }
          }
        }
      }
    });

    setState(() {
      _totalPrice = total;

      // Apply project scope multiplier
      if (_projectScope == 'Medium' && !hasCustomQuote) {
        _totalPrice *= 1.15; // 15% increase for medium projects
      } else if (_projectScope == 'Large' && !hasCustomQuote) {
        _totalPrice *= 1.25; // 25% increase for large projects
      } else if (_projectScope == 'Commercial' && !hasCustomQuote) {
        _totalPrice *= 1.5; // 50% increase for commercial projects
      }

      // Add measurement fee if needed
      if (_needsMeasurements && !hasCustomQuote) {
        _totalPrice += 45; // $45 measurement fee
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

    bool hasCustomQuoteService = false;
    List<String> customQuoteServices = [];

    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key && service.isCustomQuote) {
              hasCustomQuoteService = true;
              customQuoteServices.add(service.name);
            }
          }
        }
      }
    });

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
            const Text('Your carpentry service appointment has been scheduled:'),
            const SizedBox(height: 16),
            Text('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}'),
            Text('Time: ${_selectedTime.format(context)}'),
            Text('Project Scope: $_projectScope'),
            if (_needsMeasurements)
              const Text('Pre-work measurements requested',
                  style: TextStyle(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._selectedServices.entries
                .where((entry) => entry.value)
                .map((entry) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                      entry.key,
                      style: TextStyle(
                          fontSize: 14,
                          fontStyle: customQuoteServices.contains(entry.key) ?
                          FontStyle.italic : FontStyle.normal
                      )
                  ),
                ),
              ],
            ))
                .toList(),
            const SizedBox(height: 16),
            if (_needsMeasurements)
              const Text('Measurement Fee: \$45.00'),
            if (hasCustomQuoteService)
              const Text(
                'Note: Services marked with * require an in-person assessment for final pricing.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
              ),
            const SizedBox(height: 8),
            hasCustomQuoteService
                ? const Text('Estimated Price: Price will be confirmed after assessment',
                style: TextStyle(fontWeight: FontWeight.bold))
                : Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('A professional carpenter will contact you to confirm details.'),
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
                _needsMeasurements = false;
                _projectScope = 'Small';
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
        title: const Text('Carpentry Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
            tooltip: 'About Our Carpentry Services',
          ),
        ],
      ),
      body: Stepper(
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
        steps: [
          Step(
            title: const Text('Services'),
            content: _buildServicesSection(),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text('Project Details'),
            content: _buildProjectDetailsSection(),
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

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.handyman, color: Colors.brown),
            SizedBox(width: 8),
            Text('About Our Carpentry Services'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Our skilled carpenters have 15+ years of experience in all aspects of woodworking and carpentry.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('What to expect:'),
            SizedBox(height: 8),
            Text('• Free initial consultation for all projects'),
            Text('• Licensed and insured professionals'),
            Text('• Quality materials and craftsmanship'),
            Text('• Clean work areas during and after completion'),
            SizedBox(height: 16),
            Text('For complex or custom projects, we provide detailed quotes after an in-person assessment.'),
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
            color: Colors.brown.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.handyman, color: Colors.brown[700]),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Select the carpentry services you need. Services marked with * require an in-person assessment for final pricing.',
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
          labelColor: Colors.brown[800],
          indicatorColor: Colors.brown,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 350,
          child: TabBarView(
            controller: _tabController,
            children: _serviceCategories.entries.map((entry) {
              List<CarpentryService> services = entry.value;
              return ListView.builder(
                itemCount: services.length,
                itemBuilder: (context, index) {
                  CarpentryService service = services[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: CheckboxListTile(
                      title: Row(
                        children: [
                          Text(service.name),
                          if (service.isCustomQuote)
                            const Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.description),
                          const SizedBox(height: 4),
                          service.isCustomQuote
                              ? const Text('Price: Custom quote required',
                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.red))
                              : Text('\$${service.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                  color: Colors.brown[700],
                                  fontWeight: FontWeight.bold
                              )
                          ),
                        ],
                      ),
                      secondary: Icon(service.icon, color: Colors.brown[600]),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Project Scope',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          value: _projectScope,
          items: _projectScopes.map((String scope) {
            return DropdownMenuItem<String>(
              value: scope,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(scope, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(
                    _scopeDescriptions[scope]!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _projectScope = newValue!;
              _updateTotalPrice();
            });
          },
        ),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Need pre-work measurements?'),
          subtitle: const Text(
            'We\'ll schedule a visit to take detailed measurements before starting work (+\$45)',
          ),
          value: _needsMeasurements,
          activeColor: Colors.brown,
          onChanged: (bool value) {
            setState(() {
              _needsMeasurements = value;
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
              firstDate: DateTime.now().add(const Duration(days: 2)),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              selectableDayPredicate: (DateTime date) {
                // Disable weekends for initial scheduling
                return date.weekday != DateTime.saturday &&
                    date.weekday != DateTime.sunday;
              },
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
              builder: (BuildContext context, Widget? child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: false,
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null) {
              setState(() {
                _selectedTime = picked;
              });
            }
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Project Details',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Additional Notes',
            hintText: 'Describe your project, materials preferences, or special requirements',
          ),
          maxLines: 4,
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
    bool hasCustomQuoteService = false;
    List<String> customQuoteServices = [];

    _selectedServices.forEach((key, value) {
      if (value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == key && service.isCustomQuote) {
              hasCustomQuoteService = true;
              customQuoteServices.add(service.name);
            }
          }
        }
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Service Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Project Scope: $_projectScope',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Appointment Date: ${DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)}'),
              Text('Appointment Time: ${_selectedTime.format(context)}'),
              if (_needsMeasurements)
                const Text('Pre-work measurements: Yes',
                    style: TextStyle(fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ..._selectedServices.entries
            .where((entry) => entry.value)
            .map((entry) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                  entry.key,
                  style: TextStyle(
                      fontSize: 14,
                      fontStyle: customQuoteServices.contains(entry.key) ?
                      FontStyle.italic : FontStyle.normal
                  )
              ),
            ),
          ],
        ))
            .toList(),
        if (_additionalNotes.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('Project Notes:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(_additionalNotes),
        ],
        const Divider(height: 32),
        if (_needsMeasurements)
          Text('Measurement Fee: \$45.00'), // Removed const here
        if (hasCustomQuoteService)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.amber),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your selection includes services that require an in-person assessment for final pricing. A carpenter will contact you to schedule this assessment.',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        hasCustomQuoteService
            ? const Text('Estimated Price: Price will be confirmed after assessment',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))
            : Text(
          'Total Price: \$${_totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ],
    );
  }
}