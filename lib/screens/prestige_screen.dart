import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/crazy_dialog.dart';

class PrestigeScreen extends StatelessWidget {
  const PrestigeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prestige'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade900, Colors.black],
          ),
        ),
        child: Consumer<GameState>(
          builder: (context, gameState, child) {
            final potentialTokens = gameState.calculatePotentialTokens();
            final currentMultiplier = gameState.prestigeMultiplier;
            final nextMultiplier =
                1.0 + ((gameState.prestigeTokens + potentialTokens) * 0.10);

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.rocket_launch,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ASCEND TO A NEW DIMENSION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildStatRow(
                    'Current Crazy Tokens',
                    gameState.formatNumber(gameState.prestigeTokens.toDouble()),
                    Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  _buildStatRow(
                    'Current Multiplier',
                    'x${gameState.formatNumber(currentMultiplier)}',
                    Colors.greenAccent,
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'PRESTIGE NOW TO EARN',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '+${gameState.formatNumber(potentialTokens.toDouble())} TOKENS',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Colors.orange, blurRadius: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'New Multiplier: x${gameState.formatNumber(nextMultiplier)}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: potentialTokens > 0
                        ? () => _showConfirmationDialog(context, gameState)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('RESET & PRESTIGE'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Warning: This will reset your Money, Units, and Upgrades.\nYou will keep Achievements, Stats, and Premium.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, GameState gameState) {
    showCrazyDialog(
      context: context,
      title: 'Are you sure?',
      themeColor: Colors.redAccent,
      content: const Text(
        'You are about to reset your progress for Crazy Tokens.\n\n'
        'This action cannot be undone!',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            gameState.prestige();
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Close Prestige Screen
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('DO IT!'),
        ),
      ],
    );
  }
}
