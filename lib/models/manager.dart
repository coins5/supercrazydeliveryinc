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

  double getCost(bool isHardMode) {
    if (isHardMode) {
      return cost * 2.5;
    }
    return cost;
  }

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

  Manager copyWith({
    String? id,
    String? name,
    String? description,
    double? cost,
    ManagerType? type,
    double? value,
    String? targetUnitId,
    bool? isHired,
  }) {
    return Manager(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cost: cost ?? this.cost,
      type: type ?? this.type,
      value: value ?? this.value,
      targetUnitId: targetUnitId ?? this.targetUnitId,
      isHired: isHired ?? this.isHired,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'isHired': isHired};
  }
}
