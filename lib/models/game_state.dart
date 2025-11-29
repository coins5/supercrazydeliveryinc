import 'dart:async';
import 'package:flutter/foundation.dart';
import 'delivery_unit.dart';
import 'upgrade.dart';
import 'achievement.dart';

import '../data/default_units.dart';
import '../data/default_upgrades.dart';
import '../data/default_achievements.dart';
import '../services/persistence_service.dart';

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
  String get playTime => formatDuration(_secondsPlayed);

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

  // Premium
  bool _isPremium = false;
  bool get isPremium => _isPremium;

  void activatePremium() {
    _isPremium = true;
    notifyListeners();
  }

  // Boost
  DateTime? _boostEndTime;
  bool get isBoostActive =>
      _boostEndTime != null && _boostEndTime!.isAfter(DateTime.now());
  Duration get boostRemainingTime =>
      isBoostActive ? _boostEndTime!.difference(DateTime.now()) : Duration.zero;

  void activateBoost() {
    final now = DateTime.now();
    if (_boostEndTime == null || _boostEndTime!.isBefore(now)) {
      _boostEndTime = now.add(const Duration(hours: 4));
    } else {
      _boostEndTime = _boostEndTime!.add(const Duration(hours: 4));
    }

    // Cap at 24 hours from now
    final maxEndTime = now.add(const Duration(hours: 24));
    if (_boostEndTime!.isAfter(maxEndTime)) {
      _boostEndTime = maxEndTime;
    }

    notifyListeners();
  }

  Timer? _timer;

  List<DeliveryUnit> units = getDefaultUnits();

  List<Upgrade> upgrades = getDefaultUpgrades();

  List<Achievement> achievements = getDefaultAchievements();

  // Queue for showing achievement notifications
  List<Achievement> unlockedQueue = [];

  // Queue for showing evolution notifications
  List<String> evolutionNotifications = [];

  // Offline Earnings
  double _offlineEarnings = 0;
  double get offlineEarnings => _offlineEarnings;

  int _offlineSeconds = 0;
  int get offlineSeconds => _offlineSeconds;

  bool _hasShownOfflineEarnings = false;
  bool get hasShownOfflineEarnings => _hasShownOfflineEarnings;

  void markOfflineEarningsAsShown() {
    _hasShownOfflineEarnings = true;
    notifyListeners();
  }

  void consumeOfflineEarnings() {
    _offlineEarnings = 0;
    _offlineSeconds = 0;
    notifyListeners();
  }

  final PersistenceService _persistenceService = PersistenceService();
  DateTime _lastSaveTime = DateTime.now();

  GameState() {
    _loadGame();
    _startTimer();
  }

  Future<void> _loadGame() async {
    final data = await _persistenceService.loadGame();
    if (data != null) {
      _money = data['money'] ?? 0;
      _totalClicks = data['totalClicks'] ?? 0;
      _totalMoneyEarned = data['totalMoneyEarned'] ?? 0;
      _totalOrders = data['totalOrders'] ?? 0;
      _secondsPlayed = data['secondsPlayed'] ?? 0;
      _totalEvolutions = data['totalEvolutions'] ?? 0;
      _highestMoneyPerSecond = data['highestMoneyPerSecond'] ?? 0;
      _totalMoneySpent = data['totalMoneySpent'] ?? 0;
      _useScientificNotation = data['useScientificNotation'] ?? false;
      _clickMultiplier = data['clickMultiplier'] ?? 1.0;
      _isPremium = data['isPremium'] ?? false;

      if (data['boostEndTime'] != null) {
        _boostEndTime = DateTime.tryParse(data['boostEndTime']);
      }

      // Load Units
      if (data['units'] != null) {
        final List<dynamic> unitsData = data['units'];
        for (var unitData in unitsData) {
          final unit = units.firstWhere(
            (u) => u.id == unitData['id'],
            orElse: () => units.first,
          );
          unit.count = unitData['count'] ?? 0;
          unit.multiplier = unitData['multiplier'] ?? 1.0;
        }
      }

      // Load Upgrades
      if (data['upgrades'] != null) {
        final List<dynamic> upgradesData = data['upgrades'];
        for (var upgradeData in upgradesData) {
          final upgrade = upgrades.firstWhere(
            (u) => u.id == upgradeData['id'],
            orElse: () => upgrades.first,
          );
          upgrade.isPurchased = upgradeData['isPurchased'] ?? false;
        }
      }

      // Calculate Offline Earnings
      if (data['lastSaveTime'] != null) {
        final lastSaveTime = DateTime.tryParse(data['lastSaveTime']);
        if (lastSaveTime != null) {
          final now = DateTime.now();
          final difference = now.difference(lastSaveTime);

          if (difference.inSeconds > 60) {
            // Must be away for at least 1 minute
            int totalOfflineSeconds = difference.inSeconds;

            // Cap offline time: 24h for Premium, 8h for others
            int maxOfflineSeconds = _isPremium ? 24 * 3600 : 8 * 3600;
            if (totalOfflineSeconds > maxOfflineSeconds) {
              totalOfflineSeconds = maxOfflineSeconds;
            }

            _offlineSeconds = totalOfflineSeconds;

            // Calculate potential earnings based on current rate
            // Note: This assumes constant rate, which is a simplification
            // If boost or premium are active in moneyPerSecond, we need to strip them to get base rate
            // to apply them correctly over time.
            // Actually, moneyPerSecond ALREADY includes current boost/premium status.
            // But boost might have expired WHILE offline.

            // Let's recalculate base rate (raw unit income)
            double rawIncome = 0;
            // We need to use the loaded units data
            if (data['units'] != null) {
              final List<dynamic> unitsData = data['units'];
              for (var unitData in unitsData) {
                final unit = units.firstWhere(
                  (u) => u.id == unitData['id'],
                  orElse: () => units.first,
                );
                // We already loaded counts above, so we can just sum up
                rawIncome += unit.totalIncome;
              }
            } else {
              // Fallback if units not in data (shouldn't happen if saved correctly)
              for (var unit in units) {
                rawIncome += unit.totalIncome;
              }
            }

            double earnings = 0;

            // Check Boost Status at last save
            DateTime? savedBoostEndTime;
            if (data['boostEndTime'] != null) {
              savedBoostEndTime = DateTime.tryParse(data['boostEndTime']);
            }

            // Calculate Boosted vs Normal time
            int boostedSeconds = 0;
            int normalSeconds = 0;

            if (savedBoostEndTime != null &&
                savedBoostEndTime.isAfter(lastSaveTime)) {
              // Boost was active when saved
              final boostRemainingAtSave = savedBoostEndTime
                  .difference(lastSaveTime)
                  .inSeconds;

              if (boostRemainingAtSave >= totalOfflineSeconds) {
                // Boost covered the entire offline period
                boostedSeconds = totalOfflineSeconds;
              } else {
                // Boost expired during offline period
                boostedSeconds = boostRemainingAtSave;
                normalSeconds = totalOfflineSeconds - boostedSeconds;
              }
            } else {
              // No boost active
              normalSeconds = totalOfflineSeconds;
            }

            // Apply Earnings
            // Boost gives x2
            earnings += boostedSeconds * rawIncome * 2;
            earnings += normalSeconds * rawIncome;

            // Apply Premium (x2 permanent)
            if (_isPremium) {
              earnings *= 2;
            }

            _offlineEarnings = earnings;
            _money += _offlineEarnings;
            _totalMoneyEarned += _offlineEarnings;
            _hasShownOfflineEarnings = false;
          }
        }
      }

      // Load Achievements
      if (data['achievements'] != null) {
        final List<dynamic> achievementsData = data['achievements'];
        for (var achievementData in achievementsData) {
          final achievement = achievements.firstWhere(
            (a) => a.id == achievementData['id'],
            orElse: () => achievements.first,
          );
          achievement.isUnlocked = achievementData['isUnlocked'] ?? false;
        }
      }
      notifyListeners();
    }
  }

  Future<void> _saveGame() async {
    final data = {
      'money': _money,
      'totalClicks': _totalClicks,
      'totalMoneyEarned': _totalMoneyEarned,
      'totalOrders': _totalOrders,
      'secondsPlayed': _secondsPlayed,
      'totalEvolutions': _totalEvolutions,
      'highestMoneyPerSecond': _highestMoneyPerSecond,
      'totalMoneySpent': _totalMoneySpent,
      'useScientificNotation': _useScientificNotation,
      'clickMultiplier': _clickMultiplier,
      'isPremium': _isPremium,
      'boostEndTime': _boostEndTime?.toIso8601String(),
      'lastSaveTime': DateTime.now().toIso8601String(),
      'units': units
          .map(
            (u) => {'id': u.id, 'count': u.count, 'multiplier': u.multiplier},
          )
          .toList(),
      'upgrades': upgrades
          .map((u) => {'id': u.id, 'isPurchased': u.isPurchased})
          .toList(),
      'achievements': achievements
          .map((a) => {'id': a.id, 'isUnlocked': a.isUnlocked})
          .toList(),
    };
    await _persistenceService.saveGame(data);
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
    if (isBoostActive) {
      income *= 2;
    }
    if (isPremium) {
      income *= 2;
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

  double get clickValue {
    double value = 1.0 * _clickMultiplier;
    if (isBoostActive) {
      value *= 2;
    }
    if (isPremium) {
      value *= 2;
    }
    return value;
  }

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

    // Auto-save every 30 seconds
    if (DateTime.now().difference(_lastSaveTime).inSeconds >= 30) {
      _saveGame();
      _lastSaveTime = DateTime.now();
    }

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

  String formatDuration(int seconds) {
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
