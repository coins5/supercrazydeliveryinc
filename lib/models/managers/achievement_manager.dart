import 'package:flutter/foundation.dart';
import 'package:supercrazydeliveryinc/data/default_achievements.dart'
    as DefaultAchievements;
import '../achievement.dart';

class AchievementManager extends ChangeNotifier {
  List<Achievement> _achievements = [];
  final List<Achievement> _unlockedQueue = [];

  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedQueue => _unlockedQueue;

  AchievementManager() {
    _achievements = DefaultAchievements.getDefaultAchievements();
  }

  void setAchievements(List<Achievement> achievements) {
    _achievements = achievements;
    notifyListeners();
  }

  void unlockAchievement(String achievementId) {
    final index = _achievements.indexWhere((a) => a.id == achievementId);
    if (index != -1 && !_achievements[index].isUnlocked) {
      _achievements[index] = _achievements[index].copyWith(isUnlocked: true);
      _unlockedQueue.add(_achievements[index]);
      notifyListeners();
    }
  }

  void clearUnlockedQueue() {
    _unlockedQueue.clear();
    // No need to notify listeners here usually, as this is consumed by UI
  }

  void resetAchievements() {
    // Achievements usually persist across prestige, but maybe not hard reset.
    // For now, assuming they persist.
  }
}
