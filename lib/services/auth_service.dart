import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  static final _client = SupabaseService.client;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );
    return response;
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign out
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Check if user is signed in
  static bool isSignedIn() {
    return _client.auth.currentSession != null;
  }

  // Get current user
  static User? get currentUser => _client.auth.currentUser;
}
