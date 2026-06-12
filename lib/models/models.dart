import 'dart:convert';

class User {
  final double height;
  final double weight;
  final String bodyType;
  final String goal;
  final int sessionsPerWeek;

  User({
    required this.height,
    required this.weight,
    required this.bodyType,
    required this.goal,
    required this.sessionsPerWeek,
  });

  Map<String, dynamic> toMap() {
    return {
      'height': height,
      'weight': weight,
      'bodyType': bodyType,
      'goal': goal,
      'sessionsPerWeek': sessionsPerWeek,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      height: (map['height'] as num).toDouble(),
      weight: (map['weight'] as num).toDouble(),
      bodyType: map['bodyType'],
      goal: map['goal'],
      sessionsPerWeek: map['sessionsPerWeek'],
    );
  }
}

class Exercise {
  final int? id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String gifUrl;
  final String target;
  final List<String>? instructions;

  Exercise({
    this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.gifUrl,
    required this.target,
    this.instructions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'bodyPart': bodyPart,
      'equipment': equipment,
      'gifUrl': gifUrl,
      'target': target,
      'instructions': instructions != null ? jsonEncode(instructions) : null,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      id: map['id'],
      name: map['name'],
      bodyPart: map['bodyPart'],
      equipment: map['equipment'],
      gifUrl: map['gifUrl'],
      target: map['target'],
      instructions: map['instructions'] != null ? (jsonDecode(map['instructions']) as List).cast<String>() : null,
    );
  }
}

class WorkoutDay {
  final int? id;
  final String dayName;
  final List<Exercise> exercises;
  bool isDone;
  final String? date; // Optional: specific date if assigned

  WorkoutDay({
    this.id,
    required this.dayName,
    required this.exercises,
    this.isDone = false,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dayName': dayName,
      'exercises': jsonEncode(exercises.map((e) => e.toMap()).toList()),
      'isDone': isDone ? 1 : 0,
      'date': date,
    };
  }

  factory WorkoutDay.fromMap(Map<String, dynamic> map) {
    var exList = jsonDecode(map['exercises']) as List;
    return WorkoutDay(
      id: map['id'],
      dayName: map['dayName'],
      exercises: exList.map((e) => Exercise.fromMap(e)).toList(),
      isDone: map['isDone'] == 1,
      date: map['date'],
    );
  }
}

class FoodItem {
  final int? id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final bool isTunisian;

  FoodItem({
    this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.isTunisian = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'isTunisian': isTunisian ? 1 : 0,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      calories: (map['calories'] as num).toDouble(),
      protein: (map['protein'] as num).toDouble(),
      carbs: (map['carbs'] as num).toDouble(),
      fat: (map['fat'] as num).toDouble(),
      isTunisian: map['isTunisian'] == 1,
    );
  }
}
