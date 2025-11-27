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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.evolvedName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: unit.evolutionMultiplier > 1
                          ? Colors.purple
                          : null,
                      fontWeight: unit.evolutionMultiplier > 1
                          ? FontWeight.bold
                          : null,
                    ),
                  ),
                  Text(
                    unit.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text('Owned: ${unit.count}'),
                  Text('Income: \$${formatNumber(unit.totalIncome)}/s'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showUnitInfo(context),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text('\$${formatNumber(buyCost)}'),
                ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  child: Text(buyAmount > 1 ? 'BUY x$buyAmount' : 'BUY'),
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
