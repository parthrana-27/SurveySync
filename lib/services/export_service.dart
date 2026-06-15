import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/household.dart';

class ExportService {
  static String _generateJson(List<Household> households) {
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

  static String _generateCsv(List<Household> households) {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('ID,House Number,Address,Locality,Head Name,Phone,Latitude,Longitude,Member Count');
    for (var h in households) {
      buffer.writeln('${h.id},${h.houseNumber},"${h.address}",${h.locality},"${h.headName}",${h.phoneNumber},${h.latitude},${h.longitude},${h.members.length}');
    }
    return buffer.toString();
  }

  // Method to share (opens system dialog)
  static Future<void> shareJson(List<Household> households) async {
    final json = _generateJson(households);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/surveys_export.json');
    await file.writeAsString(json);
    await Share.shareXFiles([XFile(file.path)], text: 'SurveySync JSON Data Export');
  }

  static Future<void> shareCsv(List<Household> households) async {
    final csv = _generateCsv(households);
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/surveys_export.csv');
    await file.writeAsString(csv);
    await Share.shareXFiles([XFile(file.path)], text: 'SurveySync CSV Data Export');
  }

  // Method to download (saves directly to Downloads folder on Android)
  static Future<String?> downloadToStorage(List<Household> households, String format) async {
    final data = format == 'json' ? _generateJson(households) : _generateCsv(households);
    final fileName = 'SurveySync_Export_${DateTime.now().millisecondsSinceEpoch}.$format';

    if (Platform.isAndroid) {
      // Check storage permissions
      if (await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted) {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        final file = File('${directory.path}/$fileName');
        await file.writeAsString(data);
        return file.path;
      }
    } else if (Platform.isIOS) {
      // On iOS, we use the share API as it's the standard way to "download" to Files
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(data);
      await Share.shareXFiles([XFile(file.path)], text: 'SurveySync Export');
      return file.path;
    }
    return null;
  }

  static String exportUsers() {
    final usersBox = Hive.box('users');
    Map<String, String> users = {};
    for (var key in usersBox.keys) {
      users[key.toString()] = usersBox.get(key).toString();
    }
    return const JsonEncoder.withIndent('  ').convert(users);
  }
}
