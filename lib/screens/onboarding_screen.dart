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
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');
  String _bodyType = 'Average';
  String _goal = 'Muscle Gain';
  int _sessions = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Setup'),
        leading: _currentPage > 0
          ? IconButton(icon: Icon(Icons.arrow_back), onPressed: _prevPage)
          : null,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentPage + 1) / _totalPages,
            backgroundColor: Colors.blue[100],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[900]!),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildStep(
            icon: Icons.height,
            title: 'What is your height?',
            subtitle: 'This helps us calculate your BMI',
            child: _buildTextField(_heightController, 'Height in cm'),
          ),
          _buildStep(
            icon: Icons.monitor_weight_outlined,
            title: 'What is your weight?',
            subtitle: 'We use this for calorie recommendations',
            child: _buildTextField(_weightController, 'Weight in kg'),
          ),
          _buildStep(
            icon: Icons.accessibility_new,
            title: 'Your body type?',
            subtitle: 'Select the one that describes you best',
            child: _buildDropdown(
              value: _bodyType,
              items: ['Ectomorph', 'Mesomorph', 'Endomorph', 'Average'],
              onChanged: (val) => setState(() => _bodyType = val!),
            ),
          ),
          _buildStep(
            icon: Icons.track_changes,
            title: 'What is your goal?',
            subtitle: 'We will tailor your program accordingly',
            child: _buildDropdown(
              value: _goal,
              items: ['Muscle Gain', 'Fat Loss', 'Strength', 'Endurance'],
              onChanged: (val) => setState(() => _goal = val!),
            ),
          ),
          _buildStep(
            icon: Icons.calendar_month,
            title: 'Training Frequency?',
            subtitle: 'How many days per week can you train?',
            child: Column(
              children: [
                Slider(
                  value: _sessions.toDouble(),
                  min: 1,
                  max: 7,
                  divisions: 6,
                  label: '$_sessions days',
                  onChanged: (val) => setState(() => _sessions = val.toInt()),
                ),
                Text('$_sessions days per week', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _nextPage,
            child: Text(_currentPage == _totalPages - 1 ? 'Generate Program' : 'Continue', style: TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }

  Widget _buildStep({required IconData icon, required String title, required String subtitle, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 100, color: Colors.blue[800]),
          SizedBox(height: 30),
          Text(title, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue[900])),
          SizedBox(height: 10),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          SizedBox(height: 40),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }

  Widget _buildDropdown({required String value, required List<String> items, required Function(String?) onChanged}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          items: items.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage++);
    } else {
      _submit();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() => _currentPage--);
    }
  }

  void _submit() async {
    double height = double.tryParse(_heightController.text) ?? 170;
    double weight = double.tryParse(_weightController.text) ?? 70;

    User user = User(
      height: height,
      weight: weight,
      bodyType: _bodyType,
      goal: _goal,
      sessionsPerWeek: _sessions,
    );

    // Save user profile
    await DatabaseService().saveUser(user);

    // Generate program
    List<WorkoutDay> program = ProgramGenerator.generateProgram(user);

    // Navigate to preview instead of home
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProgramPreviewScreen(program: program)),
    );
  }
}
