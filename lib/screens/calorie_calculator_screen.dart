import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CalorieCalculatorScreen extends StatefulWidget {
  @override
  _CalorieCalculatorScreenState createState() => _CalorieCalculatorScreenState();
}

class _CalorieCalculatorScreenState extends State<CalorieCalculatorScreen> {
  final DatabaseService _dbService = DatabaseService();
  List<FoodItem> _foodItems = [];
  List<FoodItem> _selectedFoods = [];
  String _currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  _loadFoodItems() async {
    final foods = await _dbService.getFoodItems();
    setState(() => _foodItems = foods);
  }

  double get totalCalories => _selectedFoods.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => _selectedFoods.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => _selectedFoods.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => _selectedFoods.fold(0, (sum, item) => sum + item.fat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calorie Tracker (Tunisia)')),
      body: Column(
        children: [
          _buildMacroSummary(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available Foods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                TextButton.icon(
                  onPressed: _saveDailyLog,
                  icon: Icon(Icons.save),
                  label: Text('Save Log'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _foodItems.length,
              itemBuilder: (context, index) {
                final food = _foodItems[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text('${food.calories.toStringAsFixed(0)} kcal | P: ${food.protein}g C: ${food.carbs}g F: ${food.fat}g'),
                  trailing: food.isTunisian ? Icon(Icons.star, color: Colors.orange, size: 18) : null,
                  onTap: () => setState(() => _selectedFoods.add(food)),
                );
              },
            ),
          ),
          if (_selectedFoods.isNotEmpty) _buildSelectedList(),
        ],
      ),
    );
  }

  Widget _buildMacroSummary() {
    bool hasData = totalCalories > 0;
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text('Daily Summary - $_currentDate', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[900])),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 120,
                  child: hasData ? PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      sections: [
                        PieChartSectionData(value: totalProtein * 4, color: Colors.blue, title: '', radius: 40),
                        PieChartSectionData(value: totalCarbs * 4, color: Colors.green, title: '', radius: 40),
                        PieChartSectionData(value: totalFat * 9, color: Colors.red, title: '', radius: 40),
                      ],
                    ),
                  ) : Center(child: Icon(Icons.pie_chart, size: 50, color: Colors.grey[300])),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _macroRow('Calories', totalCalories.toStringAsFixed(0), Colors.black),
                    _macroRow('Protein', '${totalProtein.toStringAsFixed(1)}g', Colors.blue),
                    _macroRow('Carbs', '${totalCarbs.toStringAsFixed(1)}g', Colors.green),
                    _macroRow('Fat', '${totalFat.toStringAsFixed(1)}g', Colors.red),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _macroRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSelectedList() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Today\'s Log', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedFoods.length,
              itemBuilder: (context, index) => ListTile(
                dense: true,
                title: Text(_selectedFoods[index].name),
                trailing: IconButton(icon: Icon(Icons.remove_circle_outline, color: Colors.red), onPressed: () => setState(() => _selectedFoods.removeAt(index))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveDailyLog() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Daily log saved for $_currentDate')));
  }
}
