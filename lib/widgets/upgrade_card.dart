import 'package:flutter/material.dart';
import '../models/upgrade.dart';

class UpgradeCard extends StatelessWidget {
  final Upgrade upgrade;
  final bool canAfford;
  final VoidCallback onBuy;

  const UpgradeCard({
    super.key,
    required this.upgrade,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upgrade.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    upgrade.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (upgrade.isPurchased)
              const Icon(Icons.check_circle, color: Colors.green)
            else
              ElevatedButton(
                onPressed: canAfford ? onBuy : null,
                child: Text('\$${upgrade.cost.toStringAsFixed(0)}'),
              ),
          ],
        ),
      ),
    );
  }
}
