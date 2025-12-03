import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../upgrade_card.dart';

class UpgradeListView extends StatelessWidget {
  const UpgradeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        final visibleUpgrades = gameState.upgrades.where((upgrade) {
          return gameState.money >= upgrade.cost && !upgrade.isPurchased;
        }).toList();

        if (visibleUpgrades.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Deliver more packages to unlock upgrades!',
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

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: gameState.buyAllUpgrades,
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text("BUY ALL UPGRADES"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: visibleUpgrades.length,
                itemBuilder: (context, index) {
                  final upgrade = visibleUpgrades[index];
                  return UpgradeCard(
                    upgrade: upgrade,
                    canAfford:
                        gameState.money >=
                        upgrade.getCost(gameState.isHardMode),
                    onBuy: () => gameState.buyUpgrade(upgrade),
                    formatNumber: gameState.formatNumber,
                    isHardMode: gameState.isHardMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
