import 'package:flutter/foundation.dart';

class CurrencyManager extends ChangeNotifier {
  double _money = 0;
  double _gems = 0;
  double _prestigeTokens = 0;

  double get money => _money;
  double get gems => _gems;
  double get prestigeTokens => _prestigeTokens;

  void addMoney(double amount) {
    _money += amount;
    notifyListeners();
  }

  bool trySpendMoney(double amount) {
    if (_money >= amount) {
      _money -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void addGems(double amount) {
    _gems += amount;
    notifyListeners();
  }

  bool trySpendGems(double amount) {
    if (_gems >= amount) {
      _gems -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }

  void addPrestigeTokens(double amount) {
    _prestigeTokens += amount;
    notifyListeners();
  }

  void setMoney(double amount) {
    _money = amount;
    notifyListeners();
  }

  void setGems(double amount) {
    _gems = amount;
    notifyListeners();
  }

  void setPrestigeTokens(double amount) {
    _prestigeTokens = amount;
    notifyListeners();
  }

  void resetMoney() {
    _money = 0;
    notifyListeners();
  }
}
