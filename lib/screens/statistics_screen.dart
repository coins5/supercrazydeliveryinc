import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics & Settings'),
        backgroundColor: Colors.amber,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionHeader(context, 'Settings'),
              SwitchListTile(
                title: const Text('Use Scientific Notation'),
                subtitle: const Text('e.g. 1.23e6 vs 1.23M'),
                value: gameState.useScientificNotation,
                onChanged: (value) => gameState.toggleNumberFormat(),
              ),
              const Divider(height: 32),
              _buildSectionHeader(context, 'Statistics'),
              _buildStatItem(
                context,
                'Total Clicks',
                gameState.totalClicks.toString(),
              ),
              _buildStatItem(
                context,
                'Total Money Earned',
                '\$${gameState.formatNumber(gameState.totalMoneyEarned)}',
              ),
              _buildStatItem(
                context,
                'Total Orders Completed',
                gameState.formatNumber(gameState.totalOrders.toDouble()),
              ),
              _buildStatItem(context, 'Time Played', gameState.playTime),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.amber.shade900,
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
