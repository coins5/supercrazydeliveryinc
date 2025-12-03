import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/crazy_dialog.dart';
import '../services/ad_service.dart';

class GoldenPackageWidget extends StatefulWidget {
  const GoldenPackageWidget({super.key});

  @override
  State<GoldenPackageWidget> createState() => _GoldenPackageWidgetState();
}

class _GoldenPackageWidgetState extends State<GoldenPackageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        if (!gameState.goldenPackageActive) return const SizedBox.shrink();

        // Use Align for relative positioning within the Stack
        // Map 0.0-1.0 to -1.0-1.0
        final alignX = (gameState.goldenPackageX * 2) - 1;
        final alignY = (gameState.goldenPackageY * 2) - 1;

        return Align(
          alignment: Alignment(alignX, alignY),
          child: GestureDetector(
            onTap: () {
              final result = gameState.calculateGoldenReward();
              _showRewardDialog(
                context,
                gameState,
                result.amount,
                result.message,
                result.story,
              );
            },
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white, // Solid background
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.card_giftcard,
                      color: Colors.amber[800], // Darker gold for contrast
                      size: 48,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showRewardDialog(
    BuildContext context,
    GameState gameState,
    double baseAmount,
    String message,
    String story,
  ) {
    showCrazyDialog(
      context: context,
      title: 'GOLDEN PACKAGE!',
      themeColor: Colors.amber,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            story,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Base Reward: \$${gameState.formatNumber(baseAmount)}",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        if (gameState.isPremium)
          TextButton(
            onPressed: () {
              // Premium x10
              gameState.claimGoldenPackageReward(baseAmount, 10.0);
              Navigator.pop(context);
            },
            child: const Text('CLAIM x10 (PREMIUM)'),
          )
        else ...[
          TextButton(
            onPressed: () {
              // Normal x1
              gameState.claimGoldenPackageReward(baseAmount, 1.0);
              Navigator.pop(context);
            },
            child: const Text('CLAIM x1'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              AdService.instance.showRewardedAd(
                onUserEarnedReward: () {
                  // Ad x5
                  gameState.claimGoldenPackageReward(baseAmount, 5.0);
                  Navigator.pop(context);
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
            label: const Text('WATCH AD (x5)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber[800],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}
