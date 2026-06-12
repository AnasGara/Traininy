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
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');
  String bodyType = 'Average';
  String goal = 'Muscle Gain';
  int sessions = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome to Traininy')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Tell us about yourself', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900])),
              SizedBox(height: 20),
              _buildCardField(
                label: 'Height (cm)',
                child: TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(border: InputBorder.none, hintText: '170'),
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || double.tryParse(val) == null) ? 'Enter a valid number' : null,
                ),
              ),
              SizedBox(height: 15),
              _buildCardField(
                label: 'Weight (kg)',
                child: TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(border: InputBorder.none, hintText: '70'),
                  keyboardType: TextInputType.number,
                  validator: (val) => (val == null || double.tryParse(val) == null) ? 'Enter a valid number' : null,
                ),
              ),
              SizedBox(height: 15),
              _buildCardField(
                label: 'Body Type',
                child: DropdownButtonFormField<String>(
                  value: bodyType,
                  items: ['Ectomorph', 'Mesomorph', 'Endomorph', 'Average'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => bodyType = val!),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 15),
              _buildCardField(
                label: 'Goal',
                child: DropdownButtonFormField<String>(
                  value: goal,
                  items: ['Muscle Gain', 'Fat Loss', 'Strength', 'Endurance'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) => setState(() => goal = val!),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              SizedBox(height: 20),
              Text('How many sessions per week?', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800])),
              Slider(
                value: sessions.toDouble(),
                min: 1,
                max: 7,
                activeColor: Colors.blue[700],
                divisions: 6,
                label: '$sessions sessions',
                onChanged: (val) => setState(() => sessions = val.toInt()),
              ),
              Text('$sessions sessions per week', style: TextStyle(color: Colors.blue[900])),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('Generate My Program', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardField({required String label, required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.bold)),
          ),
          child,
        ],
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      User user = User(
        height: double.parse(_heightController.text),
        weight: double.parse(_weightController.text),
        bodyType: bodyType,
        goal: goal,
        sessionsPerWeek: sessions,
      );

      // Save user profile
      await DatabaseService().saveUser(user);

      // Generate program
      List<WorkoutDay> program = ProgramGenerator.generateProgram(user);

      // Navigate to preview instead of home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProgramPreviewScreen(program: program)),
      );
    }
  }
}
