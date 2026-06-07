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
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: provider.malePopulation.toDouble(),
                          title: 'Male',
                          color: Colors.blue,
                          radius: 50,
                          showTitle: true,
                        ),
                        PieChartSectionData(
                          value: provider.femalePopulation.toDouble(),
                          title: 'Female',
                          color: Colors.pink,
                          radius: 50,
                          showTitle: true,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(context, 'Age Distribution'),
                SizedBox(
                  height: 250,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: _buildAgeGroups(provider.ageDistribution),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const titles = ['0-18', '19-35', '36-60', '60+'];
                              return Text(titles[value.toInt()]);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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

  List<BarChartGroupData> _buildAgeGroups(Map<String, int> distribution) {
    final keys = ['0-18', '19-35', '36-60', '60+'];
    return List.generate(keys.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: distribution[keys[i]]!.toDouble(),
            color: Colors.teal,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }
}
