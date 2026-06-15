import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../services/database_service.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Diagnostics'),
      ),
      body: Column(
        children: [
          // Diagnostics Card
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Database Storage Path:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  const SizedBox(height: 4),
                  SelectableText(
                    dbService.storagePath,
                    style: const TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Records:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${dbService.householdBox.length} Households', style: const TextStyle(color: Colors.indigo)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Registered Enumerators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: dbService.usersBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return const Center(child: Text('No users registered.'));
                }

                final keys = box.keys.toList();

                return ListView.builder(
                  itemCount: keys.length,
                  itemBuilder: (context, index) {
                    final id = keys[index];
                    final password = box.get(id);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text('ID: $id', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Password: $password'),
                        trailing: id == 'admin' 
                          ? null 
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => box.delete(id),
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
