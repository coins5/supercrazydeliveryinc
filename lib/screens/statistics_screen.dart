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
              _buildSectionHeader(context, 'Settings', Icons.settings),
              Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 24),
                child: SwitchListTile(
                  title: const Text('Use Scientific Notation'),
                  subtitle: const Text('e.g. 1.23e6 vs 1.23M'),
                  secondary: const Icon(Icons.science),
                  value: gameState.useScientificNotation,
                  onChanged: (value) => gameState.toggleNumberFormat(),
                ),
              ),

              _buildSectionHeader(context, 'Economy', Icons.attach_money),
              _buildStatGrid(context, [
                _StatData(
                  'Current Money',
                  '\$${gameState.formatNumber(gameState.money)}',
                  Icons.account_balance_wallet,
                  Colors.green,
                ),
                _StatData(
                  'Money / Sec',
                  '\$${gameState.formatNumber(gameState.moneyPerSecond)}',
                  Icons.flash_on,
                  Colors.amber,
                ),
                _StatData(
                  'Total Earned',
                  '\$${gameState.formatNumber(gameState.totalMoneyEarned)}',
                  Icons.savings,
                  Colors.purple,
                ),
                _StatData(
                  'Click Value',
                  '\$${gameState.formatNumber(gameState.clickValue)}',
                  Icons.touch_app,
                  Colors.blue,
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader(context, 'Progress', Icons.trending_up),
              _buildStatGrid(context, [
                _StatData(
                  'Total Orders',
                  gameState.formatNumber(gameState.totalOrders.toDouble()),
                  Icons.local_shipping,
                  Colors.orange,
                ),
                _StatData(
                  'Units Owned',
                  gameState.totalUnitsPurchased.toString(),
                  Icons.store,
                  Colors.brown,
                ),
                _StatData(
                  'Upgrades',
                  '${gameState.totalUpgradesPurchased} / ${gameState.upgrades.length}',
                  Icons.arrow_circle_up,
                  Colors.teal,
                ),
                _StatData(
                  'Achievements',
                  '${gameState.unlockedAchievementsCount} / ${gameState.achievements.length}',
                  Icons.emoji_events,
                  Colors.amberAccent,
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader(context, 'General', Icons.info),
              _buildStatGrid(context, [
                _StatData(
                  'Total Clicks',
                  gameState.totalClicks.toString(),
                  Icons.mouse,
                  Colors.grey,
                ),
                _StatData(
                  'Time Played',
                  gameState.playTime,
                  Icons.timer,
                  Colors.indigo,
                ),
              ]),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber.shade900, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatGrid(BuildContext context, List<_StatData> stats) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: stat.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(stat.icon, color: stat.color, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        stat.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stat.value,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  _StatData(this.label, this.value, this.icon, this.color);
}
