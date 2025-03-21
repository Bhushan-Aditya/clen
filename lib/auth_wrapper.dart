import 'package:flutter/material.dart';
import 'services/supabase_service.dart'; // Adjust the import based on your directory structure
import 'home_page.dart'; // Import the HomePage
import 'landing_page.dart'; // Import the LandingPage

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = SupabaseService.currentUser; // Check if the user is signed in

    // Return the appropriate page based on authentication status
    if (user != null) {
      return const HomePage(); // User is signed in, redirect to HomePage
    } else {
      return const LandingPage(); // User is not signed in, show LandingPage
    }
  }
}
