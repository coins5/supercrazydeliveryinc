enum UpgradeType { unitMultiplier, globalMultiplier, clickMultiplier }

class Upgrade {
  final String id;
  final String name;
  final String description;
  final double cost;

  double getCost(bool isHardMode) {
    if (isHardMode) {
      return cost * 2.5;
    }
    return cost;
  }

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

  Upgrade copyWith({
    String? id,
    String? name,
    String? description,
    double? cost,
    UpgradeType? type,
    double? multiplierValue,
    String? targetUnitId,
    bool? isPurchased,
  }) {
    return Upgrade(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      multiplierValue: multiplierValue ?? this.multiplierValue,
      targetUnitId: targetUnitId ?? this.targetUnitId,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
