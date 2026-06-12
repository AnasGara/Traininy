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
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (cm)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || double.tryParse(val) == null) ? 'Enter a valid number' : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || double.tryParse(val) == null) ? 'Enter a valid number' : null,
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: bodyType,
                items: ['Ectomorph', 'Mesomorph', 'Endomorph', 'Average'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => bodyType = val!),
                decoration: InputDecoration(labelText: 'Body Type', border: OutlineInputBorder()),
              ),
              SizedBox(height: 15),
              DropdownButtonFormField<String>(
                value: goal,
                items: ['Muscle Gain', 'Fat Loss', 'Strength', 'Endurance'].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (val) => setState(() => goal = val!),
                decoration: InputDecoration(labelText: 'Goal', border: OutlineInputBorder()),
              ),
              SizedBox(height: 20),
              Text('How many sessions per week?', style: TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: sessions.toDouble(),
                min: 1,
                max: 7,
                divisions: 6,
                label: '$sessions sessions',
                onChanged: (val) => setState(() => sessions = val.toInt()),
              ),
              Text('$sessions sessions per week'),
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
