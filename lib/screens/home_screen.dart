import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/unit_card.dart';
import '../widgets/upgrade_card.dart';
import '../widgets/manager_card.dart';
import 'statistics_screen.dart';
import 'achievements_screen.dart';
import '../data/offline_messages.dart';
import 'dart:math';
import 'prestige_screen.dart';
import '../widgets/golden_package_widget.dart';
import '../widgets/crazy_dialog.dart';
import '../widgets/fire_border.dart';
import 'premium_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Listen for toast notifications (e.g., Auto-Save)
    final gameState = Provider.of<GameState>(context, listen: false);
    gameState.toastStream.listen((message) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey[800],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Crazy Delivery Inc'),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.rocket_launch),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrestigeScreen()),
              );
            },
          ),
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
          // UNCOMENT FOR DEVELOPMENT
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog(context);
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
                          Expanded(child: Text(notification)),
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

            // Check for Offline Earnings
            if (gameState.offlineEarnings > 0 &&
                !gameState.hasShownOfflineEarnings) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (!mounted) return;
                gameState.markOfflineEarningsAsShown();
                showCrazyDialog(
                  context: context,
                  barrierDismissible: false,
                  title: 'Welcome Back!',
                  themeColor: Colors.blue,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 48,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        offlineMessages[Random().nextInt(
                          offlineMessages.length,
                        )],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You were away for ${gameState.formatDuration(gameState.offlineSeconds)}',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your delivery empire earned:',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${gameState.formatNumber(gameState.offlineEarnings)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        gameState.consumeOfflineEarnings();
                        Navigator.of(context).pop();
                      },
                      child: const Text('AWESOME!'),
                    ),
                  ],
                );
              });
            }

            // Filter visible units and upgrades
            final visibleUnits = gameState.units.where((unit) {
              return gameState.money >= unit.getCost(gameState.isHardMode) ||
                  unit.count > 0;
            }).toList();

            final visibleUpgrades = gameState.upgrades.where((upgrade) {
              return gameState.money >= upgrade.cost && !upgrade.isPurchased;
            }).toList();

            return Stack(
              children: [
                Column(
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
                                    color: Colors.white.withValues(alpha: 0.7),
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
                                        color: Colors.white.withValues(
                                          alpha: .2,
                                        ),
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
                                        color: Colors.white.withValues(
                                          alpha: .2,
                                        ),
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
                                    color: Colors.white.withValues(alpha: .5),
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
                            FireBorder(
                              isActive: gameState.isPremium,
                              child: _buildControlButton(
                                context: context,
                                onPressed: gameState.isPremium
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PremiumScreen(),
                                          ),
                                        );
                                      },
                                isActive: gameState.isPremium,
                                activeColor: Colors.amber,
                                inactiveColor: Colors.amber,
                                label: "PREMIUM",
                                subLabel: gameState.isPremium
                                    ? "FOREVER"
                                    : "x2 PERM",
                                icon: Icons.star,
                                isPremium: true,
                              ),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      final buyInfo = gameState.getBuyInfo(
                                        unit,
                                      );
                                      return UnitCard(
                                        unit: unit,
                                        canAfford:
                                            gameState.money >= buyInfo.cost &&
                                            buyInfo.amount > 0,
                                        buyCost: buyInfo.cost,
                                        buyAmount: buyInfo.amount,
                                        onBuy: () => gameState.buyUnit(unit),
                                        formatNumber: gameState.formatNumber,
                                        globalMultiplier:
                                            gameState.globalMultiplier,
                                        gameState: gameState,
                                      );
                                    },
                                  ))
                          : _selectedIndex == 1
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton.icon(
                                    onPressed: gameState.hireAllManagers,
                                    icon: const Icon(Icons.people_outline),
                                    label: const Text("HIRE ALL MANAGERS"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
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
                                    itemCount: gameState.managers.length,
                                    itemBuilder: (context, index) {
                                      final manager = gameState.managers[index];
                                      return ManagerCard(
                                        manager: manager,
                                        canAfford:
                                            gameState.money >=
                                            manager.getCost(
                                              gameState.isHardMode,
                                            ),
                                        onHire: () =>
                                            gameState.hireManager(manager),
                                        formatNumber: gameState.formatNumber,
                                        isHardMode: gameState.isHardMode,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : (visibleUpgrades.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: ElevatedButton.icon(
                                          onPressed: gameState.buyAllUpgrades,
                                          icon: const Icon(
                                            Icons.shopping_cart_checkout,
                                          ),
                                          label: const Text("BUY ALL UPGRADES"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            minimumSize: const Size(
                                              double.infinity,
                                              50,
                                            ),
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.only(
                                            bottom: 80,
                                          ),
                                          itemCount: visibleUpgrades.length,
                                          itemBuilder: (context, index) {
                                            final upgrade =
                                                visibleUpgrades[index];
                                            return UpgradeCard(
                                              upgrade: upgrade,
                                              canAfford:
                                                  gameState.money >=
                                                  upgrade.getCost(
                                                    gameState.isHardMode,
                                                  ),
                                              onBuy: () =>
                                                  gameState.buyUpgrade(upgrade),
                                              formatNumber:
                                                  gameState.formatNumber,
                                              isHardMode: gameState.isHardMode,
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                    ),
                  ],
                ),
                // Overlays
                const GoldenPackageWidget(),
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
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Managers'),
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
    bool isPremium = false,
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
          side: (isActive && isPremium)
              ? const BorderSide(
                  color: Colors.white,
                  width: 3,
                ) // Gold/White contrast
              : (isActive
                    ? BorderSide(
                        color: Colors.white.withValues(alpha: .5),
                        width: 2,
                      )
                    : BorderSide.none),
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
              color: Colors.white.withValues(alpha: .9),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<GameState>(
          builder: (context, gameState, child) {
            return AlertDialog(
              title: const Text('Settings'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Scientific Notation'),
                    value: gameState.useScientificNotation,
                    onChanged: (value) {
                      gameState.toggleNumberFormat();
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Hard Mode (Production)'),
                    subtitle: const Text('Higher costs, less prestige'),
                    value: gameState.isHardMode,
                    onChanged: (value) {
                      gameState.toggleDifficulty();
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
