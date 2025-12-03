import 'package:flutter/foundation.dart';
import '../upgrade.dart';
import '../delivery_unit.dart';
import 'package:supercrazydeliveryinc/data/default_upgrades.dart'
    as DefaultUpgrades;

class UpgradeManager extends ChangeNotifier {
  List<Upgrade> _upgrades = [];

  List<Upgrade> get upgrades => _upgrades;

  UpgradeManager() {
    // We need units to initialize upgrades properly, but UnitManager is separate.
    // This is a dependency issue. GameState should initialize this with units.
    // For now, we initialize with empty or default units if possible,
    // BUT getDefaultUpgrades REQUIRES units.
    // So we should probably pass units to setUpgrades or constructor.
    // Let's initialize with empty list and wait for set.
    _upgrades = [];
  }

  void initialize(List<DeliveryUnit> units) {
    _upgrades = DefaultUpgrades.getDefaultUpgrades(units);
    notifyListeners();
  }

  void setUpgrades(List<Upgrade> upgrades) {
    _upgrades = upgrades;
    notifyListeners();
  }

  double calculateGlobalMultiplier() {
    double multiplier = 1.0;
    for (var upgrade in _upgrades) {
      if (upgrade.isPurchased) {
        if (upgrade.type == UpgradeType.globalMultiplier) {
          multiplier *= upgrade.multiplierValue;
        }
      }
    }
    return multiplier;
  }

  double getClickMultiplier() {
    double multiplier = 1.0;
    for (var upgrade in _upgrades) {
      if (upgrade.isPurchased) {
        if (upgrade.type == UpgradeType.clickMultiplier) {
          multiplier *= upgrade.multiplierValue;
        }
      }
    }
    return multiplier;
  }

  void buyUpgrade(String upgradeId) {
    final index = _upgrades.indexWhere((u) => u.id == upgradeId);
    if (index != -1) {
      _upgrades[index] = _upgrades[index].copyWith(isPurchased: true);
      notifyListeners();
    }
  }

  void resetUpgrades(List<DeliveryUnit> units) {
    _upgrades = DefaultUpgrades.getDefaultUpgrades(units);
    notifyListeners();
  }
}
