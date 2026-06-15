import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/program_generator.dart';
import '../services/database_service.dart';
import 'program_preview_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 6;
  bool _isLoading = false;

  final TextEditingController _heightController = TextEditingController(text: '170');
  final TextEditingController _weightController = TextEditingController(text: '70');
  String _selectedLanguage = 'English';
  String _bodyType = 'Average';
  String _goal = 'Muscle Gain';
  int _sessions = 3;

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Traininy'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    // Page 1 - Welcome
                    _buildWelcomePage(),

                    // Page 2 - Intro
                    _buildIntroPage(),

                    // Page 3 - Height & Weight
                    _buildHeightWeightPage(),

                    // Page 4 - Body Type
                    _buildBodyTypePage(),

                    // Page 5 - Goal
                    _buildGoalPage(),

                    // Page 6 - Sessions
                    _buildSessionsPage(),
                  ],
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Generating your personalized plan...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 100,
            color: Colors.blue[700],
          ),
          const SizedBox(height: 32),
          Text(
            'Welcome to this app',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Please choose your language',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLanguageCard('English', 'English'),
              _buildLanguageCard('Arabic', 'العربية'),
              _buildLanguageCard('French', 'Français'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(String language, String label) {
    bool isSelected = _selectedLanguage == language;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue[900]! : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.blue[900],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIntroPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_ind,
              size: 100,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 48),
          Text(
            'Answer these questions to get your personalized plan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'We will use your answers to tailor the exercises, intensity, and schedule specifically for you.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightWeightPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Physical Stats',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 32),
            _buildCardField(
              label: 'Height (cm)',
              child: TextFormField(
                controller: _heightController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '170',
                  hintStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.height, color: Color(0xFF1565C0)),
                ),
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your height';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            _buildCardField(
              label: 'Weight (kg)',
              child: TextFormField(
                controller: _weightController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '70',
                  hintStyle: TextStyle(fontSize: 18),
                  prefixIcon: Icon(Icons.monitor_weight, color: Color(0xFF1565C0)),
                ),
                style: const TextStyle(fontSize: 18),
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Please enter your weight';
                  }
                  if (double.tryParse(val) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyTypePage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Body Type',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Select the body type that best describes you',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildSelectionCard(
                  title: 'Ectomorph',
                  icon: Icons.accessibility,
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Ectomorph'),
                ),
                _buildSelectionCard(
                  title: 'Mesomorph',
                  icon: Icons.accessibility_new,
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Mesomorph'),
                ),
                _buildSelectionCard(
                  title: 'Endomorph',
                  icon: Icons.person,
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Endomorph'),
                ),
                _buildSelectionCard(
                  title: 'Average',
                  icon: Icons.person_outline,
                  currentValue: _bodyType,
                  onTap: () => setState(() => _bodyType = 'Average'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData icon,
    required String currentValue,
    required VoidCallback onTap,
  }) {
    bool isSelected = currentValue == title;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.blue[900] : Colors.white,
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected ? Colors.blue[900]! : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? Colors.white : Colors.blue[900],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fitness Goal',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'What\'s your primary fitness objective?',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                _buildSelectionCard(
                  title: 'Muscle Gain',
                  icon: Icons.fitness_center,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Muscle Gain'),
                ),
                _buildSelectionCard(
                  title: 'Fat Loss',
                  icon: Icons.trending_down,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Fat Loss'),
                ),
                _buildSelectionCard(
                  title: 'Strength',
                  icon: Icons.bolt,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Strength'),
                ),
                _buildSelectionCard(
                  title: 'Endurance',
                  icon: Icons.timer,
                  currentValue: _goal,
                  onTap: () => setState(() => _goal = 'Endurance'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsPage() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Sessions',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'How many days per week can you work out?',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  '$_sessions sessions per week',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: _sessions.toDouble(),
                  min: 1,
                  max: 7,
                  activeColor: Colors.blue[700],
                  inactiveColor: Colors.grey[300],
                  divisions: 6,
                  label: '$_sessions sessions',
                  onChanged: (val) {
                    setState(() {
                      _sessions = val.toInt();
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('1', style: TextStyle(color: Colors.grey[600])),
                    Text('3', style: TextStyle(color: Colors.grey[600])),
                    Text('5', style: TextStyle(color: Colors.grey[600])),
                    Text('7', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates, color: Colors.orange[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'For best results, we recommend 3-5 sessions per week with proper rest days.',
                    style: TextStyle(fontSize: 14, color: Colors.orange[900]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardField({required String label, required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevPage,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.blue[900]!),
                ),
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 16, color: Colors.blue[900]),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _nextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _currentPage == _totalPages - 1 ? 'Generate Program' : 'Continue',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    // Validate only on the height/weight page
    if (_currentPage == 2) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
    }

    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submit();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });

    // Illusion of treating data
    await Future.delayed(const Duration(seconds: 5));

    // Get values from controllers
    double height = double.tryParse(_heightController.text) ?? 170;
    double weight = double.tryParse(_weightController.text) ?? 70;

    User user = User(
      height: height,
      weight: weight,
      bodyType: _bodyType,
      goal: _goal,
      sessionsPerWeek: _sessions,
    );

    try {
      // Save user profile
      await DatabaseService().saveUser(user);

      // Generate program
      List<WorkoutDay> program = ProgramGenerator.generateProgram(user);

      if (!mounted) return;

      // Navigate to program preview
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProgramPreviewScreen(program: program),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating program: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}