import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/household.dart';
import '../../models/member.dart';
import '../../providers/survey_provider.dart';
import '../../widgets/member_card.dart';

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
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
      }
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

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
        final memberFormKey = GlobalKey<FormState>();
        String name = '', gender = 'Male', education = 'None', occupation = 'Student', marital = 'Single';
        int age = 18;
        return AlertDialog(
          title: const Text('Add Family Member'),
          content: Form(
            key: memberFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    onChanged: (v) => name = v,
                    validator: (v) => v!.isEmpty ? 'Name required' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Age'),
                    keyboardType: TextInputType.number,
                    onChanged: (v) => age = int.tryParse(v) ?? 18,
                    validator: (v) => (int.tryParse(v ?? '') == null) ? 'Enter valid age' : null,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: gender,
                    items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => gender = v!,
                    decoration: const InputDecoration(labelText: 'Gender'),
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: education,
                    items: ['None', 'Primary', 'Secondary', 'Tertiary', 'Post-Graduate'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => education = v!,
                    decoration: const InputDecoration(labelText: 'Education'),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Occupation'),
                    onChanged: (v) => occupation = v,
                    validator: (v) => v!.isEmpty ? 'Occupation required' : null,
                  ),
                  DropdownButtonFormField<String>(
                    initialValue: marital,
                    items: ['Single', 'Married', 'Divorced', 'Widowed'].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (v) => marital = v!,
                    decoration: const InputDecoration(labelText: 'Marital Status'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (memberFormKey.currentState!.validate()) {
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
        const SnackBar(content: Text('Please add at least one family member')),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _houseNoController,
                      decoration: const InputDecoration(labelText: 'House Number', icon: Icon(Icons.numbers)),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(labelText: 'Address', icon: Icon(Icons.location_on)),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _localityController,
                      decoration: const InputDecoration(labelText: 'Locality', icon: Icon(Icons.map)),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _headNameController,
                      decoration: const InputDecoration(labelText: 'Head of Family', icon: Icon(Icons.person)),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number', icon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('GPS Coordinates', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_lat != null ? 'Lat: \${_lat!.toStringAsFixed(6)}, Lng: \${_lng!.toStringAsFixed(6)}' : 'Capture current location'),
              trailing: ElevatedButton.icon(
                onPressed: _getLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Locate'),
              ),
              tileColor: Colors.indigo.withValues(alpha: 0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Family Members (\${_members.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: _addMember,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._members.map((m) => MemberCard(
              member: m,
              onDelete: () => setState(() => _members.remove(m)),
            )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('SUBMIT SURVEY RECORD', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
