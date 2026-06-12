import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';

class ProgramPreviewScreen extends StatefulWidget {
  final List<WorkoutDay> program;

  ProgramPreviewScreen({required this.program});

  @override
  _ProgramPreviewScreenState createState() => _ProgramPreviewScreenState();
}

class _ProgramPreviewScreenState extends State<ProgramPreviewScreen> {
  late List<WorkoutDay> _tempProgram;

  @override
  void initState() {
    super.initState();
    _tempProgram = List.from(widget.program);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review Your Program')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Drag to reorder days or review exercises', style: TextStyle(fontStyle: FontStyle.italic)),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _tempProgram.removeAt(oldIndex);
                  _tempProgram.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < _tempProgram.length; i++)
                  ListTile(
                    key: ValueKey(_tempProgram[i].dayName + i.toString()),
                    title: Text(_tempProgram[i].dayName, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${_tempProgram[i].exercises.length} exercises'),
                    trailing: Icon(Icons.reorder),
                    onTap: () => _showDayDetails(_tempProgram[i]),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _acceptProgram,
                child: Text('Accept Program'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDayDetails(WorkoutDay day) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(day.dayName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: day.exercises.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(day.exercises[index].name),
                  subtitle: Text(day.exercises[index].target),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _acceptProgram() async {
    await DatabaseService().saveProgram(_tempProgram);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
