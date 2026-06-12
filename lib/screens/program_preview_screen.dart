import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
                    onTap: () => _showDayDetails(i),
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

  void _showDayDetails(int dayIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final day = _tempProgram[dayIndex];
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(day.dayName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.blue),
                      onPressed: () => _showAddExerciseDialog(dayIndex, setModalState),
                    ),
                  ],
                ),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIdx, newIdx) {
                      setModalState(() {
                        if (newIdx > oldIdx) newIdx -= 1;
                        final item = day.exercises.removeAt(oldIdx);
                        day.exercises.insert(newIdx, item);
                      });
                      setState(() {});
                    },
                    children: [
                      for (int i = 0; i < day.exercises.length; i++)
                        ListTile(
                          key: ValueKey(day.exercises[i].name + i.toString()),
                          title: Text(day.exercises[i].name),
                          subtitle: Text(day.exercises[i].target),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  setModalState(() => day.exercises.removeAt(i));
                                  setState(() {});
                                },
                              ),
                              Icon(Icons.drag_handle),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Done')),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddExerciseDialog(int dayIndex, StateSetter setModalState) async {
    // Fetch exercises to show in dialog
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json'));
    if (!mounted) return;

    List<Exercise> allExercises = [];
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      allExercises = data.take(50).map((item) {
        String id = item['id'].toString();
        return Exercise(
          name: item['name'],
          bodyPart: item['bodyPart'] ?? 'Misc',
          equipment: item['equipment'] ?? 'None',
          gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/$id/0.jpg',
          target: item['target'] ?? 'Muscle',
        );
      }).toList();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Exercise'),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: allExercises.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(allExercises[index].name),
              subtitle: Text(allExercises[index].target),
              onTap: () {
                setModalState(() {
                  _tempProgram[dayIndex].exercises.add(allExercises[index]);
                });
                setState(() {});
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _acceptProgram() async {
    await DatabaseService().saveProgram(_tempProgram);
    Navigator.pushReplacementNamed(context, '/home');
  }
}
