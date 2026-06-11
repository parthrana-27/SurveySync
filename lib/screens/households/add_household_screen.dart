import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/household.dart';
import '../../models/member.dart';
import '../../providers/survey_provider.dart';

class AddHouseholdScreen extends StatefulWidget {
  const AddHouseholdScreen({super.key});

  @override
  State<AddHouseholdScreen> createState() => _AddHouseholdScreenState();
}

class _AddHouseholdScreenState extends State<AddHouseholdScreen> {
  final _formKey = GlobalKey<FormState>();
  final _houseNoController = TextEditingController();
  final _addressController = TextEditingController();
  final _localityController = TextEditingController();
  final _headNameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  double? _lat, _lng;
  final List<Member> _members = [];

  void _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _lat = position.latitude;
      _lng = position.longitude;
    });
  }

  void _addMember() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '', gender = 'Male', education = 'None', occupation = 'Student', marital = 'Single';
        int age = 18;
        return AlertDialog(
          title: const Text('Add Family Member'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(decoration: const InputDecoration(labelText: 'Name'), onChanged: (v) => name = v),
                TextField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => age = int.tryParse(v) ?? 18,
                ),
                DropdownButtonFormField<String>(
                  initialValue: gender,
                  items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (v) => gender = v!,
                  decoration: const InputDecoration(labelText: 'Gender'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  setState(() {
                    _members.add(Member(
                      id: const Uuid().v4(),
                      name: name,
                      age: age,
                      gender: gender,
                      education: education,
                      occupation: occupation,
                      maritalStatus: marital,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _save() {
    if (_formKey.currentState!.validate() && _members.isNotEmpty) {
      final household = Household(
        id: const Uuid().v4(),
        houseNumber: _houseNoController.text,
        address: _addressController.text,
        locality: _localityController.text,
        headName: _headNameController.text,
        phoneNumber: _phoneController.text,
        latitude: _lat ?? 0.0,
        longitude: _lng ?? 0.0,
        createdAt: DateTime.now(),
        members: _members,
      );
      context.read<SurveyProvider>().addHousehold(household);
      Navigator.pop(context);
    } else if (_members.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one member')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Household Survey')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _houseNoController, decoration: const InputDecoration(labelText: 'House Number')),
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
            TextFormField(controller: _localityController, decoration: const InputDecoration(labelText: 'Locality')),
            TextFormField(controller: _headNameController, decoration: const InputDecoration(labelText: 'Head of Family')),
            TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number')),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('GPS Coordinates'),
              subtitle: Text(_lat != null ? 'Lat: $_lat, Lng: $_lng' : 'Not captured'),
              trailing: IconButton(icon: const Icon(Icons.location_on), onPressed: _getLocation),
              tileColor: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Family Members (${_members.length})', style: Theme.of(context).textTheme.titleMedium),
                TextButton.icon(onPressed: _addMember, icon: const Icon(Icons.add), label: const Text('Add Member')),
              ],
            ),
            ..._members.map((m) => Card(
              child: ListTile(
                title: Text(m.name),
                subtitle: Text('Age: ${m.age}, Gender: ${m.gender}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () => setState(() => _members.remove(m)),
                ),
              ),
            )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Survey Record'),
            ),
          ],
        ),
      ),
    );
  }
}
