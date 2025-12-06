import 'package:flutter_test/flutter_test.dart';
import 'package:supercrazydeliveryinc/models/achievement.dart';
import 'package:supercrazydeliveryinc/models/game_state.dart';
import 'package:supercrazydeliveryinc/services/purchase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPurchaseService extends PurchaseService {
  MockPurchaseService({
    required super.onPremiumStatusChanged,
    required super.onError,
  });

  @override
  Future<void> initialize() async {
    // Mock initialization: do nothing
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Achievement unitCount respects targetUnitId', () {
    // Inject MockPurchaseService
    final gameState = GameState(
      purchaseServiceBuilder:
          ({required onPremiumStatusChanged, required onError}) {
            return MockPurchaseService(
              onPremiumStatusChanged: onPremiumStatusChanged,
              onError: onError,
            );
          },
    );

    // Setup achievements
    final grandmaAchievement = Achievement(
      id: 'own_grandma',
      name: 'Lord of Grandmas',
      description: 'Own 1 Grandma',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'grandma',
    );

    final paperBoyAchievement = Achievement(
      id: 'own_paper_boy',
      name: 'Lord of Paper Boys',
      description: 'Own 1 Paper Boy',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'paper_boy',
    );

    // Inject custom achievements for testing
    gameState.achievementManager.setAchievements([
      grandmaAchievement,
      paperBoyAchievement,
    ]);

    // Find units
    final grandma = gameState.units.firstWhere((u) => u.id == 'grandma');
    final paperBoy = gameState.units.firstWhere((u) => u.id == 'paper_boy');

    // Verify units are found
    expect(grandma, isNotNull);
    expect(paperBoy, isNotNull);

    // Give money to buy units
    gameState.currencyManager.setMoney(1e100); // Infinite money

    // Buy Grandma
    gameState.buyUnit(grandma);

    // Verify Grandma achievement unlocked
    expect(
      gameState.achievements
          .firstWhere((a) => a.id == 'own_grandma')
          .isUnlocked,
      true,
      reason: "Grandma achievement should be unlocked",
    );

    // Verify Paper Boy achievement LOCKED (The bug fix)
    expect(
      gameState.achievements
          .firstWhere((a) => a.id == 'own_paper_boy')
          .isUnlocked,
      false,
      reason: "Paper Boy achievement should be LOCKED",
    );

    // Buy Paper Boy
    gameState.buyUnit(paperBoy);

    // Verify Paper Boy achievement unlocked
    expect(
      gameState.achievements
          .firstWhere((a) => a.id == 'own_paper_boy')
          .isUnlocked,
      true,
      reason: "Paper Boy achievement should be unlocked now",
    );
  });
}
