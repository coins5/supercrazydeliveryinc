import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class PrestigeManager extends ChangeNotifier {
  int calculatePotentialTokens(double money) {
    if (money < 1000000) return 0;
    // Formula: 150 * sqrt(money / 1,000,000)
    return (150 * math.sqrt(money / 1000000)).floor();
  }
}
