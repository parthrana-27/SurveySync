import 'package:flutter/material.dart';
import '../models/household.dart';
import '../services/database_service.dart';

class SurveyProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Household> _households = [];
  String _searchQuery = '';
  String _localityFilter = 'All';

  List<Household> get households {
    return _households.where((h) {
      final matchesSearch = h.houseNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          h.headName.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesLocality = _localityFilter == 'All' || h.locality == _localityFilter;
      return matchesSearch && matchesLocality;
    }).toList();
  }

  SurveyProvider() {
    loadHouseholds();
  }

  void loadHouseholds() {
    _households = _dbService.getAllHouseholds();
    notifyListeners();
  }

  Future<void> addHousehold(Household household) async {
    await _dbService.addHousehold(household);
    loadHouseholds();
  }

  Future<void> updateHousehold(Household household) async {
    await _dbService.updateHousehold(household);
    loadHouseholds();
  }

  Future<void> deleteHousehold(String id) async {
    await _dbService.deleteHousehold(id);
    loadHouseholds();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setLocalityFilter(String locality) {
    _localityFilter = locality;
    notifyListeners();
  }

  // Analytics Helpers
  int get totalHouseholds => _households.length;
  
  int get totalPopulation {
    return _households.fold(0, (sum, h) => sum + h.members.length);
  }

  int get malePopulation {
    return _households.fold(0, (sum, h) {
      return sum + h.members.where((m) => m.gender == 'Male').length;
    });
  }

  int get femalePopulation {
    return _households.fold(0, (sum, h) {
      return sum + h.members.where((m) => m.gender == 'Female').length;
    });
  }

  Map<String, int> get ageDistribution {
    Map<String, int> distribution = {'0-18': 0, '19-35': 0, '36-60': 0, '60+': 0};
    for (var h in _households) {
      for (var m in h.members) {
        if (m.age <= 18) {
          distribution['0-18'] = distribution['0-18']! + 1;
        } else if (m.age <= 35) {
          distribution['19-35'] = distribution['19-35']! + 1;
        } else if (m.age <= 60) {
          distribution['36-60'] = distribution['36-60']! + 1;
        } else {
          distribution['60+'] = distribution['60+']! + 1;
        }
      }
    }
    return distribution;
  }

  Map<String, int> get occupationDistribution {
    Map<String, int> distribution = {};
    for (var h in _households) {
      for (var m in h.members) {
        distribution[m.occupation] = (distribution[m.occupation] ?? 0) + 1;
      }
    }
    return distribution;
  }

  Map<String, int> get educationDistribution {
    Map<String, int> distribution = {};
    for (var h in _households) {
      for (var m in h.members) {
        distribution[m.education] = (distribution[m.education] ?? 0) + 1;
      }
    }
    return distribution;
  }
}
