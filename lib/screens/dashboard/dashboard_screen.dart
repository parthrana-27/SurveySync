import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/survey_provider.dart';
import '../../widgets/summary_card.dart';
import '../../widgets/household_card.dart';
import '../../widgets/empty_state_widget.dart';
import '../../services/export_service.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../households/household_list_screen.dart';
import '../households/add_household_screen.dart';
import '../households/map_view_screen.dart';
import '../analytics/analytics_screen.dart';
import '../settings/user_management_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SurveySync Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'User Management',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserManagementScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
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
                if (AuthService.enumeratorId != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Welcome, Enumerator: ${AuthService.enumeratorId}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                        icon: Icons.map,
                        label: 'Map View',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MapViewScreen()),
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
                        icon: Icons.download,
                        label: 'Export Data',
                        onTap: () {
                          _showExportDialog(context, provider);
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Surveys',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HouseholdListScreen()),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (provider.households.isEmpty)
                  const EmptyStateWidget(
                    message: 'No surveys conducted yet',
                    icon: Icons.history,
                  )
                else
                  ...provider.households.take(3).map((h) => HouseholdCard(
                    household: h,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Details for House ${h.houseNumber}')),
                      );
                    },
                    onDelete: () => provider.deleteHousehold(h.id),
                  )),
                const SizedBox(height: 32),
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
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Share: Opens the system sharing menu.'),
            SizedBox(height: 8),
            Text('Download: Saves directly to your Downloads folder (Android).'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text('JSON', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
            ),
            onSelected: (value) async {
              Navigator.pop(context);
              if (value == 'share') {
                await ExportService.shareJson(provider.households);
              } else {
                final path = await ExportService.downloadToStorage(provider.households, 'json');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(path != null ? 'Downloaded to: \$path' : 'Download failed')),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'share', child: Text('Share JSON')),
              const PopupMenuItem(value: 'download', child: Text('Download JSON')),
            ],
          ),
          PopupMenuButton<String>(
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Text('CSV', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold)),
            ),
            onSelected: (value) async {
              Navigator.pop(context);
              if (value == 'share') {
                await ExportService.shareCsv(provider.households);
              } else {
                final path = await ExportService.downloadToStorage(provider.households, 'csv');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(path != null ? 'Downloaded to: \$path' : 'Download failed')),
                  );
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'share', child: Text('Share CSV')),
              const PopupMenuItem(value: 'download', child: Text('Download CSV')),
            ],
          ),
          TextButton(
            onPressed: () {
              final users = ExportService.exportUsers();
              debugPrint('--- REGISTERED USERS ---');
              debugPrint(users);
              debugPrint('------------------------');
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Users Exported to Console')));
            },
            child: const Text('Debug Users'),
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
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Colors.indigo),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
