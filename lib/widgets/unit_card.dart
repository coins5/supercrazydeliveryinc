import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/delivery_unit.dart';
import '../models/game_state.dart';

class UnitCard extends StatelessWidget {
  final DeliveryUnit unit;
  final VoidCallback onBuy;
  final bool canAfford;
  final String Function(double) formatNumber;
  final double buyCost;
  final int buyAmount;

  const UnitCard({
    super.key,
    required this.unit,
    required this.onBuy,
    required this.canAfford,
    required this.formatNumber,
    required this.buyCost,
    required this.buyAmount,
  });

  @override
  Widget build(BuildContext context) {
    final isEvolved = unit.evolutionMultiplier > 1;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isEvolved
            ? const BorderSide(color: Colors.purpleAccent, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isEvolved ? Colors.purple.shade100 : Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isEvolved ? Icons.rocket_launch : Icons.local_shipping,
                color: isEvolved ? Colors.purple : Colors.blue,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.evolvedName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isEvolved ? Colors.purple : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    unit.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Owned: ${unit.count}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '+\$${formatNumber(unit.totalIncome)}/s',
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline, size: 20),
                  color: Colors.grey,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _showUnitInfo(context),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canAfford ? Colors.blue : Colors.grey[300],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                  child: Column(
                    children: [
                      Text(
                        buyAmount > 1 ? 'BUY x$buyAmount' : 'BUY',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${formatNumber(buyCost)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final gameState = Provider.of<GameState>(context, listen: false);
        final unitUpgrades = gameState.upgrades
            .where((u) => u.targetUnitId == unit.id)
            .toList();

        return AlertDialog(
          title: Text(unit.name),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upgrades:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (unitUpgrades.isEmpty) const Text('None'),
                ...unitUpgrades.map(
                  (u) => Text(
                    u.isPurchased ? "- ${u.name}" : "- ?????",
                    style: TextStyle(
                      color: u.isPurchased ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Evolutions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                _buildEvolutionText(100, "Turbo", unit.count),
                _buildEvolutionText(250, "Radioactive", unit.count),
                _buildEvolutionText(500, "Quantum", unit.count),
                _buildEvolutionText(1000, "Godlike", unit.count),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEvolutionText(int threshold, String prefix, int currentCount) {
    final isUnlocked = currentCount >= threshold;
    return Text(
      isUnlocked ? "- $prefix ${unit.name}" : "- ??????",
      style: TextStyle(color: isUnlocked ? Colors.purple : Colors.grey),
    );
  }
}
