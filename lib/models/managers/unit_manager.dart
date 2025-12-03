import 'package:flutter/foundation.dart';
import 'package:supercrazydeliveryinc/data/default_units.dart' as DefaultUnits;
import 'dart:math' as math;
import '../delivery_unit.dart';

class UnitManager extends ChangeNotifier {
  List<DeliveryUnit> _units = [];

  List<DeliveryUnit> get units => _units;

  UnitManager() {
    _units = DefaultUnits.getDefaultUnits();
  }

  void setUnits(List<DeliveryUnit> units) {
    _units = units;
    notifyListeners();
  }

  double calculateTotalProduction(double globalMultiplier) {
    double total = 0;
    for (var unit in _units) {
      total += unit.totalIncome * globalMultiplier;
    }
    return total;
  }

  // Returns the cost for the next purchase
  double getUnitCost(DeliveryUnit unit, int amount) {
    // Basic geometric progression cost: base * (growth ^ owned) * ((growth ^ amount - 1) / (growth - 1))
    // Simplified for single buy: base * (growth ^ owned)
    // For bulk buy, we need the formula.

    // Assuming standard idle game formula: Cost = Base * (Growth ^ Count)
    // For N items: Cost = Base * (Growth^Count) * ((Growth^N - 1) / (Growth - 1))

    double growth = 1.15; // Standard growth factor
    double baseCost = unit.baseCost;

    if (amount == 1) {
      return baseCost * math.pow(growth, unit.count);
    } else {
      return baseCost *
          math.pow(growth, unit.count) *
          ((math.pow(growth, amount) - 1) / (growth - 1));
    }
  }

  void buyUnit(String unitId, int amount) {
    final index = _units.indexWhere((u) => u.id == unitId);
    if (index != -1) {
      _units[index] = _units[index].copyWith(
        count: _units[index].count + amount,
      );
      notifyListeners();
    }
  }

  // Reset for prestige
  void resetUnits() {
    for (int i = 0; i < _units.length; i++) {
      _units[i] = _units[i].copyWith(
        count: 0,
        multiplier: 1.0,
        evolutionStage: 0,
      );
    }
    notifyListeners();
  }
}
