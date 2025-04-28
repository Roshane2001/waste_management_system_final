import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_page.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/bulk_waste_details_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/schedule_pickup_screen.dart';
import 'screens/waste_details_screen.dart';
import 'screens/truck_home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/bulk-waste': (context) => const BulkWasteDetailsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/schedule-pickup': (context) => const SchedulePickupScreen(),
        '/waste-details': (context) => const WasteDetailsScreen(),
        '/truck-home': (context) => const TruckHomeScreen(),
      },
    );
  }
}
