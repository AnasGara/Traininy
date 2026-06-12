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
    List<Exercise> fullBodyA = [
      Exercise(name: 'Barbell Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0032/0.jpg', target: 'Quads'),
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0025/0.jpg', target: 'Pectorals'),
      Exercise(name: 'Bent Over Row', bodyPart: 'Back', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0027/0.jpg', target: 'Lats'),
      Exercise(name: 'Overhead Press', bodyPart: 'Shoulders', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0041/0.jpg', target: 'Delts'),
      Exercise(name: 'Lying Leg Curls', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0599/0.jpg', target: 'Hamstrings'),
    ];

    List<Exercise> fullBodyB = [
      Exercise(name: 'Deadlift', bodyPart: 'Back', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0032/0.jpg', target: 'Glutes'),
      Exercise(name: 'Incline Dumbbell Press', bodyPart: 'Chest', equipment: 'Dumbbells', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0314/0.jpg', target: 'Pectorals'),
      Exercise(name: 'Lat Pulldown', bodyPart: 'Back', equipment: 'Cable', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0150/0.jpg', target: 'Lats'),
      Exercise(name: 'Leg Press', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0581/0.jpg', target: 'Quads'),
      Exercise(name: 'Lateral Raises', bodyPart: 'Shoulders', equipment: 'Dumbbells', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0334/0.jpg', target: 'Delts'),
    ];

    for (int i = 1; i <= sessions; i++) {
      program.add(WorkoutDay(
        dayName: 'Full Body ${i % 2 == 1 ? 'A' : 'B'}',
        exercises: i % 2 == 1 ? fullBodyA : fullBodyB
      ));
    }
    return program;
  }

  static List<WorkoutDay> _generateUpperLower() {
    List<Exercise> upperA = [
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0025/0.jpg', target: 'Pectorals'),
      Exercise(name: 'Bent Over Row', bodyPart: 'Back', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0027/0.jpg', target: 'Lats'),
      Exercise(name: 'Overhead Press', bodyPart: 'Shoulders', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0041/0.jpg', target: 'Delts'),
      Exercise(name: 'Dips', bodyPart: 'Chest', equipment: 'Bodyweight', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0401/0.jpg', target: 'Triceps'),
    ];
    List<Exercise> lowerA = [
      Exercise(name: 'Barbell Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0032/0.jpg', target: 'Quads'),
      Exercise(name: 'Romanian Deadlift', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0032/0.jpg', target: 'Hamstrings'),
      Exercise(name: 'Leg Extensions', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0585/0.jpg', target: 'Quads'),
      Exercise(name: 'Standing Calf Raises', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0751/0.jpg', target: 'Calves'),
    ];

    return [
      WorkoutDay(dayName: 'Upper Body A', exercises: upperA),
      WorkoutDay(dayName: 'Lower Body A', exercises: lowerA),
      WorkoutDay(dayName: 'Upper Body B', exercises: upperA), // Could diversify B later
      WorkoutDay(dayName: 'Lower Body B', exercises: lowerA),
    ];
  }

  static List<WorkoutDay> _generatePPL(int sessions) {
    List<Exercise> push = [
      Exercise(name: 'Bench Press', bodyPart: 'Chest', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0025/0.jpg', target: 'Pectorals'),
      Exercise(name: 'Incline Dumbbell Press', bodyPart: 'Chest', equipment: 'Dumbbells', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0314/0.jpg', target: 'Pectorals'),
      Exercise(name: 'Side Lateral Raise', bodyPart: 'Shoulders', equipment: 'Dumbbells', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0334/0.jpg', target: 'Delts'),
      Exercise(name: 'Triceps Pushdown', bodyPart: 'Arms', equipment: 'Cable', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0200/0.jpg', target: 'Triceps'),
    ];
    List<Exercise> pull = [
      Exercise(name: 'Lat Pulldown', bodyPart: 'Back', equipment: 'Cable', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0150/0.jpg', target: 'Lats'),
      Exercise(name: 'Seated Cable Row', bodyPart: 'Back', equipment: 'Cable', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0180/0.jpg', target: 'Lats'),
      Exercise(name: 'Face Pulls', bodyPart: 'Back', equipment: 'Cable', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0200/0.jpg', target: 'Rear Delts'),
      Exercise(name: 'Bicep Curls', bodyPart: 'Arms', equipment: 'Dumbbells', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0294/0.jpg', target: 'Biceps'),
    ];
    List<Exercise> legs = [
      Exercise(name: 'Barbell Squat', bodyPart: 'Legs', equipment: 'Barbell', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0032/0.jpg', target: 'Quads'),
      Exercise(name: 'Leg Press', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0581/0.jpg', target: 'Quads'),
      Exercise(name: 'Leg Curls', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0599/0.jpg', target: 'Hamstrings'),
      Exercise(name: 'Calf Raises', bodyPart: 'Legs', equipment: 'Machine', gifUrl: 'https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/exercises/0751/0.jpg', target: 'Calves'),
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
