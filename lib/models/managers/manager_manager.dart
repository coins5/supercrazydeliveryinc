import 'package:flutter/foundation.dart';
import 'package:supercrazydeliveryinc/data/default_managers.dart'
    as DefaultManagers;
import '../manager.dart';
import '../delivery_unit.dart';

class ManagerManager extends ChangeNotifier {
  List<Manager> _managers = [];

  List<Manager> get managers => _managers;

  ManagerManager() {
    // Similar to UpgradeManager, managers might depend on units.
    // DefaultManagers.getDefaultManagers(units)
    _managers = [];
  }

  void initialize(List<DeliveryUnit> units) {
    _managers = DefaultManagers.getDefaultManagers(units);
    notifyListeners();
  }

  void setManagers(List<Manager> managers) {
    _managers = managers;
    notifyListeners();
  }

  void hireManager(String managerId) {
    final index = _managers.indexWhere((m) => m.id == managerId);
    if (index != -1) {
      _managers[index] = _managers[index].copyWith(isHired: true);
      notifyListeners();
    }
  }

  void resetManagers(List<DeliveryUnit> units) {
    _managers = DefaultManagers.getDefaultManagers(units);
    notifyListeners();
  }
}
