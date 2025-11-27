import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/unit_card.dart';
import '../widgets/upgrade_card.dart';
import 'statistics_screen.dart';
import 'achievements_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Super Crazy Delivery Inc'),
          backgroundColor: Colors.amber,
          actions: [
            IconButton(
              icon: const Icon(Icons.emoji_events),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AchievementsScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StatisticsScreen(),
                  ),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Units'),
              Tab(text: 'Upgrades'),
            ],
          ),
        ),
        body: Consumer<GameState>(
          builder: (context, gameState, child) {
            // Check for unlocked achievements and show snackbar
            if (gameState.unlockedQueue.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                for (var achievement in gameState.unlockedQueue) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.emoji_events, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Achievement Unlocked!',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(achievement.name),
                              ],
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Colors.green[800],
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
                gameState.clearUnlockedQueue();
              });
            }

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
                        '\$${gameState.formatNumber(gameState.money)}',
                        style: Theme.of(context).textTheme.displayMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                      ),
                      Text(
                        '+ \$${gameState.formatNumber(gameState.moneyPerSecond)} / sec',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
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
                            formatNumber: gameState.formatNumber,
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
                            formatNumber: gameState.formatNumber,
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
