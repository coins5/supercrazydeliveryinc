import 'dart:async';
import 'package:flutter/foundation.dart';
import 'delivery_unit.dart';
import 'upgrade.dart';
import 'achievement.dart';

import '../data/default_units.dart';
import '../data/default_upgrades.dart';
import '../data/default_achievements.dart';

class GameState extends ChangeNotifier {
  double _money = 0;
  double get money => _money;

  // Statistics
  int _totalClicks = 0;
  int get totalClicks => _totalClicks;

  double _totalMoneyEarned = 0;
  double get totalMoneyEarned => _totalMoneyEarned;

  int _totalOrders = 0;
  int get totalOrders => _totalOrders;

  int _secondsPlayed = 0;
  String get playTime => _formatDuration(_secondsPlayed);

  int _totalEvolutions = 0;
  int get totalEvolutions => _totalEvolutions;

  double _highestMoneyPerSecond = 0;
  double get highestMoneyPerSecond => _highestMoneyPerSecond;

  double _totalMoneySpent = 0;
  double get totalMoneySpent => _totalMoneySpent;

  bool _useScientificNotation = false;
  bool get useScientificNotation => _useScientificNotation;

  void toggleNumberFormat() {
    _useScientificNotation = !_useScientificNotation;
    notifyListeners();
  }

  int _buyMultiplier = 1;
  int get buyMultiplier => _buyMultiplier;

  void toggleBuyMultiplier() {
    if (_buyMultiplier == 1) {
      _buyMultiplier = 10;
    } else if (_buyMultiplier == 10) {
      _buyMultiplier = 100;
    } else if (_buyMultiplier == 100) {
      _buyMultiplier = 1000;
    } else if (_buyMultiplier == 1000) {
      _buyMultiplier = -1; // MAX
    } else {
      _buyMultiplier = 1;
    }
    notifyListeners();
  }

  double _clickMultiplier = 1.0;

  Timer? _timer;

  List<DeliveryUnit> units = getDefaultUnits();

  List<Upgrade> upgrades = getDefaultUpgrades();

  List<Achievement> achievements = getDefaultAchievements();

  // Queue for showing achievement notifications
  List<Achievement> unlockedQueue = [];

  // Queue for showing evolution notifications
  List<String> evolutionNotifications = [];

  GameState() {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  double get moneyPerSecond {
    double income = 0;
    for (var unit in units) {
      income += unit.totalIncome;
    }
    return income;
  }

  int get totalUnitsPurchased {
    int count = 0;
    for (var unit in units) {
      count += unit.count;
    }
    return count;
  }

  int get totalUpgradesPurchased {
    return upgrades.where((u) => u.isPurchased).length;
  }

  int get unlockedAchievementsCount {
    return achievements.where((a) => a.isUnlocked).length;
  }

  double get clickValue => 1.0 * _clickMultiplier;

  void _tick() {
    double income = moneyPerSecond;
    if (income > _highestMoneyPerSecond) {
      _highestMoneyPerSecond = income;
    }
    _money += income;
    _totalMoneyEarned += income;

    // Assume each unit delivers 1 order per second
    int orders = 0;
    for (var unit in units) {
      orders += unit.count;
    }
    _totalOrders += orders;

    _secondsPlayed++;
    _checkAchievements();
    notifyListeners();
  }

  void click() {
    double clickValue = 1; // Base click value
    _money += clickValue;
    _totalMoneyEarned += clickValue;
    _totalClicks++;
    _totalOrders++;
    _checkAchievements();
    notifyListeners();
  }

  ({double cost, int amount}) getBuyInfo(DeliveryUnit unit) {
    int amountToBuy = 0;
    double totalCost = 0;

    if (_buyMultiplier == -1) {
      double tempCost = 0;
      int tempCount = 0;
      double currentUnitCost = unit.baseCost * (1 + 0.15 * unit.count);

      while (_money >= tempCost + currentUnitCost) {
        tempCost += currentUnitCost;
        tempCount++;
        currentUnitCost = unit.baseCost * (1 + 0.15 * (unit.count + tempCount));

        if (tempCount >= 10000) break;
      }

      amountToBuy = tempCount;
      totalCost = tempCost;
    } else {
      amountToBuy = _buyMultiplier;
      double tempCost = 0;
      for (int i = 0; i < amountToBuy; i++) {
        tempCost += unit.baseCost * (1 + 0.15 * (unit.count + i));
      }
      totalCost = tempCost;
    }

    return (cost: totalCost, amount: amountToBuy);
  }

  void buyUnit(DeliveryUnit unit) {
    final buyInfo = getBuyInfo(unit);
    final amountToBuy = buyInfo.amount;
    final totalCost = buyInfo.cost;

    if (amountToBuy > 0 && _money >= totalCost) {
      _money -= totalCost;
      _totalMoneySpent += totalCost;

      int oldCount = unit.count;
      unit.count += amountToBuy;
      int newCount = unit.count;

      // Check for evolution
      if (oldCount < 100 && newCount >= 100) {
        evolutionNotifications.add("${unit.evolvedName} Unlocked!");
        _totalEvolutions++;
      }
      if (oldCount < 250 && newCount >= 250) {
        evolutionNotifications.add("${unit.evolvedName} Unlocked!");
        _totalEvolutions++;
      }
      if (oldCount < 500 && newCount >= 500) {
        evolutionNotifications.add("${unit.evolvedName} Unlocked!");
        _totalEvolutions++;
      }
      if (oldCount < 1000 && newCount >= 1000) {
        evolutionNotifications.add("${unit.evolvedName} Unlocked!");
        _totalEvolutions++;
      }

      _checkAchievements();
      notifyListeners();
    }
  }

  void buyUpgrade(Upgrade upgrade) {
    if (_money >= upgrade.cost && !upgrade.isPurchased) {
      _money -= upgrade.cost;
      _totalMoneySpent += upgrade.cost;
      upgrade.isPurchased = true;

      if (upgrade.type == UpgradeType.unitMultiplier &&
          upgrade.targetUnitId != null) {
        final unit = units.firstWhere((u) => u.id == upgrade.targetUnitId);
        unit.multiplier *= upgrade.multiplierValue;
      } else if (upgrade.type == UpgradeType.globalMultiplier) {
        for (var unit in units) {
          unit.multiplier *= upgrade.multiplierValue;
        }
      } else if (upgrade.type == UpgradeType.clickMultiplier) {
        _clickMultiplier *= upgrade.multiplierValue;
      }

      notifyListeners();
    }
  }

  void _checkAchievements() {
    for (var achievement in achievements) {
      if (achievement.isUnlocked) continue;

      bool unlocked = false;
      switch (achievement.type) {
        case AchievementType.money:
          if (_totalMoneyEarned >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.clicks:
          if (_totalClicks >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.orders:
          if (_totalOrders >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.playTime:
          if (_secondsPlayed >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.unitCount:
          if (achievement.targetUnitId != null) {
            final unit = units.firstWhere(
              (u) => u.id == achievement.targetUnitId,
              orElse: () => units.first,
            );
            if (unit.count >= achievement.threshold) unlocked = true;
          }
          break;
        case AchievementType.evolutions:
          if (_totalEvolutions >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.moneyPerSecond:
          if (moneyPerSecond >= achievement.threshold) unlocked = true;
          break;
        case AchievementType.upgrades:
          if (totalUpgradesPurchased >= achievement.threshold) unlocked = true;
          break;
      }

      if (unlocked) {
        achievement.isUnlocked = true;
        unlockedQueue.add(achievement);
      }
    }
  }

  void clearUnlockedQueue() {
    unlockedQueue.clear();
  }

  void clearEvolutionNotifications() {
    evolutionNotifications.clear();
  }

  String formatNumber(double value) {
    if (_useScientificNotation) {
      return value.toStringAsExponential(2);
    }

    if (value < 1000) return value.toStringAsFixed(0);

    const suffixes = [
      "",
      "K",
      "M",
      "B",
      "T",
      "Qa",
      "Qi",
      "Sx",
      "Sp",
      "Oc",
      "No",
      "Dc",
    ];
    int suffixIndex = 0;
    double v = value;

    while (v >= 1000 && suffixIndex < suffixes.length - 1) {
      v /= 1000;
      suffixIndex++;
    }

    return "${v.toStringAsFixed(2)}${suffixes[suffixIndex]}";
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
