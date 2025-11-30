import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'delivery_unit.dart';
import 'upgrade.dart';
import 'achievement.dart';
import 'manager.dart';

import '../data/default_units.dart';
import '../data/default_upgrades.dart';
import '../data/default_achievements.dart';
import '../data/default_managers.dart';
import '../data/golden_stories.dart';
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

  int _totalGoldenPackagesClicked = 0;
  int get totalGoldenPackagesClicked => _totalGoldenPackagesClicked;

  int _totalBoostsActivated = 0;
  int get totalBoostsActivated => _totalBoostsActivated;

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

    _totalBoostsActivated++;
    _checkAchievements();
    notifyListeners();
  }

  Timer? _timer;

  // Initialize Units first
  List<DeliveryUnit> units = getDefaultUnits();

  // Initialize Managers and Upgrades dependent on Units
  late List<Manager> managers = getDefaultManagers(units);
  late List<Upgrade> upgrades = getDefaultUpgrades(units);

  List<Achievement> achievements = getDefaultAchievements();

  // Queue for showing achievement notifications
  List<Achievement> unlockedQueue = [];

  // Queue for showing evolution notifications
  List<String> evolutionNotifications = [];

  // Toast Notification Stream
  final _toastController = StreamController<String>.broadcast();
  Stream<String> get toastStream => _toastController.stream;

  // Golden Package
  bool _goldenPackageActive = false;
  bool get goldenPackageActive => _goldenPackageActive;

  // Position (x, y) as percentage of screen (0.0 to 1.0)
  // We use a simple map or object to store this if we want to keep GameState pure dart
  // But Offset is UI specific (dart:ui). Let's use simple doubles.
  double _goldenPackageX = 0.5;
  double _goldenPackageY = 0.5;
  double get goldenPackageX => _goldenPackageX;
  double get goldenPackageY => _goldenPackageY;

  Timer? _goldenPackageTimer;

  // Prestige
  int _prestigeTokens = 0;
  int get prestigeTokens => _prestigeTokens;

  double get prestigeMultiplier => 1.0 + (_prestigeTokens * 0.10);

  int calculatePotentialTokens() {
    if (_totalMoneyEarned < 1000000) return 0;
    // Formula: sqrt(totalMoney / 1M) - currentTokens
    int potential = (math.sqrt(_totalMoneyEarned / 1000000)).floor();
    return potential - _prestigeTokens > 0 ? potential - _prestigeTokens : 0;
  }

  void prestige() {
    int tokensToGain = calculatePotentialTokens();
    if (tokensToGain <= 0) return;

    _prestigeTokens += tokensToGain;

    // Reset Progress
    _money = 0;
    _totalMoneyEarned =
        0; // Optional: Keep lifetime stats separate? Plan said reset.
    // Actually, usually lifetime stats are kept for achievements.
    // But for the formula to work (incremental), we might need to keep it
    // OR change the formula to be based on "Current Run Money".
    // Let's stick to the plan: Reset money, units, upgrades.
    // But if we reset totalMoneyEarned, the formula sqrt(0) will be 0.
    // So the formula MUST be based on LIFETIME earnings or we reset it and the formula is based on THIS RUN.
    // Standard idle: Formula based on Lifetime Earnings.
    // So we should NOT reset _totalMoneyEarned if we want the formula to be cumulative.
    // OR if the formula is "tokens based on money THIS run", then we reset.
    // Let's assume "Money This Run" for simplicity of the "reset" concept.
    // So:
    _money = 0;
    // _totalMoneyEarned = 0; // Let's NOT reset this, so achievements stick?
    // Wait, if I don't reset totalMoneyEarned, the formula `sqrt(total)` will always yield the SAME tokens unless I subtract `_prestigeTokens`.
    // Yes, the formula `potential - _prestigeTokens` handles the cumulative nature.
    // So `_totalMoneyEarned` should probably NOT be reset if it tracks "Lifetime".
    // However, usually "Money" is reset. "Total Money Earned" is usually lifetime.
    // Let's reset `_money` but KEEP `_totalMoneyEarned` for achievements/stats,
    // BUT we need a `_moneyEarnedThisRun` for the prestige formula if we want it to be run-based.
    // The plan said: "Reset _money, units, upgrades."
    // It didn't explicitly say reset `_totalMoneyEarned`.
    // Let's keep `_totalMoneyEarned` for achievements.

    // Reset Units
    for (var unit in units) {
      unit.count = 0;
      unit.multiplier = 1.0;
    }

    // Reset Upgrades
    for (var upgrade in upgrades) {
      upgrade.isPurchased = false;
    }

    // Reset Managers
    for (var manager in managers) {
      manager.isHired = false;
    }

    // Reset Multipliers
    _clickMultiplier = 1.0;
    _highestMoneyPerSecond = 0; // Reset for this run

    // Save immediately
    _saveGame();
    notifyListeners();
  }

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
      _totalMoneyEarned = (data['totalMoneyEarned'] ?? 0).toDouble();
      _totalOrders = data['totalOrders'] ?? 0;
      _secondsPlayed = data['secondsPlayed'] ?? 0;
      _totalEvolutions = data['totalEvolutions'] ?? 0;
      _highestMoneyPerSecond = (data['highestMoneyPerSecond'] ?? 0).toDouble();
      _totalMoneySpent = (data['totalMoneySpent'] ?? 0).toDouble();
      _totalGoldenPackagesClicked = data['totalGoldenPackagesClicked'] ?? 0;
      _totalBoostsActivated = data['totalBoostsActivated'] ?? 0;
      _buyMultiplier = data['buyMultiplier'] ?? 1;
      _useScientificNotation = data['useScientificNotation'] ?? false;
      _clickMultiplier = data['clickMultiplier'] ?? 1.0;
      _isPremium = data['isPremium'] ?? false;
      _prestigeTokens = data['prestigeTokens'] ?? 0;

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

      // Load Managers
      if (data['managers'] != null) {
        final List<dynamic> managersData = data['managers'];
        for (var managerData in managersData) {
          final manager = managers.firstWhere(
            (m) => m.id == managerData['id'],
            orElse: () => managers.first,
          );
          manager.isHired = managerData['isHired'] ?? false;
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
      'totalGoldenPackagesClicked': _totalGoldenPackagesClicked,
      'totalBoostsActivated': _totalBoostsActivated,
      'buyMultiplier': _buyMultiplier,
      'useScientificNotation': _useScientificNotation,
      'clickMultiplier': _clickMultiplier,
      'isPremium': _isPremium,
      'prestigeTokens': _prestigeTokens,
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
      'managers': managers
          .map((m) => {'id': m.id, 'isHired': m.isHired})
          .toList(),
      'achievements': achievements
          .map((a) => {'id': a.id, 'isUnlocked': a.isUnlocked})
          .toList(),
    };
    await _persistenceService.saveGame(data);
    _toastController.add("Game Saved!");
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
    income *= prestigeMultiplier;
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
    value *= prestigeMultiplier;
    return value;
  }

  double get globalMultiplier {
    double multiplier = 1.0;
    if (isBoostActive) {
      multiplier *= 2;
    }
    if (isPremium) {
      multiplier *= 2;
    }
    multiplier *= prestigeMultiplier;
    return multiplier;
  }

  void _tick() {
    double income = moneyPerSecond;
    if (income > _highestMoneyPerSecond) {
      _highestMoneyPerSecond = income;
    }
    _money += income;
    _totalMoneyEarned += income;

    // Auto-Clicks from Managers
    double autoClicks = 0;
    for (var manager in managers) {
      if (manager.isHired && manager.type == ManagerType.autoClick) {
        autoClicks += manager.value;
      }
    }
    if (autoClicks > 0) {
      // We treat auto-clicks as "clicks" for stats? Maybe separate?
      // Let's just add the money for now.
      // 1 click = clickValue.
      double autoClickMoney = autoClicks * clickValue;
      _money += autoClickMoney;
      _totalMoneyEarned += autoClickMoney;
      // _totalClicks += autoClicks.toInt(); // Optional: Count as real clicks? Usually no.
    }

    // Golden Package Spawn Logic
    if (!_goldenPackageActive) {
      // 1% chance per second (approx every 100s)
      // Let's make it a bit more frequent for testing/fun: 2%
      if (math.Random().nextDouble() < 0.02) {
        _spawnGoldenPackage();
      }
    }

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
    double clickValue = this.clickValue;
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

    // Apply Manager Discounts
    double discount = 0;
    for (var manager in managers) {
      if (manager.isHired && manager.type == ManagerType.discount) {
        discount += manager.value;
      }
    }
    totalCost *= (1 - discount);

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

  void hireManager(Manager manager) {
    if (_money >= manager.cost && !manager.isHired) {
      _money -= manager.cost;
      _totalMoneySpent += manager.cost;
      manager.isHired = true;

      if (manager.type == ManagerType.unitBoost &&
          manager.targetUnitId != null) {
        final unit = units.firstWhere(
          (u) => u.id == manager.targetUnitId,
          orElse: () => units.first, // Fallback to avoid crash
        );
        // Only apply if we actually found the target unit (or if fallback is acceptable logic,
        // but here we just want to avoid the crash. Ideally we check if ID matches).
        if (unit.id == manager.targetUnitId) {
          unit.multiplier *= manager.value;
        }
      }
      // Auto-clicks and Discounts are handled dynamically in _tick and getBuyInfo

      notifyListeners();
    }
  }

  void _spawnGoldenPackage() {
    _goldenPackageActive = true;
    // Random position (padding 10% from edges)
    _goldenPackageX = 0.1 + math.Random().nextDouble() * 0.8;
    _goldenPackageY =
        0.2 + math.Random().nextDouble() * 0.6; // Avoid top/bottom bars

    notifyListeners();

    // Disappear after 10 seconds
    _goldenPackageTimer?.cancel();
    _goldenPackageTimer = Timer(const Duration(seconds: 10), () {
      if (_goldenPackageActive) {
        _goldenPackageActive = false;
        notifyListeners();
      }
    });
  }

  ({String message, String story}) clickGoldenPackage() {
    if (!_goldenPackageActive) return (message: "", story: "");

    _goldenPackageActive = false;
    _goldenPackageTimer?.cancel();
    notifyListeners();

    // Pick a random story
    final story = goldenStories[math.Random().nextInt(goldenStories.length)];

    // Determine Reward
    // 50% Money, 50% Boost
    if (math.Random().nextBool()) {
      // Money Reward: 5 minutes of current production
      double reward = moneyPerSecond * 300;
      // Minimum reward if production is low
      if (reward < 1000) reward = 1000 * prestigeMultiplier;

      _money += reward;
      _totalMoneyEarned += reward;
      _totalGoldenPackagesClicked++;
      _checkAchievements();
      notifyListeners();
      return (
        message: "Golden Package!\n+\$${formatNumber(reward)}",
        story: story,
      );
    } else {
      // Boost Reward: x5 for 30 seconds
      // We need a way to stack boosts or handle this.
      // Current boost is x2 for 4h.
      // Let's make this a "Super Boost" or just extend/add to current boost?
      // Simpler: Just give money for now, or implement a separate "Golden Boost".
      // Let's do a "Golden Frenzy": x5 for 30s.
      // For simplicity in this iteration, let's just give a HUGE chunk of money or a "Time Warp" (instant 1 hour).

      // Let's do Time Warp (1 Hour)
      double reward = moneyPerSecond * 3600;
      if (reward < 5000) reward = 5000 * prestigeMultiplier;

      _money += reward;
      _totalMoneyEarned += reward;
      _totalGoldenPackagesClicked++;
      _checkAchievements();
      notifyListeners();
      return (
        message: "Time Warp!\n+\$${formatNumber(reward)} (1 Hour)",
        story: story,
      );
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
        // case AchievementType.orders: // Deprecated
        //   if (_totalOrders >= achievement.threshold) unlocked = true;
        //   break;
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
        case AchievementType.goldenPackages:
          if (_totalGoldenPackagesClicked >= achievement.threshold) {
            unlocked = true;
          }
          break;
        case AchievementType.boosts:
          if (_totalBoostsActivated >= achievement.threshold) {
            unlocked = true;
          }
          break;
        case AchievementType.managersHired:
          if (managers.where((m) => m.isHired).length >=
              achievement.threshold) {
            unlocked = true;
          }
          break;
        case AchievementType.allUnitsUnlocked:
          if (units.every((u) => u.count > 0)) {
            unlocked = true;
          }
          break;
        case AchievementType.allManagersHired:
          if (managers.every((m) => m.isHired)) {
            unlocked = true;
          }
          break;
        case AchievementType.allUpgradesPurchased:
          if (upgrades.every((u) => u.isPurchased)) {
            unlocked = true;
          }
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

    if (value < 1000) {
      return value.toStringAsFixed(0);
    }

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
