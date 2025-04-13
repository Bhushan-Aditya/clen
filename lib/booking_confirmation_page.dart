import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'models/cart_item.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String bookingId;
  final Map<String, String> address;
  final String paymentMethod;
  final double cartTotal;
  final DateTime serviceDate;
  final String serviceTime;
  final List<CartItem> cartItems;

  const BookingConfirmationPage({
    Key? key,
    required this.bookingId,
    required this.address,
    required this.paymentMethod,
    required this.cartTotal,
    required this.serviceDate,
    required this.serviceTime,
    required this.cartItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("BookingConfirmationPage received ${cartItems.length} items"); //debug message

    // Now, this can help know you want value item to know its available. I cannot control anything outside that but that a possible for other thing like user details or location. After getting info , need passed to build and its works
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        backgroundColor: Colors.indigo[600],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking confirmation header
              Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 70,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Booking Confirmed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Booking ID: $bookingId',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Service details section with explicit check for empty list
              const Text(
                'Service Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Make if has cart.isEmp or length check not empty show those and print to known. Now use check here on code level to sure it working. Previously it no had and had value and cause this. Previously said about pass and print. Make them both are in same file like this helps known about flow before
              if (cartItems.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No services in cart. This is unexpected.',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: cartItems
                          .map(
                            (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('x${item.quantity}'),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  '₹${(item.price * item.quantity).toStringAsFixed(2)}',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: Colors.indigo[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Order summary section
              const Text(
                'Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total:'),
                          Text(
                            '₹${cartTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Payment Method:'),
                          Text(
                            paymentMethod,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Service schedule section
              const Text(
                'Service Schedule',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Date:'),
                          Text(
                            DateFormat('EEE, MMM d, yyyy').format(serviceDate),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Time:'),
                          Text(
                            serviceTime,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Address section
              const Text(
                'Service Address',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address['fullName'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(address['phone'] ?? ''),
                      const SizedBox(height: 4),
                      Text(address['addressLine1'] ?? ''),
                      if (address['addressLine2']?.isNotEmpty ?? false) Text(address['addressLine2'] ?? ''),
                      Text('${address['city'] ?? ''} - ${address['pincode'] ?? ''}'),
                      if (address['landmark']?.isNotEmpty ?? false) Text('Landmark: ${address['landmark']}'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Back to home button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {


                    Navigator.of(context).popUntil((route) => route.isFirst); //Pop can have some performance issue
                    print('Back to Home page '); // After this check where code goes because all code need to has output message at some action for sure !
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}