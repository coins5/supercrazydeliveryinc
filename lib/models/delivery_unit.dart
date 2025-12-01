import 'dart:math' as math;

class DeliveryUnit {
  final String id;
  final String name;
  final String description;
  final double baseCost;
  final double baseIncome;
  int count;
  double multiplier;

  int evolutionStage = 0;

  DeliveryUnit({
    required this.id,
    required this.name,
    required this.description,
    required this.baseCost,
    required this.baseIncome,
    this.count = 0,
    this.multiplier = 1.0,
    this.evolutionStage = 0,
  });

  double getCost(bool isHardMode) {
    if (isHardMode) {
      return baseCost * math.pow(1.09, count);
    }
    return baseCost * (1 + 0.15 * count); // Simple cost scaling
  }

  double get evolutionMultiplier {
    if (count >= 1000) return 10000.0;
    if (count >= 500) return 1000.0;
    if (count >= 250) return 100.0;
    if (count >= 100) return 10.0;
    return 1.0;
  }

  String get evolvedName {
    if (count >= 1000) return "Godlike $name";
    if (count >= 500) return "Quantum $name";
    if (count >= 250) return "Radioactive $name";
    if (count >= 100) return "Turbo $name";
    return name;
  }

  double get totalIncome {
    return baseIncome * count * multiplier * evolutionMultiplier;
  }
}
