import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert'; // Import the dart:convert library

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://kuvedwxplbtamiwocofg.supabase.co', // Replace with your Supabase URL
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt1dmVkd3hwbGJ0YW1pd29jb2ZnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIyMTMyMTIsImV4cCI6MjA1Nzc4OTIxMn0.98n-2p_bvmMEMyoLUfzhjzPhTway3mqYsiCbAYqfqDU', // Replace with your Supabase Anon Key
      debug: kDebugMode,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static Future<void> saveAddress(Map<String, String> address) async {
    try {
      final response = await client
          .from('addresses')
          .insert({
        'user_id': currentUser?.id, // Get the current user's ID
        'full_name': address['fullName'],
        'phone': address['phone'],
        'address_line1': address['addressLine1'],
        'address_line2': address['addressLine2'] ?? '',
        'city': address['city'],
        'pincode': address['pincode'],
        'landmark': address['landmark'] ?? '',
        'is_default': true,
      }).select().single();

      final jsonString = jsonEncode(response); // Convert to JSON string
      final Map<String, dynamic> value = jsonDecode(jsonString); // Decode to Map

      // Check if the 'code' key exists and handle errors accordingly
      if (value['code'] != null && value['code'] != 201) {
        throw Exception('Failed to save address: ${value['message'] ?? 'Unknown error'}');
      }

    } catch (error) {
      print('Error saving address: $error');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> createBooking({
    required Map<String, String> savedAddress,
    required String paymentMethod,
    required DateTime serviceDate,
    required String serviceTime,
  }) async {
    try {
      final response = await client
          .from('bookings')
          .insert({
        'user_id': currentUser?.id,
        'service_date': serviceDate.toIso8601String(),
        'service_time': serviceTime,
        'payment_method': paymentMethod,
        // Add any additional fields as necessary
      }).select().single();

      final jsonString = jsonEncode(response); // Convert to JSON string
      final Map<String, dynamic> value = jsonDecode(jsonString); // Decode to Map

      // Check if the 'code' key exists and handle errors accordingly
      if (value['code'] != null && value['code'] != 201) {
        throw Exception('Failed to create booking: ${value['message'] ?? 'Unknown error'}');
      }

      // Adjust based on your response structure.
      final totalAmount = value['total_amount'];

      return {
        'totalAmount': totalAmount,
        // Add additional data as needed
      };
    } catch (error) {
      print('Error creating booking: $error');
      rethrow;
    }
  }
}