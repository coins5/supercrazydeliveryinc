enum UpgradeType { unitMultiplier, globalMultiplier, clickMultiplier }

class Upgrade {
  final String id;
  final String name;
  final String description;
  final double cost;
  final UpgradeType type;
  final String? targetUnitId; // Only for unitMultiplier
  final double multiplierValue;
  bool isPurchased;

  Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.type,
    required this.multiplierValue,
    this.targetUnitId,
    this.isPurchased = false,
  });
}
