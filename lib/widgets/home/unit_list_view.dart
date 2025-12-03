import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../unit_card.dart';

class UnitListView extends StatelessWidget {
  const UnitListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final visibleUnits = gameState.units.where((unit) {
          return gameState.money >= unit.getCost(gameState.isHardMode) ||
              unit.count > 0;
        }).toList();

        if (visibleUnits.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Deliver more packages to unlock units!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: visibleUnits.length,
          itemBuilder: (context, index) {
            final unit = visibleUnits[index];
            final buyInfo = gameState.getBuyInfo(unit);
            return UnitCard(
              unit: unit,
              canAfford: gameState.money >= buyInfo.cost && buyInfo.amount > 0,
              buyCost: buyInfo.cost,
              buyAmount: buyInfo.amount,
              onBuy: () => gameState.buyUnit(unit),
              formatNumber: gameState.formatNumber,
              globalMultiplier: gameState.globalMultiplier,
              gameState: gameState,
            );
          },
        );
      },
    );
  }
}
