import 'package:flutter/material.dart';
import '../models/household.dart';

class HouseholdCard extends StatelessWidget {
  final Household household;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const HouseholdCard({
    super.key,
    required this.household,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Colors.indigo.withOpacity(0.1),
          child: const Icon(Icons.house, color: Colors.indigo),
        ),
        title: Text(
          'House No: ${household.houseNumber}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Head: ${household.headName}\nLocality: ${household.locality}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${household.members.length} Members',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
