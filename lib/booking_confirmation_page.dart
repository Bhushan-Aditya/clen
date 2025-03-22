import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'home_page.dart';

class BookingConfirmationPage extends StatefulWidget {
  final String bookingId; // Add bookingId as a required parameter
  final Map<String, String> address;
  final String paymentMethod;
  final double cartTotal;
  final DateTime serviceDate;
  final String serviceTime;

  const BookingConfirmationPage({
    Key? key,
    required this.bookingId, // Required parameter
    required this.address,
    required this.paymentMethod,
    required this.cartTotal,
    required this.serviceDate,
    required this.serviceTime,
  }) : super(key: key);

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Setup the animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to get payment method full name
  String getPaymentMethodName(String id) {
    switch (id) {
      case 'card':
        return 'Credit/Debit Card';
      case 'upi':
        return 'UPI';
      case 'netbanking':
        return 'Net Banking';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return 'Online Payment';
    }
  }

  // Generate booking details for sharing manually
  String getBookingDetails() {
    return """
📝 BOOKING CONFIRMATION 📝

Booking ID: ${widget.bookingId}
Date: ${DateFormat('EEEE, MMMM d, yyyy').format(widget.serviceDate)}
Time: ${widget.serviceTime}

📍 Service Address:
${widget.address['fullName']}
${widget.address['addressLine1']} ${widget.address['addressLine2'] != 'N/A' ? widget.address['addressLine2'] : ''}
${widget.address['city']}, ${widget.address['pincode']}
${widget.address['landmark'] != 'N/A' ? 'Landmark: ${widget.address['landmark']}' : ''}
📱 ${widget.address['phone']}

💰 Payment Details:
Method: ${getPaymentMethodName(widget.paymentMethod)}
Amount: ₹${widget.cartTotal.toStringAsFixed(2)}

Thank you for choosing our service!
""";
  }

  // Copy text to clipboard
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return WillPopScope(
      // Prevent going back with the back button
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Success Animation
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green[600],
                        size: 80,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Success Text
                  const Text(
                    'Booking Confirmed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Your service has been booked successfully',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // Booking ID
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking ID',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  widget.bookingId, // Use the passed bookingId
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),

                                // Copy icon
                                GestureDetector(
                                  onTap: () {
                                    // Copy booking ID to clipboard
                                    copyToClipboard(widget.bookingId);
                                  },
                                  child: Icon(
                                    Icons.copy,
                                    size: 16,
                                    color: Colors.indigo[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),

                        // Date and Time
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.indigo[600]),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('EEEE, MMMM d, yyyy').format(widget.serviceDate),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.indigo[600]),
                            const SizedBox(width: 8),
                            Text(
                              widget.serviceTime,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Service Items
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Service Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Display cart items
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartProvider.items.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey[200], height: 1),
                      itemBuilder: (context, index) {
                        final item = cartProvider.items[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Service Icon
                              Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item.icon,
                                  color: item.color,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // Service Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      item.serviceType,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Price and Quantity
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Qty: ${item.quantity}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Address Section
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Service Address',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.address['fullName'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.address['phone'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.address['addressLine1'] ?? ''} ${widget.address['addressLine2'] != 'N/A' ? widget.address['addressLine2'] : ''}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.address['city'] ?? ''}, ${widget.address['pincode'] ?? ''}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                        ),
                        if (widget.address['landmark'] != 'N/A')
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Landmark: ${widget.address['landmark']}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Payment Details
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Payment Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              getPaymentMethodName(widget.paymentMethod),
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '₹${widget.cartTotal.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        if (widget.paymentMethod == 'cod')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 14,
                                  color: Colors.orange[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Please pay the amount after service completion',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange[700],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Copy booking details button
                  OutlinedButton.icon(
                    onPressed: () {
                      copyToClipboard(getBookingDetails());
                    },
                    icon: const Icon(Icons.content_copy),
                    label: const Text('Copy Booking Details'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.indigo[600],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(color: Colors.indigo[600]!),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Return to Home
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Clear cart
                        cartProvider.clearCart();

                        // Navigate to home and clear all previous routes
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                                (route) => false
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Return to Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}