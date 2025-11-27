enum AchievementType { money, clicks, orders, playTime, unitCount }

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
}
