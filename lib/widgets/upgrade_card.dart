import 'package:flutter/material.dart';
import '../models/upgrade.dart';

class UpgradeCard extends StatelessWidget {
  final Upgrade upgrade;
  final bool canAfford;
  final VoidCallback onBuy;
  final String Function(double) formatNumber;
  final bool isHardMode;

  const UpgradeCard({
    super.key,
    required this.upgrade,
    required this.canAfford,
    required this.onBuy,
    required this.formatNumber,
    required this.isHardMode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.upgrade, color: Colors.orange, size: 28),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    upgrade.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    upgrade.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            // Action
            if (upgrade.isPurchased)
              const Icon(Icons.check_circle, color: Colors.green, size: 32)
            else
              ElevatedButton(
                onPressed: canAfford ? onBuy : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.orange : Colors.grey[300],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  minimumSize: const Size(0, 36),
                ),
                child: Text(
                  '\$${formatNumber(upgrade.cost)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
