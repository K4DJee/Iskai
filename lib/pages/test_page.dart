import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:iskai/database/sqfliteDatabase.dart';
import 'package:iskai/models/statistics.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<FlSpot> spots = [];
  List<String> dateLabels = [];
  List<Statistics> stats = [];
  int allWordsLearned = 0;
  double averageAnswersPerDay = 0;
  int allCorrectWords = 0;
  int allIncorrectWords = 0;
  int allAnswers = 0;

  bool _isLoading = true;
  void loadData() async {
    // await Future.delayed(Duration(seconds: 1));
    final db = SQLiteDatabase.instance;
    final List<Statistics> stats = await db.getStatistics(3);
    final generatedSpots = stats.asMap().entries.map((entry) {
      final index = entry.key.toDouble(); // индекс = X
      final stat = entry.value;
      final value = stat.wordsLearnedToday?.toDouble() ?? 0; // любое поле для Y
      return FlSpot(index, value);
    }).toList();
    final generatedLabels = stats.map((stat) {
      final date = DateTime.parse(stat.createdAt!);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      return '$day.$month';
    }).toList();
    setState(() {
      allWordsLearned = stats
          .map((stat) => stat.wordsLearnedToday!)
          .reduce((value, element) => value + element);
      allAnswers = stats
          .map((stat) => stat.amountAnswersPerDay!)
          .reduce((value, element) => value + element);
      allCorrectWords = stats
          .map((stat) => stat.amountCorrectAnswers!)
          .reduce((value, element) => value + element);
      allIncorrectWords = stats
          .map((stat) => stat.amountIncorrectAnswers!)
          .reduce((value, element) => value + element);
      averageAnswersPerDay = stats.isNotEmpty ? allAnswers / stats.length : 0;
      spots = generatedSpots;
      dateLabels = generatedLabels;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final chartWidth = spots.length * 80.0;
    return Scaffold(
      appBar: AppBar(title: Text('Тест')),
      body: Column(
        children: [
          SizedBox(
            height: 175,
            child: _isLoading == false
                ? SizedBox(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: chartWidth,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 45,
                            right: 20,
                            left: 20,
                          ),
                          child: LineChart(
                            LineChartData(
                              titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 1,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      if (index < 0 ||
                                          index >= dateLabels.length) {
                                        return const SizedBox();
                                      }
                                      return Text(
                                        dateLabels[index],
                                        style: const TextStyle(fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: false, // сглаживание
                                  color: Colors.orange,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                  ), // скрыть точки
                                ),
                              ],
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      return LineTooltipItem(
                                        '${spot.y.toInt()}',
                                        const TextStyle(color: Colors.orange),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(title: Text('Изучено слов: $allWordsLearned')),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(title: Text('Общее количество ответов: $allAnswers')),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    'Количество правильных ответов: $allCorrectWords',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    'Количество неправильных ответов: $allIncorrectWords',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
                ListTile(
                  title: Text(
                    'Среднее количество ответов в день: ${averageAnswersPerDay.toStringAsFixed(2)}',
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
