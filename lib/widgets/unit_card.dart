import 'package:flutter/material.dart';
import '../models/delivery_unit.dart';

class UnitCard extends StatelessWidget {
  final DeliveryUnit unit;
  final VoidCallback onBuy;
  final bool canAfford;
  final String Function(double) formatNumber;

  const UnitCard({
    super.key,
    required this.unit,
    required this.onBuy,
    required this.canAfford,
    required this.formatNumber,
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
                  Text('Income: \$${formatNumber(unit.baseIncome)}/s'),
                ],
              ),
            ),
            Column(
              children: [
                Text('\$${formatNumber(unit.currentCost)}'),
                ElevatedButton(
                  onPressed: canAfford ? onBuy : null,
                  child: const Text('BUY'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
