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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: Consumer<GameState>(
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
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
                // Dashboard
                Material(
                  elevation: 8,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepPurple, Colors.indigo],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: InkWell(
                      onTap: gameState.click,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'CURRENT BALANCE',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${gameState.formatNumber(gameState.money)}',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.flash_on,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+ \$${gameState.formatNumber(gameState.moneyPerSecond)} / sec',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.touch_app,
                                        color: Colors.cyanAccent,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '+ \$${gameState.formatNumber(gameState.clickValue)} / click',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '(Tap anywhere to earn!)',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Control Panel
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildControlButton(
                          context: context,
                          onPressed:
                              (gameState.isBoostActive &&
                                  gameState.boostRemainingTime.inMinutes >=
                                      (23 * 60 + 30))
                              ? null
                              : gameState.activateBoost,
                          isActive: gameState.isBoostActive,
                          activeColor: Colors.green,
                          inactiveColor: Colors.redAccent,
                          label: gameState.isBoostActive
                              ? "BOOST ACTIVE"
                              : "BOOST x2",
                          subLabel: gameState.isBoostActive
                              ? (gameState.boostRemainingTime.inMinutes >=
                                        (23 * 60 + 30)
                                    ? "MAX (24h)"
                                    : gameState.boostRemainingTime
                                          .toString()
                                          .split('.')
                                          .first)
                              : "4h",
                          icon: Icons.rocket_launch,
                        ),
                        const SizedBox(width: 8),
                        _buildControlButton(
                          context: context,
                          onPressed: gameState.isPremium
                              ? null
                              : gameState.activatePremium,
                          isActive: gameState.isPremium,
                          activeColor: Colors.amber,
                          inactiveColor: Colors.amber,
                          label: "PREMIUM",
                          subLabel: gameState.isPremium ? "ACTIVE" : "x2 PERM",
                          icon: Icons.star,
                        ),
                        const SizedBox(width: 8),
                        _buildControlButton(
                          context: context,
                          onPressed: gameState.toggleBuyMultiplier,
                          isActive: true, // Always active
                          activeColor: Colors.blue,
                          inactiveColor: Colors.blue,
                          label:
                              "BUY x${gameState.buyMultiplier == -1 ? 'MAX' : gameState.buyMultiplier}",
                          subLabel: "MULTIPLIER",
                          icon: Icons.shopping_cart,
                        ),
                      ],
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: _selectedIndex == 0
                      ? (visibleUnits.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
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
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
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
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_outline,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
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
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(bottom: 80),
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

  Widget _buildControlButton({
    required BuildContext context,
    required VoidCallback? onPressed,
    required bool isActive,
    required Color activeColor,
    required Color inactiveColor,
    required String label,
    required String subLabel,
    required IconData icon,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : inactiveColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        elevation: isActive ? 4 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: isActive
              ? BorderSide(color: Colors.white.withOpacity(0.5), width: 2)
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}
