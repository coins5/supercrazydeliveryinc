import 'package:flutter/material.dart';
import '../models/manager.dart';

class ManagerCard extends StatelessWidget {
  final Manager manager;
  final bool canAfford;
  final VoidCallback onHire;
  final String Function(double) formatNumber;
  final bool isHardMode;

  const ManagerCard({
    super.key,
    required this.manager,
    required this.canAfford,
    required this.onHire,
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
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Manager Icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: manager.isHired ? Colors.green[100] : Colors.grey[200],
                shape: BoxShape.circle,
                border: Border.all(
                  color: manager.isHired ? Colors.green : Colors.grey,
                  width: 3,
                ),
              ),
              child: Icon(
                _getIconForType(manager.type),
                size: 32,
                color: manager.isHired ? Colors.green[800] : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manager.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    manager.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),

            // Action
            const SizedBox(width: 8),
            if (manager.isHired)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'HIRED',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: canAfford ? onHire : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canAfford ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('\$${formatNumber(manager.cost)}'),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(ManagerType type) {
    switch (type) {
      case ManagerType.autoClick:
        return Icons.touch_app;
      case ManagerType.unitBoost:
        return Icons.trending_up;
      case ManagerType.discount:
        return Icons.percent;
    }
  }
}
