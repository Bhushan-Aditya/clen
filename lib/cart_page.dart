import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'providers/cart_provider.dart';
import 'models/cart_item.dart';
import 'booking_confirmation_page.dart';
import 'services/supabase_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isAddressSaved = false;
  bool isPaymentMethodSelected = false;
  bool isScheduleSelected = false;
  final _formKey = GlobalKey<FormState>();

  String? selectedPaymentMethod;
  DateTime? selectedDate;
  String? selectedTimeSlot;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();

  Map<String, String> savedAddress = {};

  final List<String> timeSlots = [
    '09:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '01:00 PM - 03:00 PM',
    '03:00 PM - 05:00 PM',
    '05:00 PM - 07:00 PM',
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {'id': 'card', 'title': 'Credit/Debit Card', 'icon': Icons.credit_card, 'subtitle': 'Pay securely with your card'},
    {'id': 'upi', 'title': 'UPI', 'icon': Icons.phone_android, 'subtitle': 'Google Pay, PhonePe, Paytm & more'},
    {'id': 'netbanking', 'title': 'Net Banking', 'icon': Icons.account_balance, 'subtitle': 'All major banks supported'},
    {'id': 'cod', 'title': 'Cash on Delivery', 'icon': Icons.money, 'subtitle': 'Pay when service is completed'},
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now().add(const Duration(days: 1));
    _fullNameController.addListener(_checkFormCompleteness);
    _phoneController.addListener(_checkFormCompleteness);
    _addressLine1Controller.addListener(_checkFormCompleteness);
    _cityController.addListener(_checkFormCompleteness);
    _pincodeController.addListener(_checkFormCompleteness);
  }

  @override
  void dispose() {
    _fullNameController.removeListener(_checkFormCompleteness);
    _phoneController.removeListener(_checkFormCompleteness);
    _addressLine1Controller.removeListener(_checkFormCompleteness);
    _cityController.removeListener(_checkFormCompleteness);
    _pincodeController.removeListener(_checkFormCompleteness);

    _fullNameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  bool _isFormCompleted = false;

  void _checkFormCompleteness() {
    final isCompleted =
        _fullNameController.text.isNotEmpty &&
            _phoneController.text.isNotEmpty &&
            _phoneController.text.length == 10 &&
            _addressLine1Controller.text.isNotEmpty &&
            _cityController.text.isNotEmpty &&
            _pincodeController.text.isNotEmpty &&
            _pincodeController.text.length == 6;

    if (isCompleted != _isFormCompleted) {
      setState(() {
        _isFormCompleted = isCompleted;
      });
    }
  }

  void _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        savedAddress = {
          'fullName': _fullNameController.text,
          'phone': _phoneController.text,
          'addressLine1': _addressLine1Controller.text,
          'addressLine2': _addressLine2Controller.text.isEmpty ? 'N/A' : _addressLine2Controller.text,
          'city': _cityController.text,
          'pincode': _pincodeController.text,
          'landmark': _landmarkController.text.isEmpty ? 'N/A' : _landmarkController.text,
        };
        isAddressSaved = true;
      });

      try {
        await SupabaseService.saveAddress(savedAddress);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Address saved successfully!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save address: $error'), backgroundColor: Colors.red, duration: Duration(seconds: 3)),
        );
      }
    }
  }

  Future<void> _confirmBooking() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItems = cartProvider.items;

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty'), backgroundColor: Colors.red),
      );
      return;
    }

    if (!isAddressSaved || !isPaymentMethodSelected || !isScheduleSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all sections before confirming'), backgroundColor: Colors.red),
      );
      return;
    }

    // Calculate the cart total before making the API call
    final double cartTotal = cartItems.fold(
      0,
          (sum, item) => sum + (item.price * item.quantity),
    );

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Call createBooking with only the parameters it accepts
      final result = await SupabaseService.createBooking(
        savedAddress: savedAddress,
        paymentMethod: selectedPaymentMethod!,
        serviceDate: selectedDate!,
        serviceTime: selectedTimeSlot!,
      );

      // Close loading dialog
      Navigator.pop(context);
      // Clear the cart after successful booking
      cartProvider.clearCart();
      // Generate a booking ID if one isn't returned from your service
      final bookingId = result['bookingId'] ?? 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(0, 8)}';

      // Use the manually calculated cart total instead of relying on the result
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationPage(
            bookingId: bookingId,
            address: savedAddress,
            paymentMethod: selectedPaymentMethod!,
            cartTotal: cartTotal, // Use the pre-calculated cart total
            serviceDate: selectedDate!,
            serviceTime: selectedTimeSlot!,
          ),
        ),
      );
    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating booking: ${e.toString()}'), backgroundColor: Colors.red),
      );
    }
  }



  void _checkScheduleSelection() {
    setState(() {
      isScheduleSelected = selectedDate != null && selectedTimeSlot != null;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo[600]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _checkScheduleSelection();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Cart'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: cart.items.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 60, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text('Your cart is empty', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Browse Services'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo[600],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (ctx, index) {
                final item = cart.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3, offset: const Offset(0, 1))],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(color: item.color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                            child: Icon(item.icon, color: item.color, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                Text('${item.serviceType} • ₹${item.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  cart.decrementItem(item.id);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
                                  child: Icon(Icons.remove, size: 16, color: Colors.grey[700]),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.w500)),
                              ),
                              InkWell(
                                onTap: () {
                                  cart.addItem(item.id, item.name, item.price, item.serviceType, item.imageUrl, item.icon, item.color);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)),
                                  child: Icon(Icons.add, size: 16, color: Colors.grey[700]),
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  cart.removeItem(item.id);
                                },
                                child: Icon(Icons.delete_outline, color: Colors.red[400], size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Delivery Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  isAddressSaved ? _buildSavedAddress() : _buildAddressForm(),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  const Text('Schedule Service', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildScheduleSection(),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildPaymentMethods(),
                  const SizedBox(height: 16),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('₹${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo[600])),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (isAddressSaved && isPaymentMethodSelected && isScheduleSelected) ? _confirmBooking : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (isAddressSaved && isPaymentMethodSelected && isScheduleSelected) ? Colors.indigo[600] : Colors.grey[400],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 10) {
                return 'Please enter a valid 10-digit phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressLine1Controller,
            decoration: InputDecoration(
              labelText: 'Address Line 1',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your address';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _addressLine2Controller,
            decoration: InputDecoration(
              labelText: 'Address Line 2 (Optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _pincodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Pincode',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter pincode';
                    }
                    if (value.length != 6) {
                      return 'Invalid pincode';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _landmarkController,
            decoration: InputDecoration(
              labelText: 'Landmark (Optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isFormCompleted ? _saveAddress : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isFormCompleted ? Colors.indigo[600] : Colors.grey[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedAddress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(savedAddress['fullName'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    isAddressSaved = false;
                  });
                },
                icon: Icon(Icons.edit, size: 16, color: Colors.indigo[600]),
                label: Text('Edit', style: TextStyle(color: Colors.indigo[600], fontSize: 14)),
                style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap, padding: EdgeInsets.zero, minimumSize: Size.zero),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(savedAddress['phone'] ?? '', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          const SizedBox(height: 8),
          Text('${savedAddress['addressLine1'] ?? ''} ${savedAddress['addressLine2'] != 'N/A' ? savedAddress['addressLine2'] : ''}',
              style: TextStyle(color: Colors.grey[800], fontSize: 14)),
          const SizedBox(height: 4),
          Text('${savedAddress['city'] ?? ''}, ${savedAddress['pincode'] ?? ''}', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
          if (savedAddress['landmark'] != 'N/A')
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text('Landmark: ${savedAddress['landmark']}', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.green[600]),
              const SizedBox(width: 4),
              Text('Delivery available', style: TextStyle(color: Colors.green[600], fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: Colors.indigo[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Date', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(
                        selectedDate != null ? DateFormat('EEEE, MMMM d, yyyy').format(selectedDate!) : 'Select a date',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text('Change', style: TextStyle(color: Colors.indigo[600], fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 20, color: Colors.indigo[600]),
                  const SizedBox(width: 12),
                  const Text('Time Slot', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                ],
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5, crossAxisSpacing: 10, mainAxisSpacing: 10),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  final isSelected = selectedTimeSlot == timeSlots[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedTimeSlot = timeSlots[index];
                        _checkScheduleSelection();
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.indigo.withOpacity(0.1) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isSelected ? Colors.indigo[600]! : Colors.grey[300]!, width: isSelected ? 1.5 : 1),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        timeSlots[index],
                        style: TextStyle(color: isSelected ? Colors.indigo[800] : Colors.grey[800], fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal, fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: paymentMethods.map((method) {
          final isSelected = selectedPaymentMethod == method['id'];

          return InkWell(
            onTap: () {
              setState(() {
                selectedPaymentMethod = method['id'];
                isPaymentMethodSelected = true;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? Colors.indigo[600]! : Colors.grey[400]!, width: 2),
                    ),
                    child: Center(
                      child: isSelected
                          ? Container(height: 12, width: 12, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.indigo[600]))
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(method['icon'], color: isSelected ? Colors.indigo[600] : Colors.grey[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(method['title'], style: TextStyle(fontWeight: FontWeight.w500, color: isSelected ? Colors.indigo[800] : Colors.black)),
                        const SizedBox(height: 2),
                        Text(method['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}