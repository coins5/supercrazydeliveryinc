import 'dart:async';
import 'package:flutter/foundation.dart';
import 'delivery_unit.dart';
import 'upgrade.dart';

import '../data/default_units.dart';
import '../data/default_upgrades.dart';

class GameState extends ChangeNotifier {
  double _money = 0;
  double get money => _money;

  Timer? _timer;

  List<DeliveryUnit> units = getDefaultUnits();

  List<Upgrade> upgrades = getDefaultUpgrades();

  GameState() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  void _tick() {
    double income = 0;
    for (var unit in units) {
      income += unit.totalIncome;
    }
    _money += income;
    notifyListeners();
  }

  void click() {
    _money += 1; // Base click value
    notifyListeners();
  }

  void buyUnit(DeliveryUnit unit) {
    if (_money >= unit.currentCost) {
      _money -= unit.currentCost;
      unit.count++;
      notifyListeners();
    }
  }

  void buyUpgrade(Upgrade upgrade) {
    if (_money >= upgrade.cost && !upgrade.isPurchased) {
      _money -= upgrade.cost;
      upgrade.isPurchased = true;

      if (upgrade.type == UpgradeType.unitMultiplier &&
          upgrade.targetUnitId != null) {
        final unit = units.firstWhere((u) => u.id == upgrade.targetUnitId);
        unit.multiplier *= upgrade.multiplierValue;
      } else if (upgrade.type == UpgradeType.globalMultiplier) {
        for (var unit in units) {
          unit.multiplier *= upgrade.multiplierValue;
        }
      }

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
