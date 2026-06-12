import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'traininy.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        height REAL,
        weight REAL,
        bodyType TEXT,
        goal TEXT,
        sessionsPerWeek INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE food_items(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        calories REAL,
        protein REAL,
        carbs REAL,
        fat REAL,
        isTunisian INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_logs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        calories REAL,
        protein REAL,
        carbs REAL,
        fat REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE workout_program(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dayName TEXT,
        exercises TEXT,
        isDone INTEGER,
        date TEXT
      )
    ''');

    await _seedFoods(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS workout_program(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          dayName TEXT,
          exercises TEXT,
          isDone INTEGER,
          date TEXT
        )
      ''');
    }
  }

  Future<void> _seedFoods(Database db) async {
    List<FoodItem> initialFoods = [
      FoodItem(name: 'Couscous Lamb', calories: 960, protein: 45, carbs: 118, fat: 33, isTunisian: true),
      FoodItem(name: 'Fricassé', calories: 590, protein: 25, carbs: 56, fat: 28, isTunisian: true),
      FoodItem(name: 'Lablabi', calories: 600, protein: 30, carbs: 80, fat: 15, isTunisian: true),
      FoodItem(name: 'Brik Egg', calories: 250, protein: 12, carbs: 15, fat: 18, isTunisian: true),
      FoodItem(name: 'Chicken Breast (100g)', calories: 165, protein: 31, carbs: 0, fat: 3.6),
      FoodItem(name: 'Brown Rice (100g)', calories: 111, protein: 2.6, carbs: 23, fat: 0.9),
    ];

    for (var food in initialFoods) {
      await db.insert('food_items', food.toMap());
    }
  }

  // User methods
  Future<void> saveUser(User user) async {
    Database db = await database;
    await db.delete('user');
    await db.insert('user', user.toMap());
  }

  Future<User?> getUser() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('user');
    if (maps.isNotEmpty) return User.fromMap(maps.first);
    return null;
  }

  // Program methods
  Future<void> saveProgram(List<WorkoutDay> program) async {
    Database db = await database;
    await db.delete('workout_program');
    for (var day in program) {
      await db.insert('workout_program', day.toMap());
    }
  }

  Future<List<WorkoutDay>> getProgram() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('workout_program');
    return maps.map((m) => WorkoutDay.fromMap(m)).toList();
  }

  Future<void> updateWorkoutDay(WorkoutDay day) async {
    Database db = await database;
    await db.update('workout_program', day.toMap(), where: 'id = ?', whereArgs: [day.id]);
  }

  // Food methods
  Future<int> insertFood(FoodItem food) async {
    Database db = await database;
    return await db.insert('food_items', food.toMap());
  }

  Future<List<FoodItem>> getFoodItems() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('food_items');
    return List.generate(maps.length, (i) => FoodItem.fromMap(maps[i]));
  }
}
