import 'dart:convert';
import '../models/household.dart';

class ExportService {
  static String toJson(List<Household> households) {
    List<Map<String, dynamic>> data = households.map((h) => {
      'id': h.id,
      'houseNumber': h.houseNumber,
      'address': h.address,
      'locality': h.locality,
      'headName': h.headName,
      'phoneNumber': h.phoneNumber,
      'latitude': h.latitude,
      'longitude': h.longitude,
      'createdAt': h.createdAt.toIso8601String(),
      'members': h.members.map((m) => {
        'id': m.id,
        'name': m.name,
        'age': m.age,
        'gender': m.gender,
        'education': m.education,
        'occupation': m.occupation,
        'maritalStatus': m.maritalStatus,
      }).toList(),
    }).toList();
    return jsonEncode(data);
  }

  static String toCsv(List<Household> households) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('ID,House Number,Address,Locality,Head Name,Phone,Latitude,Longitude,Member Count');
    for (var h in households) {
      buffer.writeln('${h.id},${h.houseNumber},"${h.address}",${h.locality},"${h.headName}",${h.phoneNumber},${h.latitude},${h.longitude},${h.members.length}');
    }
    return buffer.toString();
  }
}
