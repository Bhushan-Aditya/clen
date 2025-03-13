import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart'; // Assuming you will have a cart_provider.dart file in providers folder
import 'login_page.dart';
import 'sign_up_page.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(), // Initialize your CartProvider or any other Provider here
      child: MaterialApp(
        title: 'ClenZo', // Or 'Urban Services' based on your app name
        debugShowCheckedModeBanner: false, // Keep debug banner setting
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF0EA5E9),
            background: Colors.white,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity, // Keep visual density if needed
        ),
        initialRoute: '/', // Set initial route to LandingPage
        routes: {
          '/': (context) => const LandingPage(), // Keep LandingPage as initial route
          '/signup': (context) => const SignUpPage(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Skip Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.home_repair_service,
                        color: Color(0xFF6366F1),
                        size: 32,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'UrbanPro',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // Skip directly to home page
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Main Image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.handyman,
                      size: size.width * 0.4,
                      color: Theme.of(context).primaryColor.withOpacity(0.7),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Title and Description
              const Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality services\nat your doorstep',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Find trusted professionals for all your home service needs. Book appointments with just a few taps.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to SignUpPage
                  Navigator.pushNamed(context, '/signup');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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