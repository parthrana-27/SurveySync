import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/survey_provider.dart';
import '../../widgets/household_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/empty_state_widget.dart';
import 'add_household_screen.dart';

class HouseholdListScreen extends StatelessWidget {
  const HouseholdListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Households'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SearchBarWidget(
            hintText: 'Search by house number or head...',
            onChanged: (value) => context.read<SurveyProvider>().setSearchQuery(value),
          ),
        ),
      ),
      body: Consumer<SurveyProvider>(
        builder: (context, provider, child) {
          final households = provider.households;
          if (households.isEmpty) {
            return const EmptyStateWidget(
              message: 'No households found',
              icon: Icons.search_off,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: households.length,
            itemBuilder: (context, index) {
              final household = households[index];
              return HouseholdCard(
                household: household,
                onTap: () {
                  // Navigate to details/edit if needed
                },
                onDelete: () {
                  _showDeleteDialog(context, provider, household.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddHouseholdScreen()),
          );
        },
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, SurveyProvider provider, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Household'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              provider.deleteHousehold(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
