import '../models/models.dart';

class ProgramGenerator {
  static List<WorkoutDay> generateProgram(User user) {
    int sessions = user.sessionsPerWeek;

    if (sessions <= 3) {
      return _generateFullBody(sessions);
    } else if (sessions == 4) {
      return _generateUpperLower();
    } else {
      return _generatePPL(sessions);
    }
  }

  static List<WorkoutDay> _generateFullBody(int sessions) {
    List<WorkoutDay> program = [];
    List<Exercise> fullBodyExercises = [
      Exercise(name: 'Barbell Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHRneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4JmVwPXYxX2ludGVybmFsX2dpZl9ieV9pZCZjdD1n/3o7TKMGpxVfFzvZfG0/giphy.gif', target: 'Quads'),
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHRneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4JmVwPXYxX2ludGVybmFsX2dpZl9ieV9pZCZjdD1n/l0HlS9O5yK8V6zOYo/giphy.gif', target: 'Pectorals'),
      Exercise(name: 'Bent Over Row', bodyPart: 'Back', equipment: 'Barbell', gifUrl: 'https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExNHRneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4Z3RneGZ4JmVwPXYxX2ludGVybmFsX2dpZl9ieV9pZCZjdD1n/3o7TKMGpxVfFzvZfG0/giphy.gif', target: 'Lats'),
      Exercise(name: 'Overhead Press', bodyPart: 'Shoulders', equipment: 'Barbell', gifUrl: '', target: 'Delts'),
    ];

    for (int i = 1; i <= sessions; i++) {
      program.add(WorkoutDay(dayName: 'Full Body - Session $i', exercises: fullBodyExercises));
    }
    return program;
  }

  static List<WorkoutDay> _generateUpperLower() {
    List<Exercise> upper = [
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: '', target: 'Pectorals'),
      Exercise(name: 'Pull Ups', bodyPart: 'Back', equipment: 'Bodyweight', gifUrl: '', target: 'Lats'),
      Exercise(name: 'Dumbbell Press', bodyPart: 'Shoulders', equipment: 'Dumbbells', gifUrl: '', target: 'Delts'),
    ];
    List<Exercise> lower = [
      Exercise(name: 'Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: '', target: 'Quads'),
      Exercise(name: 'Romanian Deadlift', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: '', target: 'Hamstrings'),
      Exercise(name: 'Leg Press', bodyPart: 'Legs', equipment: 'Machine', gifUrl: '', target: 'Quads'),
    ];

    return [
      WorkoutDay(dayName: 'Upper Body A', exercises: upper),
      WorkoutDay(dayName: 'Lower Body A', exercises: lower),
      WorkoutDay(dayName: 'Upper Body B', exercises: upper),
      WorkoutDay(dayName: 'Lower Body B', exercises: lower),
    ];
  }

  static List<WorkoutDay> _generatePPL(int sessions) {
    List<Exercise> push = [
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: '', target: 'Pectorals'),
      Exercise(name: 'Incline Dumbbell Press', bodyPart: 'Chest', equipment: 'Dumbbells', gifUrl: '', target: 'Pectorals'),
      Exercise(name: 'Side Lateral Raise', bodyPart: 'Shoulders', equipment: 'Dumbbells', gifUrl: '', target: 'Delts'),
      Exercise(name: 'Triceps Pushdown', bodyPart: 'Arms', equipment: 'Cable', gifUrl: '', target: 'Triceps'),
    ];
    List<Exercise> pull = [
      Exercise(name: 'Deadlift', bodyPart: 'Back', equipment: 'Barbell', gifUrl: '', target: 'Back'),
      Exercise(name: 'Lat Pulldown', bodyPart: 'Back', equipment: 'Cable', gifUrl: '', target: 'Lats'),
      Exercise(name: 'Seated Cable Row', bodyPart: 'Back', equipment: 'Cable', gifUrl: '', target: 'Lats'),
      Exercise(name: 'Bicep Curls', bodyPart: 'Arms', equipment: 'Dumbbells', gifUrl: '', target: 'Biceps'),
    ];
    List<Exercise> legs = [
      Exercise(name: 'Barbell Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: '', target: 'Quads'),
      Exercise(name: 'Leg Press', bodyPart: 'Legs', equipment: 'Machine', gifUrl: '', target: 'Quads'),
      Exercise(name: 'Leg Curls', bodyPart: 'Legs', equipment: 'Machine', gifUrl: '', target: 'Hamstrings'),
      Exercise(name: 'Calf Raises', bodyPart: 'Legs', equipment: 'Machine', gifUrl: '', target: 'Calves'),
    ];

    List<WorkoutDay> program = [];
    List<List<Exercise>> splits = [push, pull, legs];
    List<String> names = ['Push Day', 'Pull Day', 'Leg Day'];

    for (int i = 0; i < sessions; i++) {
      program.add(WorkoutDay(dayName: names[i % 3], exercises: splits[i % 3]));
    }
    return program;
  }
}
