import 'dart:async';
import 'package:flutter/foundation.dart';
import 'delivery_unit.dart';
import 'upgrade.dart';

class GameState extends ChangeNotifier {
  double _money = 0;
  double get money => _money;

  Timer? _timer;

  List<DeliveryUnit> units = [
    DeliveryUnit(
      id: 'grandma',
      name: 'Grandma on Skates',
      description: 'Slow but reliable. Cookies included.',
      baseCost: 10,
      baseIncome: 1,
    ),
    DeliveryUnit(
      id: 'drone',
      name: 'Rusty Drone',
      description: 'Might drop the package, but it flies.',
      baseCost: 100,
      baseIncome: 5,
    ),
    DeliveryUnit(
      id: 'pigeon_flock',
      name: 'Pigeon Flock',
      description: 'Thousands of them. Very messy.',
      baseCost: 500,
      baseIncome: 12,
    ),
    DeliveryUnit(
      id: 'rocket_pizza',
      name: 'Rocket Pizza',
      description: 'Delivered hot, or it explodes.',
      baseCost: 1000,
      baseIncome: 50,
    ),
    DeliveryUnit(
      id: 'skateboard_kid',
      name: 'Skateboard Kid',
      description: 'Radical delivery speeds.',
      baseCost: 2500,
      baseIncome: 100,
    ),
    DeliveryUnit(
      id: 'unicycle_clown',
      name: 'Unicycle Clown',
      description: 'Honk honk! Delivery is here!',
      baseCost: 7500,
      baseIncome: 250,
    ),
    DeliveryUnit(
      id: 'catapult',
      name: 'Package Catapult',
      description: 'Yeet the package!',
      baseCost: 20000,
      baseIncome: 600,
    ),
    DeliveryUnit(
      id: 'cannon',
      name: 'Delivery Cannon',
      description: 'Precision is overrated.',
      baseCost: 50000,
      baseIncome: 1500,
    ),
    DeliveryUnit(
      id: 'teleporting_dog',
      name: 'Teleporting Dog',
      description: 'Good boy appears instantly.',
      baseCost: 150000,
      baseIncome: 4000,
    ),
    DeliveryUnit(
      id: 'ufo',
      name: 'UFO',
      description: 'Abducting packages to their destination.',
      baseCost: 500000,
      baseIncome: 12000,
    ),
    DeliveryUnit(
      id: 'portal_gun',
      name: 'Portal Gun',
      description: 'Thinking with portals.',
      baseCost: 1500000,
      baseIncome: 35000,
    ),
    DeliveryUnit(
      id: 'time_traveler',
      name: 'Time Traveler',
      description: 'Delivered yesterday.',
      baseCost: 5000000,
      baseIncome: 100000,
    ),
    DeliveryUnit(
      id: 'black_hole',
      name: 'Black Hole Courier',
      description: 'Sucks the package to the customer.',
      baseCost: 20000000,
      baseIncome: 400000,
    ),
    DeliveryUnit(
      id: 'quantum_entanglement',
      name: 'Quantum Entanglement',
      description: 'Spooky action at a distance.',
      baseCost: 100000000,
      baseIncome: 2000000,
    ),
    DeliveryUnit(
      id: 'warp_drive_van',
      name: 'Warp Drive Van',
      description: 'Engage!',
      baseCost: 500000000,
      baseIncome: 10000000,
    ),
    DeliveryUnit(
      id: 'hyperspace_bike',
      name: 'Hyperspace Bike',
      description: 'Pedal through the 4th dimension.',
      baseCost: 2000000000,
      baseIncome: 40000000,
    ),
    DeliveryUnit(
      id: 'wormhole_express',
      name: 'Wormhole Express',
      description: 'Shortcuts through space-time.',
      baseCost: 10000000000,
      baseIncome: 200000000,
    ),
    DeliveryUnit(
      id: 'multiverse_skipper',
      name: 'Multiverse Skipper',
      description: 'Delivers to all parallel universes.',
      baseCost: 50000000000,
      baseIncome: 1000000000,
    ),
    DeliveryUnit(
      id: 'reality_bender',
      name: 'Reality Bender',
      description: 'I reject your reality and substitute my delivery.',
      baseCost: 200000000000,
      baseIncome: 4000000000,
    ),
    DeliveryUnit(
      id: 'omnipresent_postman',
      name: 'Omnipresent Postman',
      description: 'He is everywhere, always.',
      baseCost: 1000000000000,
      baseIncome: 20000000000,
    ),
  ];

  List<Upgrade> upgrades = [
    Upgrade(
      id: 'grandma_cookies',
      name: 'Grandma\'s Cookies',
      description: 'Grandmas work twice as hard for cookies.',
      cost: 500,
      type: UpgradeType.unitMultiplier,
      targetUnitId: 'grandma',
      multiplierValue: 2.0,
    ),
    Upgrade(
      id: 'drone_battery',
      name: 'Lithium Batteries',
      description: 'Drones fly longer.',
      cost: 5000,
      type: UpgradeType.unitMultiplier,
      targetUnitId: 'drone',
      multiplierValue: 2.0,
    ),
    Upgrade(
      id: 'coffee_break',
      name: 'Coffee for Everyone',
      description: 'Global productivity boost!',
      cost: 100000,
      type: UpgradeType.globalMultiplier,
      multiplierValue: 1.2,
    ),
  ];

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
