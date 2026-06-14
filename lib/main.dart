import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/exercise_list_screen.dart';
import 'screens/calorie_calculator_screen.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final user = await DatabaseService().getUser();
  runApp(TraininyApp(initialRoute: user == null ? '/' : '/home'));
}

class TraininyApp extends StatelessWidget {
  final String initialRoute;
  TraininyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final primaryBlue = Color(0xFF1565C0);
    final accentBlue = Color(0xFF03A9F4);

    return MaterialApp(
      title: 'Traininy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          primary: primaryBlue,
          secondary: accentBlue,
          surface: Colors.white,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: Color(0xFFF5F9FF),
        appBarTheme: AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => MainNavigationScreen(),
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    CalendarScreen(),
    ExerciseListScreen(),
    CalorieCalculatorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: [
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today), label: 'Program'),
          NavigationDestination(icon: Icon(Icons.fitness_center_outlined), selectedIcon: Icon(Icons.fitness_center), label: 'Exercises'),
          NavigationDestination(icon: Icon(Icons.restaurant_outlined), selectedIcon: Icon(Icons.restaurant), label: 'Calories'),
        ],
      ),
    );
  }
}
