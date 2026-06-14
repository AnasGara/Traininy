import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<WorkoutDay> _program = [];
  Map<String, WorkoutDay> _scheduledWorkouts = {};

  @override
  void initState() {
    super.initState();
    _loadProgram();
    _selectedDay = _focusedDay;
  }

  void _loadProgram() async {
    final program = await DatabaseService().getProgram();
    setState(() {
      _program = program;
      // For simplicity in this demo, we'll map program days to the current week
      _scheduledWorkouts = {};
      DateTime startOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      for (int i = 0; i < _program.length; i++) {
        String dateKey = DateFormat('yyyy-MM-dd').format(startOfWeek.add(Duration(days: i)));
        _scheduledWorkouts[dateKey] = _program[i];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Training Plan'),
        actions: [
          IconButton(
            icon: Icon(_calendarFormat == CalendarFormat.month ? Icons.calendar_view_week : Icons.calendar_view_month),
            onPressed: () => setState(() => _calendarFormat = _calendarFormat == CalendarFormat.month ? CalendarFormat.week : CalendarFormat.month),
          )
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              String key = DateFormat('yyyy-MM-dd').format(day);
              return _scheduledWorkouts.containsKey(key) ? [_scheduledWorkouts[key]] : [];
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(color: Colors.blue[900], shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Colors.blue[200], shape: BoxShape.circle),
              markerDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          Expanded(child: _buildDayDetails()),
        ],
      ),
    );
  }

  Widget _buildDayDetails() {
    if (_calendarFormat == CalendarFormat.week) {
      return _buildVerticalWeekList();
    }

    if (_selectedDay == null) return Center(child: Text('Select a day'));
    String key = DateFormat('yyyy-MM-dd').format(_selectedDay!);
    WorkoutDay? dayWorkout = _scheduledWorkouts[key];

    if (dayWorkout == null) {
      return Center(child: Text('No workout scheduled for today', style: TextStyle(color: Colors.grey)));
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [_buildWorkoutCard(dayWorkout)],
    );
  }

  Widget _buildVerticalWeekList() {
    DateTime startOfWeek = _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1));
    List<DateTime> weekDays = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 7,
      itemBuilder: (context, index) {
        DateTime day = weekDays[index];
        String key = DateFormat('yyyy-MM-dd').format(day);
        WorkoutDay? dayWorkout = _scheduledWorkouts[key];

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(day),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
              ),
              SizedBox(height: 8),
              dayWorkout != null
                ? _buildWorkoutCard(dayWorkout)
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Rest Day', style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic)),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWorkoutCard(WorkoutDay dayWorkout) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        initiallyExpanded: isSameDay(_selectedDay, DateFormat('yyyy-MM-dd').parse(dayWorkout.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()))),
        title: Text(dayWorkout.dayName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900])),
        subtitle: Text('${dayWorkout.exercises.length} Exercises'),
        trailing: Checkbox(
          value: dayWorkout.isDone,
          onChanged: (val) async {
            setState(() => dayWorkout.isDone = val!);
            await DatabaseService().updateWorkoutDay(dayWorkout);
          },
        ),
        children: [
          Divider(),
          ...dayWorkout.exercises.map((ex) => ListTile(
            dense: true,
            leading: Icon(Icons.fitness_center, size: 18, color: Colors.blue),
            title: Text(ex.name),
            subtitle: Text(ex.target),
          )).toList(),
          if (dayWorkout.isDone)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('COMPLETED!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
            ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
