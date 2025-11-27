import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/unit_card.dart';
import '../widgets/upgrade_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Super Crazy Delivery Inc'),
          backgroundColor: Colors.amber,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Units'),
              Tab(text: 'Upgrades'),
            ],
          ),
        ),
        body: Consumer<GameState>(
          builder: (context, gameState, child) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  color: Colors.amber.shade100,
                  child: Column(
                    children: [
                      Text(
                        'CASH',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        '\$${gameState.money.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: gameState.click,
                        icon: const Icon(Icons.local_shipping, size: 32),
                        label: const Text('DELIVER NOW!'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Units Tab
                      ListView.builder(
                        itemCount: gameState.units.length,
                        itemBuilder: (context, index) {
                          final unit = gameState.units[index];
                          return UnitCard(
                            unit: unit,
                            canAfford: gameState.money >= unit.currentCost,
                            onBuy: () => gameState.buyUnit(unit),
                          );
                        },
                      ),
                      // Upgrades Tab
                      ListView.builder(
                        itemCount: gameState.upgrades.length,
                        itemBuilder: (context, index) {
                          final upgrade = gameState.upgrades[index];
                          return UpgradeCard(
                            upgrade: upgrade,
                            canAfford: gameState.money >= upgrade.cost,
                            onBuy: () => gameState.buyUpgrade(upgrade),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
