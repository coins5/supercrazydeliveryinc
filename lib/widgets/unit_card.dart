import 'package:flutter/material.dart';
import '../models/delivery_unit.dart';

class UnitCard extends StatelessWidget {
  final DeliveryUnit unit;
  final VoidCallback onBuy;
  final bool canAfford;

  const UnitCard({
    super.key,
    required this.unit,
    required this.onBuy,
    required this.canAfford,
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
                    unit.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    unit.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text('Owned: ${unit.count}'),
                  Text('Income: \$${unit.baseIncome}/s'),
                ],
              ),
            ),
            Column(
              children: [
                Text('\$${unit.currentCost.toStringAsFixed(0)}'),
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
