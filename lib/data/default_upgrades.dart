import '../models/upgrade.dart';
import '../models/delivery_unit.dart';

List<Upgrade> getDefaultUpgrades(List<DeliveryUnit> units) {
  List<Upgrade> upgrades = [];

  // 1. Click Upgrades (20 Tiers)
  double clickUpgradeCost = 500;

  for (int i = 1; i <= 20; i++) {
    upgrades.add(
      Upgrade(
        id: 'click_upgrade_$i',
        name: 'Crazy Clicker Tier $i',
        description: 'Multiplies click value by 2.',
        cost: clickUpgradeCost,
        multiplierValue: 2.0,
        type: UpgradeType.clickMultiplier,
      ),
    );

    clickUpgradeCost *= 5; // Expensive!
  }

  // 2. Unit Upgrades (10 Tiers per Unit)
  for (var unit in units) {
    double upgradeCost = unit.baseCost * 10;

    for (int tier = 1; tier <= 10; tier++) {
      double multiplier = 2.0;
      String name = "${unit.name} Upgrade $tier";
      String description = "Doubles income of ${unit.name}.";

      // Special Tiers
      if (tier == 5) {
        multiplier = 5.0;
        description = "Quintuples income of ${unit.name}!";
      } else if (tier == 10) {
        multiplier = 100.0; // Crazy Tier 10
        description = "Multiplies income of ${unit.name} by 100!!!";
      }

      upgrades.add(
        Upgrade(
          id: 'upgrade_${unit.id}_$tier',
          name: name,
          description: description,
          cost: upgradeCost,
          multiplierValue: multiplier,
          type: UpgradeType.unitMultiplier,
          targetUnitId: unit.id,
        ),
      );

      // Cost scaling for next tier
      upgradeCost *= 8;
    }
  }

  // Sort by cost
  upgrades.sort((a, b) => a.cost.compareTo(b.cost));

  return upgrades;
}
