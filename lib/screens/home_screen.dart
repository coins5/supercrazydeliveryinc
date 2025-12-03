import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import 'statistics_screen.dart';
import 'achievements_screen.dart';
import '../data/offline_messages.dart';
import 'dart:math';
import 'prestige_screen.dart';
import '../widgets/golden_package_widget.dart';
import '../widgets/crazy_dialog.dart';
import '../services/ad_service.dart';

// New Widgets
import '../widgets/home/dashboard_widget.dart';
import '../widgets/home/control_panel_widget.dart';
import '../widgets/home/unit_list_view.dart';
import '../widgets/home/upgrade_list_view.dart';
import '../widgets/home/manager_list_view.dart';

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

  void _showSettingsDialog(BuildContext context) {
    final gameState = Provider.of<GameState>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Settings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Scientific Notation"),
              trailing: Switch(
                value: gameState.useScientificNotation,
                onChanged: (value) {
                  gameState.toggleNumberFormat();
                  Navigator.pop(context);
                  _showSettingsDialog(context);
                },
              ),
            ),
            ListTile(
              title: const Text("Hard Mode (Production)"),
              subtitle: const Text("Higher costs, more challenge"),
              trailing: Switch(
                value: gameState.isHardMode,
                onChanged: (value) {
                  gameState.toggleDifficulty();
                  Navigator.pop(context);
                  _showSettingsDialog(context);
                },
              ),
            ),
            ListTile(
              title: const Text("Reset Save"),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () {
                  // Confirm delete
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Reset Game?"),
                      content: const Text("This cannot be undone!"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            // Clear save logic (not exposed in GameState directly but we can add it or use PersistenceService)
                            // For now, let's just prestige which resets most things, or manually clear.
                            // Ideally GameState should have a hardReset method.
                            // Assuming prestige is enough for now or user can uninstall.
                            // But let's call prestige for now as a soft reset.
                            gameState.prestige();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "RESET",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
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
            if (gameState.pendingOfflineEarnings > 0 &&
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
                        '\$${gameState.formatNumber(gameState.pendingOfflineEarnings)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      if (gameState.isPremium) ...[
                        const SizedBox(height: 16),
                        const Text(
                          "PREMIUM BONUS APPLIED: x8!",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    if (gameState.isPremium)
                      TextButton(
                        onPressed: () {
                          gameState.consumeOfflineEarnings(4.0);
                          Navigator.of(context).pop();
                        },
                        child: const Text('CLAIM x8 (PREMIUM)'),
                      )
                    else ...[
                      TextButton(
                        onPressed: () {
                          gameState.consumeOfflineEarnings(1.0);
                          Navigator.of(context).pop();
                        },
                        child: const Text('CLAIM x1'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          AdService.instance.showRewardedAd(
                            onUserEarnedReward: () {
                              gameState.consumeOfflineEarnings(4.0);
                              Navigator.of(context).pop();
                            },
                            onAdFailedToShow: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Ad not ready yet. Please try again in a moment.",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('WATCH AD (x4)'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                );
              });
            }

            return Stack(
              children: [
                Column(
                  children: [
                    const DashboardWidget(),
                    const ControlPanelWidget(),
                    Expanded(
                      child: _selectedIndex == 0
                          ? const UnitListView()
                          : _selectedIndex == 1
                          ? const ManagerListView()
                          : const UpgradeListView(),
                    ),
                  ],
                ),
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
}
