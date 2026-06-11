import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/survey_provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demographic Analytics')),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          if (provider.totalHouseholds == 0) {
            return const Center(child: Text('No data available for analytics'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(context, 'Gender Distribution'),
                _buildPieChart([
                  _PieData('Male', provider.malePopulation.toDouble(), Colors.blue),
                  _PieData('Female', provider.femalePopulation.toDouble(), Colors.pink),
                ]),
                
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Education Distribution'),
                _buildPieChart(provider.educationDistribution.entries.map((e) {
                  return _PieData(e.key, e.value.toDouble(), _getRandomColor(e.key));
                }).toList()),

                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Age Distribution'),
                _buildBarChart(provider.ageDistribution, Colors.teal),

                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Occupation Distribution'),
                _buildBarChart(provider.occupationDistribution, Colors.orange),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPieChart(List<_PieData> data) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.map((d) => PieChartSectionData(
            value: d.value,
            title: d.title,
            color: d.color,
            radius: 50,
            showTitle: d.value > 0,
            titleStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> distribution, Color color) {
    final keys = distribution.keys.toList();
    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (distribution.values.isEmpty ? 1 : distribution.values.reduce((a, b) => a > b ? a : b)).toDouble() + 1,
          barGroups: List.generate(keys.length, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: distribution[keys[i]]!.toDouble(),
                  color: color,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < keys.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        keys[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 40,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  Color _getRandomColor(String seed) {
    return Colors.primaries[seed.hashCode % Colors.primaries.length];
  }
}

class _PieData {
  final String title;
  final double value;
  final Color color;
  _PieData(this.title, this.value, this.color);
}
