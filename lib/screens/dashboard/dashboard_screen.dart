import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/survey_provider.dart';
import '../../widgets/summary_card.dart';
import '../../services/export_service.dart';
import '../households/household_list_screen.dart';
import '../households/add_household_screen.dart';
import '../analytics/analytics_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SurveySync Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    SummaryCard(
                      title: 'Total Households',
                      value: provider.totalHouseholds.toString(),
                      icon: Icons.home,
                      color: Colors.indigo,
                    ),
                    SummaryCard(
                      title: 'Total Population',
                      value: provider.totalPopulation.toString(),
                      icon: Icons.people,
                      color: Colors.teal,
                    ),
                    SummaryCard(
                      title: 'Male',
                      value: provider.malePopulation.toString(),
                      icon: Icons.male,
                      color: Colors.blue,
                    ),
                    SummaryCard(
                      title: 'Female',
                      value: provider.femalePopulation.toString(),
                      icon: Icons.female,
                      color: Colors.pink,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.add_home,
                        label: 'New Survey',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddHouseholdScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.list_alt,
                        label: 'View All',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HouseholdListScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.bar_chart,
                        label: 'Analytics',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.download,
                        label: 'Export Data',
                        onTap: () {
                          _showExportDialog(context, provider);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showExportDialog(BuildContext context, SurveyProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Select export format:'),
        actions: [
          TextButton(
            onPressed: () {
              final json = ExportService.toJson(provider.households);
              debugPrint(json);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('JSON Exported to Console')));
            },
            child: const Text('JSON'),
          ),
          TextButton(
            onPressed: () {
              final csv = ExportService.toCsv(provider.households);
              debugPrint(csv);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV Exported to Console')));
            },
            child: const Text('CSV'),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
