import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Service model for Pest Control Services
class PestControlService {
  final String name;
  final String description;
  final double price;
  final IconData icon;
  final String imageUrl;
  final String priceUnit;
  final List<String> targetPests;

  PestControlService({
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.imageUrl,
    this.priceUnit = 'per treatment',
    required this.targetPests,
  });
}

// The Pest Control Page Widget
class PestControlPage extends StatefulWidget {
  const PestControlPage({Key? key}) : super(key: key);

  @override
  _PestControlPageState createState() => _PestControlPageState();
}

class _PestControlPageState extends State<PestControlPage> with SingleTickerProviderStateMixin {
  final Map<String, List<PestControlService>> _serviceCategories = {
    'Residential': [
      PestControlService(
        name: 'General Pest Control',
        description: 'Treatment for common household pests like ants, roaches, and spiders',
        price: 149.99,
        icon: Icons.home_outlined,
        imageUrl: 'assets/images/general_pest_control.jpg',
        targetPests: ['Ants', 'Cockroaches', 'Spiders', 'Silverfish', 'Earwigs'],
      ),
      PestControlService(
        name: 'Rodent Control',
        description: 'Comprehensive treatment for mice and rats including trapping and exclusion',
        price: 249.99,
        icon: Icons.pest_control_rodent_outlined,
        imageUrl: 'assets/images/rodent_control.jpg',
        targetPests: ['Mice', 'Rats', 'Voles'],
      ),
      PestControlService(
        name: 'Bed Bug Treatment',
        description: 'Specialized treatment to eliminate bed bugs completely',
        price: 399.99,
        icon: Icons.bedroom_parent_outlined,
        imageUrl: 'assets/images/bed_bug_treatment.jpg',
        targetPests: ['Bed Bugs'],
      ),
    ],
    'Commercial': [
      PestControlService(
        name: 'Restaurant Pest Management',
        description: 'Food safety compliant pest control for restaurants and cafes',
        price: 299.99,
        icon: Icons.restaurant_outlined,
        imageUrl: 'assets/images/restaurant_pest_control.jpg',
        targetPests: ['Cockroaches', 'Rodents', 'Flies', 'Stored Product Pests'],
      ),
      PestControlService(
        name: 'Office Building Treatment',
        description: 'Discreet and effective pest management for office environments',
        price: 249.99,
        icon: Icons.business_outlined,
        imageUrl: 'assets/images/office_pest_control.jpg',
        targetPests: ['Ants', 'Spiders', 'Rodents', 'Occasional Invaders'],
      ),
      PestControlService(
        name: 'Warehouse & Storage Protection',
        description: 'Pest management for large storage facilities and warehouses',
        price: 0.12,
        icon: Icons.warehouse_outlined,
        imageUrl: 'assets/images/warehouse_pest_control.jpg',
        priceUnit: 'per sq ft',
        targetPests: ['Rodents', 'Stored Product Pests', 'Cockroaches', 'Birds'],
      ),
    ],
    'Specialty': [
      PestControlService(
        name: 'Termite Treatment',
        description: 'Complete termite colony elimination and prevention',
        price: 799.99,
        icon: Icons.pest_control_outlined,
        imageUrl: 'assets/images/termite_treatment.jpg',
        targetPests: ['Subterranean Termites', 'Drywood Termites', 'Formosan Termites'],
      ),
      PestControlService(
        name: 'Mosquito Control',
        description: 'Yard treatment to reduce mosquito populations',
        price: 179.99,
        icon: Icons.coronavirus_outlined,
        imageUrl: 'assets/images/mosquito_control.jpg',
        targetPests: ['Mosquitoes', 'Ticks', 'Outdoor Flies'],
      ),
      PestControlService(
        name: 'Wildlife Removal',
        description: 'Humane removal of wildlife and exclusion services',
        price: 349.99,
        icon: Icons.pets_outlined,
        imageUrl: 'assets/images/wildlife_removal.jpg',
        targetPests: ['Raccoons', 'Squirrels', 'Opossums', 'Bats', 'Birds'],
      ),
    ],
    'Prevention': [
      PestControlService(
        name: 'Quarterly Protection Plan',
        description: 'Seasonal treatments every 3 months for year-round protection',
        price: 399.99,
        icon: Icons.calendar_today_outlined,
        imageUrl: 'assets/images/quarterly_plan.jpg',
        priceUnit: 'per year',
        targetPests: ['Ants', 'Spiders', 'Cockroaches', 'Rodents', 'Seasonal Pests'],
      ),
      PestControlService(
        name: 'Monthly Protection Plan',
        description: 'Monthly treatments for ongoing pest management',
        price: 69.99,
        icon: Icons.repeat_outlined,
        imageUrl: 'assets/images/monthly_plan.jpg',
        priceUnit: 'per month',
        targetPests: ['All Common Pests', 'Seasonal Invaders'],
      ),
      PestControlService(
        name: 'Preventative Perimeter Defense',
        description: 'Protective barrier around your property to stop pests before they enter',
        price: 249.99,
        icon: Icons.security_outlined,
        imageUrl: 'assets/images/perimeter_defense.jpg',
        targetPests: ['Ants', 'Spiders', 'Centipedes', 'Crickets', 'Outdoor Invaders'],
      ),
    ],
  };

  final Map<String, bool> _selectedServices = {};
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _additionalNotes = '';
  double _totalPrice = 0;
  int _currentStep = 0;
  late TabController _tabController;
  bool _showTotal = false;

  // Pest control specific properties
  String _selectedTreatmentType = 'Standard';
  String _infestationLevel = 'Moderate';
  int _propertySize = 2000;
  bool _hasPets = false;
  bool _hasChildren = false;
  bool _needsEmergencyService = false;
  bool _needsInspection = true;
  String _pestType = 'Multiple';
  bool _isRecurringService = false;
  int _recurringFrequency = 3; // months
  int _treatmentCount = 1;
  bool _needsPetSafeTreatment = false;

  // Dropdown options
  final List<String> _treatmentTypes = ['Eco-Friendly', 'Standard', 'Heavy-Duty', 'Heat Treatment'];
  final List<String> _infestationLevels = ['Minor', 'Moderate', 'Severe', 'Infestation'];
  final List<String> _pestTypes = ['Ants', 'Cockroaches', 'Rodents', 'Termites', 'Bed Bugs', 'Mosquitoes', 'Wildlife', 'Multiple'];
  final List<int> _frequencyOptions = [1, 2, 3, 6, 12]; // months

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

    // Inspection fee (waived if service purchased)
    double inspectionFee = _needsInspection ? 79.99 : 0.0;

    // Calculate base service costs
    for (var entry in _selectedServices.entries) {
      if (entry.value) {
        for (var category in _serviceCategories.values) {
          for (var service in category) {
            if (service.name == entry.key) {
              if (service.priceUnit == 'per sq ft') {
                total += service.price * _propertySize;
              } else if (service.priceUnit == 'per year' || service.priceUnit == 'per month') {
                total += service.price; // Subscription handled separately
              } else {
                total += service.price;
              }
              // If any service is selected, inspection fee is waived
              inspectionFee = 0.0;
            }
          }
        }
      }
    }

    // Apply treatment type multiplier
    double treatmentMultiplier = 1.0;
    switch (_selectedTreatmentType) {
      case 'Eco-Friendly':
        treatmentMultiplier = 1.25;
        break;
      case 'Standard':
        treatmentMultiplier = 1.0;
        break;
      case 'Heavy-Duty':
        treatmentMultiplier = 1.4;
        break;
      case 'Heat Treatment':
        treatmentMultiplier = 1.6;
        break;
    }

    total = total * treatmentMultiplier;

    // Apply infestation level multiplier
    double infestationMultiplier = 1.0;
    switch (_infestationLevel) {
      case 'Minor':
        infestationMultiplier = 0.85;
        break;
      case 'Moderate':
        infestationMultiplier = 1.0;
        break;
      case 'Severe':
        infestationMultiplier = 1.3;
        break;
      case 'Infestation':
        infestationMultiplier = 1.5;
        break;
    }

    total = total * infestationMultiplier;

    // Apply pet-safe treatment surcharge if needed
    if (_needsPetSafeTreatment && _hasPets) {
      total *= 1.15; // 15% additional for pet-safe treatments
    }

    // Apply emergency service surcharge
    if (_needsEmergencyService) {
      total *= 1.5; // 50% premium for emergency service
    }

    // Apply property size adjustment for residential services
    if (_selectedServices['General Pest Control'] == true ||
        _selectedServices['Preventative Perimeter Defense'] == true) {
      if (_propertySize > 3000) {
        // Add 10% per 1000 sq ft over 3000
        double sizeFactor = 1.0 + ((_propertySize - 3000) / 1000 * 0.1);
        total = total * sizeFactor;
      }
    }

    // Multiple treatment discount
    if (_treatmentCount > 1 && !_isRecurringService) {
      double discount = 1.0 - ((_treatmentCount - 1) * 0.05); // 5% off per additional treatment, up to 20%
      discount = discount < 0.8 ? 0.8 : discount; // Cap at 20% discount
      total = total * _treatmentCount * discount;
    }

    // Recurring service discount (applied to applicable services)
    if (_isRecurringService) {
      bool hasRecurringEligibleService = _selectedServices['General Pest Control'] == true ||
          _selectedServices['Mosquito Control'] == true ||
          _selectedServices['Preventative Perimeter Defense'] == true;

      if (hasRecurringEligibleService) {
        int treatmentsPerYear = 12 ~/ _recurringFrequency;
        double yearlyRate = total * treatmentsPerYear * 0.8; // 20% discount for recurring
        // We're showing monthly pricing
        total = yearlyRate / 12;
      }
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
          content: Text('Please select at least one pest control service or inspection'),
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
            const Text('Your pest control service has been scheduled:'),
            const SizedBox(height: 16),
            Text('Date: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)}'),
            Text('Time: ${_selectedTime.format(context)}'),
            const SizedBox(height: 16),
            const Text('A pest control specialist will contact you to confirm your appointment.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('I need a pest inspection first'),
          subtitle: const Text('Professional evaluation to identify pests and recommend treatment (\$79.99, waived with service)'),
          value: _needsInspection,
          activeColor: Colors.green[700],
          onChanged: (bool value) {
            setState(() {
              _needsInspection = value;
            });
          },
        ),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.green[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.green[700],
          tabs: _serviceCategories.keys.map((category) => Tab(text: category)).toList(),
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: _serviceCategories.keys.map((category) {
              return ListView.builder(
                itemCount: _serviceCategories[category]!.length,
                itemBuilder: (context, index) {
                  final service = _serviceCategories[category]![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(service.icon, color: Colors.green[700]),
                          const SizedBox(width: 8),
                          Text(service.name),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.description),
                          const SizedBox(height: 4),
                          Text(
                            'Targets: ${service.targetPests.join(", ")}',
                            style: TextStyle(color: Colors.grey[700], fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '\$${service.price.toStringAsFixed(2)} ',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[700], fontSize: 14),
                                ),
                                TextSpan(
                                  text: service.priceUnit,
                                  style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      value: _selectedServices[service.name] ?? false,
                      activeColor: Colors.green[700],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectedServices[service.name] = value!;

                          // Auto-select inspection if bed bugs or termites are selected
                          if ((service.name == 'Bed Bug Treatment' || service.name == 'Termite Treatment') && value) {
                            _needsInspection = true;
                          }

                          // Auto-set recurring if subscription plans are selected
                          if ((service.name == 'Quarterly Protection Plan' || service.name == 'Monthly Protection Plan') && value) {
                            _isRecurringService = true;
                            _recurringFrequency = service.name == 'Monthly Protection Plan' ? 1 : 3;
                          }

                          // Auto-set pest type
                          if (value && _pestType == 'Multiple' && service.targetPests.length == 1) {
                            _pestType = service.targetPests.first;
                          }
                        });
                      },
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedServices.values.any((v) => v)) ...[
          const Divider(),
          SwitchListTile(
            title: const Text('Schedule Recurring Service'),
            subtitle: const Text('Save up to 20% with regular scheduled treatments'),
            value: _isRecurringService,
            activeColor: Colors.green[700],
            onChanged: (bool value) {
              setState(() {
                _isRecurringService = value;
                if (!value) {
                  // Deselect subscription plans if recurring is turned off
                  _selectedServices['Quarterly Protection Plan'] = false;
                  _selectedServices['Monthly Protection Plan'] = false;
                }
              });
            },
          ),

          if (_isRecurringService) ...[
            const SizedBox(height: 8),
            const Text('Treatment Frequency:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _frequencyOptions.map((months) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(months == 1 ? 'Monthly' : months == 12 ? 'Yearly' : 'Every $months months'),
                    selected: _recurringFrequency == months,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() {
                          _recurringFrequency = months;
                        });
                      }
                    },
                    selectedColor: Colors.green[100],
                    labelStyle: TextStyle(
                      color: _recurringFrequency == months ? Colors.green[700] : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Number of Treatments: '),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _treatmentCount,
                  items: [1, 2, 3, 4, 5].map((count) {
                    return DropdownMenuItem<int>(
                      value: count,
                      child: Text('$count ${count == 1 ? 'treatment' : 'treatments'}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _treatmentCount = value!;
                    });
                  },
                ),
              ],
            ),
            if (_treatmentCount > 1) ...[
              const SizedBox(height: 8),
              Text(
                'Multi-treatment discount: ${(_treatmentCount - 1) * 5}% off',
                style: TextStyle(
                  color: Colors.green[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ],
      ],
    );
  }

  Widget _buildPestDetailsSection() {
    bool hasResidentialServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Residential']!
        .any((service) => service.name == entry.key));

    bool hasCommercialServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Commercial']!
        .any((service) => service.name == entry.key));

    bool hasSpecialtyServices = _selectedServices.entries
        .where((entry) => entry.value)
        .any((entry) => _serviceCategories['Specialty']!
        .any((service) => service.name == entry.key));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pest Problem Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Main Pest Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: _pestType,
                items: _pestTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _pestType = newValue!;

                    // Auto-select bed bug treatment if bed bugs selected
                    if (newValue == 'Bed Bugs' && !_selectedServices['Bed Bug Treatment']!) {
                      _selectedServices['Bed Bug Treatment'] = true;
                    }

                    // Auto-select termite treatment if termites selected
                    if (newValue == 'Termites' && !_selectedServices['Termite Treatment']!) {
                      _selectedServices['Termite Treatment'] = true;
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Infestation Level',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: _infestationLevel,
                items: _infestationLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(level),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _infestationLevel = newValue!;
                    if (newValue == 'Severe' || newValue == 'Infestation') {
                      // For severe cases, suggest heavy-duty treatment
                      _selectedTreatmentType = 'Heavy-Duty';
                    }
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Treatment Type',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                value: _selectedTreatmentType,
                items: _treatmentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(
                          type == 'Eco-Friendly' ? Icons.eco_outlined :
                          type == 'Standard' ? Icons.check_outlined :
                          type == 'Heavy-Duty' ? Icons.shield_outlined :
                          Icons.whatshot_outlined,
                          size: 16,
                          color: Colors.green[700],
                        ),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTreatmentType = newValue!;
                    // Automatically set pet-safe for eco-friendly
                    if (newValue == 'Eco-Friendly') {
                      _needsPetSafeTreatment = true;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Property Size (sq ft)',
            border: OutlineInputBorder(),
            helperText: 'Approximate area requiring treatment',
          ),
          keyboardType: TextInputType.number,
          initialValue: _propertySize.toString(),
          onChanged: (value) {
            setState(() {
              _propertySize = int.tryParse(value) ?? 2000;
            });
          },
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: Row(
            children: [
              Icon(Icons.pets_outlined, size: 20, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Text('Pets in Home'),
            ],
          ),
          subtitle: const Text('We\'ll use appropriate precautions for your pets'),
          value: _hasPets,
          activeColor: Colors.green[700],
          onChanged: (bool value) {
            setState(() {
              _hasPets = value;
            });
          },
        ),
        if (_hasPets) ...[
          SwitchListTile(
            title: const Text('Need Pet-Safe Treatment'),
            subtitle: const Text('Special formulations safer for pets (+15%)'),
            value: _needsPetSafeTreatment,
            activeColor: Colors.green[700],
            onChanged: (bool value) {
              setState(() {
                _needsPetSafeTreatment = value;
              });
            },
          ),
        ],
        SwitchListTile(
          title: Row(
            children: [
              Icon(Icons.family_restroom_outlined, size: 20, color: Colors.green[700]),
              const SizedBox(width: 8),
              const Text('Children in Home'),
            ],
          ),
          subtitle: const Text('We\'ll use appropriate precautions for children'),
          value: _hasChildren,
          activeColor: Colors.green[700],
          onChanged: (bool value) {
            setState(() {
              _hasChildren = value;
              // If children, recommend pet-safe treatment as it's also safer for kids
              if (value && _hasPets) {
                _needsPetSafeTreatment = true;
              }
            });
          },
        ),
        SwitchListTile(
          title: Row(
            children: [
              Icon(Icons.priority_high_outlined, size: 20, color: Colors.red),
              const SizedBox(width: 8),
              const Text('Emergency Service Needed'),
            ],
          ),
          subtitle: const Text('Same-day or next-day service (+50% rush fee)'),
          value: _needsEmergencyService,
          activeColor: Colors.red,
          onChanged: (bool value) {
            setState(() {
              _needsEmergencyService = value;
            });
          },
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.calendar_today),
          title: const Text('Preferred Service Date'),
          subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(_selectedDate)),
          onTap: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: _needsEmergencyService
                  ? DateTime.now()
                  : DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
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
        const Text(
          'Additional Information',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Notes',
            hintText: 'Access instructions, pest sighting details, or specific concerns',
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
    List<String> selectedServiceNames = _selectedServices.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Service Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.green[700], size: 18),
                    const SizedBox(width: 8),
                    Text('${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate)} at ${_selectedTime.format(context)}'),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.pest_control, color: Colors.green[700], size: 18),
                    const SizedBox(width: 8),
                    const Text('Selected Services:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                if (_needsInspection && _selectedServices.values.every((v) => !v))
                  _buildPriceRow('Professional Pest Inspection', '\$79.99')
                else if (_needsInspection)
                  _buildPriceRow('Professional Pest Inspection', 'Included')
                else
                  const SizedBox.shrink(),

                ...selectedServiceNames.map((serviceName) {
                  double price = 0.0;
                  String priceUnit = '';

                  // Find service to get correct price
                  for (var category in _serviceCategories.values) {
                    for (var service in category) {
                      if (service.name == serviceName) {
                        price = service.price;
                        priceUnit = service.priceUnit;
                        break;
                      }
                    }
                  }

                  // Calculate displayed price
                  String priceString = '\$${price.toStringAsFixed(2)}';
                  if (priceUnit == 'per sq ft') {
                    priceString = '\$${(price * _propertySize).toStringAsFixed(2)}';
                  }

                  return _buildPriceRow(serviceName, '$priceString ${priceUnit != 'per treatment' ? priceUnit : ''}');
                }).toList(),

                const Divider(),

                if (_selectedTreatmentType != 'Standard')
                  _buildPriceRow('$_selectedTreatmentType Treatment', _getAdjustmentText(_selectedTreatmentType)),

                if (_infestationLevel != 'Moderate')
                  _buildPriceRow('$_infestationLevel Infestation', _getInfestationAdjustmentText()),

                if (_needsPetSafeTreatment && _hasPets)
                  _buildPriceRow('Pet-Safe Formula', '+15%'),

                if (_needsEmergencyService)
                  _buildPriceRow('Emergency Service Fee', '+50%'),

                if (_isRecurringService)
                  _buildPriceRow('Recurring Service Discount', '-20%'),

                if (_treatmentCount > 1 && !_isRecurringService)
                  _buildPriceRow('Multiple Treatment Discount', '-${(_treatmentCount - 1) * 5}%'),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isRecurringService ? 'Monthly Rate:' : 'Total Estimate:',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}${_isRecurringService ? '/month' : ''}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green[700]),
                    ),
                  ],
                ),
                if (_isRecurringService) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Annual Cost:', style: TextStyle(fontSize: 14)),
                      Text(
                        '\$${(_totalPrice * 12).toStringAsFixed(2)}/year',
                        style: TextStyle(fontSize: 14, color: Colors.green[700]),
                      ),
                    ],
                  ),
                  Text(
                    'Service frequency: Every $_recurringFrequency ${_recurringFrequency == 1 ? 'month' : 'months'}',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Note: Final pricing may vary based on actual conditions found during inspection or treatment.',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              _updateTotalPrice();
              _bookAppointment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            icon: const Icon(Icons.check),
            label: const Text('Confirm Booking'),
          ),
        ),
      ],
    );
  }

  String _getAdjustmentText(String treatmentType) {
    switch (treatmentType) {
      case 'Eco-Friendly':
        return '+25%';
      case 'Heavy-Duty':
        return '+40%';
      case 'Heat Treatment':
        return '+60%';
      default:
        return '';
    }
  }

  String _getInfestationAdjustmentText() {
    switch (_infestationLevel) {
      case 'Minor':
        return '-15%';
      case 'Severe':
        return '+30%';
      case 'Infestation':
        return '+50%';
      default:
        return '';
    }
  }

  Widget _buildPriceRow(String label, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(price, style: TextStyle(color: Colors.green[800])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pest Control Services'),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(Icons.pest_control_outlined, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      const Text('About Our Pest Control'),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Our professional pest control services use integrated pest management techniques to effectively eliminate pest problems while minimizing environmental impact.',
                        ),
                        SizedBox(height: 16),
                        Text('Our Process:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• Thorough inspection to identify pest species and entry points'),
                        Text('• Customized treatment plan based on your specific needs'),
                        Text('• Application of targeted treatments by licensed technicians'),
                        Text('• Follow-up services to ensure complete elimination'),
                        SizedBox(height: 16),
                        Text('Guarantees:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('• 30-day service guarantee on one-time treatments'),
                        Text('• Full coverage for recurring service plans'),
                        Text('• Licensed, bonded, and insured technicians'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (int step) {
          setState(() {
            _currentStep = step;
          });
        },
        onStepContinue: () {
          setState(() {
            if (_currentStep < 2) {
              _currentStep += 1;
              if (_currentStep == 2) {
                _updateTotalPrice();
              }
            } else {
              _bookAppointment();
            }
          });
        },
        onStepCancel: () {
          setState(() {
            if (_currentStep > 0) {
              _currentStep -= 1;
            }
          });
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                  ),
                  child: Text(_currentStep < 2 ? 'Continue' : 'Book Now'),
                ),
                if (_currentStep > 0) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
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
            title: const Text('Pest Details'),
            content: _buildPestDetailsSection(),
            isActive: _currentStep >= 1,
          ),
          Step(
            title: const Text('Confirm Booking'),
            content: _buildConfirmSection(),
            isActive: _currentStep >= 2,
          ),
        ],
      ),
      bottomNavigationBar: _showTotal
          ? BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Total:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '\$${_totalPrice.toStringAsFixed(2)}${_isRecurringService ? '/month' : ''}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green[700]),
              ),
            ],
          ),
        ),
      )
          : null,
    );
  }
}