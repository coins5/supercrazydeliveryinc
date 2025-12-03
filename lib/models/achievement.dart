enum AchievementType {
  clicks,
  unitCount,
  money,
  playTime,
  evolutions,
  moneyPerSecond,
  upgrades,
  goldenPackages,
  boosts,
  managersHired,
  allUnitsUnlocked,
  allManagersHired,
  allUpgradesPurchased,
}

class Achievement {
  final String id;
  final String name;
  final String description;
  final AchievementType type;
  final double threshold;
  final String? targetUnitId;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.threshold,
    this.targetUnitId,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    String? id,
    String? name,
    String? description,
    AchievementType? type,
    double? threshold,
    String? targetUnitId,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      threshold: threshold ?? this.threshold,
      targetUnitId: targetUnitId ?? this.targetUnitId,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
