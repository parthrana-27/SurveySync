import 'package:flutter/material.dart';
import '../models/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final VoidCallback? onDelete;

  const MemberCard({
    super.key,
    required this.member,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.withValues(alpha: 0.1),
          child: Text(
            member.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Age: ${member.age} | ${member.gender}'),
        trailing: onDelete != null 
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            )
          : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Education', member.education),
                _buildInfoRow('Occupation', member.occupation),
                _buildInfoRow('Marital Status', member.maritalStatus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
