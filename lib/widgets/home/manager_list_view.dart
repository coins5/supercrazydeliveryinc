import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';
import '../manager_card.dart';

class ManagerListView extends StatelessWidget {
  const ManagerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: gameState.hireAllManagers,
                icon: const Icon(Icons.people_outline),
                label: const Text("HIRE ALL MANAGERS"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: gameState.managers.length,
                itemBuilder: (context, index) {
                  final manager = gameState.managers[index];
                  return ManagerCard(
                    manager: manager,
                    canAfford:
                        gameState.money >=
                        manager.getCost(gameState.isHardMode),
                    onHire: () => gameState.hireManager(manager),
                    formatNumber: gameState.formatNumber,
                    isHardMode: gameState.isHardMode,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
