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
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

          // Check for evolution notifications
          if (gameState.evolutionNotifications.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              for (var notification in gameState.evolutionNotifications) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.auto_awesome, color: Colors.purple),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notification,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.purple[800],
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              gameState.clearEvolutionNotifications();
            });
          }

          // Filter visible units and upgrades
          final visibleUnits = gameState.units.where((unit) {
            return gameState.money >= unit.currentCost || unit.count > 0;
          }).toList();

          final visibleUpgrades = gameState.upgrades.where((upgrade) {
            return gameState.money >= upgrade.cost && !upgrade.isPurchased;
          }).toList();

          return Column(
            children: [
              Material(
                color: Colors.amber.shade100,
                child: InkWell(
                  onTap: gameState.click,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    width: double.infinity,
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
                        Text(
                          '+ \$${gameState.formatNumber(gameState.clickValue)} / click',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '(Tap here to earn!)',
                          style: TextStyle(
                            color: Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        onPressed:
                            (gameState.isBoostActive &&
                                gameState.boostRemainingTime.inMinutes >=
                                    (23 * 60 + 30))
                            ? null
                            : gameState.activateBoost,
                        style: TextButton.styleFrom(
                          backgroundColor: gameState.isBoostActive
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gameState.isBoostActive
                                  ? "BOOST ACTIVE"
                                  : "BOOST x2",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            if (gameState.isBoostActive)
                              Text(
                                gameState.boostRemainingTime.inMinutes >=
                                        (23 * 60 + 30)
                                    ? "MAX (24h)"
                                    : gameState.boostRemainingTime
                                          .toString()
                                          .split('.')
                                          .first,
                                style: const TextStyle(fontSize: 10),
                              )
                            else
                              const Text("4h", style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        onPressed: gameState.isPremium
                            ? null
                            : gameState.activatePremium,
                        style: TextButton.styleFrom(
                          backgroundColor: gameState.isPremium
                              ? Colors.amber.withValues(alpha: 0.5)
                              : Colors.amber,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              gameState.isPremium ? "PREMIUM" : "PREMIUM",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              gameState.isPremium ? "ACTIVE" : "x2 PERM",
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextButton(
                        onPressed: gameState.toggleBuyMultiplier,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          "x${gameState.buyMultiplier == -1 ? 'MAX' : gameState.buyMultiplier}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _selectedIndex == 0
                    ? (visibleUnits.isEmpty
                          ? const Center(
                              child: Text(
                                'Deliver more packages to unlock units!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: visibleUnits.length,
                              itemBuilder: (context, index) {
                                final unit = visibleUnits[index];
                                final buyInfo = gameState.getBuyInfo(unit);
                                return UnitCard(
                                  unit: unit,
                                  canAfford:
                                      gameState.money >= buyInfo.cost &&
                                      buyInfo.amount > 0,
                                  buyCost: buyInfo.cost,
                                  buyAmount: buyInfo.amount,
                                  onBuy: () => gameState.buyUnit(unit),
                                  formatNumber: gameState.formatNumber,
                                );
                              },
                            ))
                    : (visibleUpgrades.isEmpty
                          ? const Center(
                              child: Text(
                                'Deliver more packages to unlock upgrades!',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: visibleUpgrades.length,
                              itemBuilder: (context, index) {
                                final upgrade = visibleUpgrades[index];
                                return UpgradeCard(
                                  upgrade: upgrade,
                                  canAfford: gameState.money >= upgrade.cost,
                                  onBuy: () => gameState.buyUpgrade(upgrade),
                                  formatNumber: gameState.formatNumber,
                                );
                              },
                            )),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Units',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.upgrade), label: 'Upgrades'),
        ],
      ),
    );
  }
}
