import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
