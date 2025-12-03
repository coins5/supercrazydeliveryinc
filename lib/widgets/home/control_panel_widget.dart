import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../fire_border.dart';
import '../../screens/premium_screen.dart';
import '../crazy_dialog.dart';
import '../../services/ad_service.dart';

class ControlPanelWidget extends StatelessWidget {
  const ControlPanelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return SingleChildScrollView(
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
                    : () {
                        if (gameState.isPremium ||
                            !gameState.hasUsedFreeBoost) {
                          gameState.activateBoost();
                        } else {
                          // Show Ad Dialog
                          showCrazyDialog(
                            context: context,
                            title: "BOOST PRODUCTION!",
                            content: const Text(
                              "Watch an ad to double your production for 4 hours?",
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("CANCEL"),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  AdService.instance.showRewardedAd(
                                    onUserEarnedReward: () {
                                      gameState.activateBoost();
                                      Navigator.pop(context);
                                    },
                                    onAdFailedToShow: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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
                                label: const Text("WATCH AD"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                isActive: gameState.isBoostActive,
                activeColor: Colors.green,
                inactiveColor: Colors.redAccent,
                label: gameState.isBoostActive ? "BOOST ACTIVE" : "BOOST x2",
                subLabel: gameState.isBoostActive
                    ? (gameState.boostRemainingTime.inMinutes >= (23 * 60 + 30)
                          ? "MAX (24h)"
                          : gameState.boostRemainingTime
                                .toString()
                                .split('.')
                                .first)
                    : (gameState.isPremium
                          ? "FREE (PREMIUM)"
                          : (!gameState.hasUsedFreeBoost
                                ? "FREE"
                                : "WATCH AD")),
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
                              builder: (context) => const PremiumScreen(),
                            ),
                          );
                        },
                  isActive: gameState.isPremium,
                  activeColor: Colors.amber,
                  inactiveColor: Colors.amber,
                  label: "PREMIUM",
                  subLabel: gameState.isPremium ? "FOREVER" : "x2 PERM",
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
        );
      },
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
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
