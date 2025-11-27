import 'package:flutter_test/flutter_test.dart';
import 'package:supercrazydeliveryinc/models/game_state.dart';

void main() {
  group('GameState Tests', () {
    test('Initial state is correct', () {
      final gameState = GameState();
      expect(gameState.money, 0);
      expect(gameState.units.length, 3);
    });

    test('Click adds money', () {
      final gameState = GameState();
      gameState.click();
      expect(gameState.money, 1);
    });

    test('Buying unit deducts money and increases count', () {
      final gameState = GameState();
      // Give enough money to buy the first unit (cost 10)
      for (int i = 0; i < 10; i++) {
        gameState.click();
      }

      final unit = gameState.units[0];
      gameState.buyUnit(unit);

      expect(gameState.money, 0);
      expect(unit.count, 1);
    });
  });
}
