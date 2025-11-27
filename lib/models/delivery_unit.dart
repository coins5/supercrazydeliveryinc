class DeliveryUnit {
  final String id;
  final String name;
  final String description;
  final double baseCost;
  final double baseIncome;
  int count;
  double multiplier;

  DeliveryUnit({
    required this.id,
    required this.name,
    required this.description,
    required this.baseCost,
    required this.baseIncome,
    this.count = 0,
    this.multiplier = 1.0,
  });

  double get currentCost {
    return baseCost * (1 + 0.15 * count); // Simple cost scaling
  }

  double get totalIncome {
    return baseIncome * count * multiplier;
  }
}
