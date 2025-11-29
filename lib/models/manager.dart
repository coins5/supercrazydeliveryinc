enum ManagerType {
  autoClick, // Clicks per second
  unitBoost, // Multiplier for specific unit
  discount, // Global discount percentage (0.1 = 10%)
}

class Manager {
  final String id;
  final String name;
  final String description;
  final double cost;
  final ManagerType type;
  final double value;
  final String? targetUnitId;
  bool isHired;

  Manager({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.type,
    required this.value,
    this.targetUnitId,
    this.isHired = false,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'isHired': isHired};
  }
}
