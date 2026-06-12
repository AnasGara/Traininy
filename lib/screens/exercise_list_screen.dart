import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/models.dart';

class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  List<Exercise> _exercises = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      // Using the more detailed open database that includes GIF URLs
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _exercises = data.take(100).map((item) {
            // Mapping to find a gifUrl if available, otherwise using a placeholder
            // Note: The free-exercise-db often has image paths we can construct
            String id = item['id'].toString();
            return Exercise(
              name: item['name'],
              bodyPart: item['bodyPart'] ?? 'Misc',
              equipment: item['equipment'] ?? 'None',
              gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/$id/0.jpg', // Using JPG as fallback if GIF not direct
              target: item['target'] ?? 'Muscle',
            );
          }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _exercises = [
          Exercise(name: 'Push Up', bodyPart: 'Chest', equipment: 'Bodyweight', gifUrl: '', target: 'Pectorals'),
          Exercise(name: 'Squat', bodyPart: 'Legs', equipment: 'Bodyweight', gifUrl: '', target: 'Quads'),
        ];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise Library')),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _exercises.length,
            itemBuilder: (context, index) {
              final ex = _exercises[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(ex.gifUrl),
                    onBackgroundImageError: (_, __) => Icon(Icons.fitness_center),
                  ),
                  title: Text(ex.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${ex.bodyPart} | ${ex.target}'),
                  onTap: () => _showExerciseDetail(context, ex),
                ),
              );
            },
          ),
    );
  }

  void _showExerciseDetail(BuildContext context, Exercise ex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
            SizedBox(height: 20),
            Text(ex.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue[900])),
            Divider(),
            SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  ex.gifUrl,
                  height: 250,
                  fit: CrossAxisAlignment.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey[200],
                    child: Icon(Icons.videocam_off, size: 50, color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildDetailRow(Icons.accessibility, 'Body Part', ex.bodyPart),
            _buildDetailRow(Icons.build, 'Equipment', ex.equipment),
            _buildDetailRow(Icons.track_changes, 'Target', ex.target),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          SizedBox(width: 10),
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
