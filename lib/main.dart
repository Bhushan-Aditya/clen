import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'services/supabase_service.dart';
import 'auth_wrapper.dart';
import 'login_page.dart';
import 'sign_up_page.dart';
import 'home_page.dart';
import 'landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CartProvider(),
      child: MaterialApp(
        title: 'ClenZo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6366F1),
            primary: const Color(0xFF6366F1),
            secondary: const Color(0xFF0EA5E9),
            background: Colors.white,
          ),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(), // Use AuthWrapper as the home
        routes: {
          '/home': (context) => const HomePage(),       // Define the HomePage route
          '/signup': (context) => const SignUpPage(),   // Define the SignUpPage route
          '/login': (context) => const LoginPage(),      // Define the LoginPage if needed
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const LandingPage(), // Fallback page for unknown routes
          );
        },
      ),
    );
  }
}
