import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return ListView.builder(
            itemCount: gameState.achievements.length,
            itemBuilder: (context, index) {
              final achievement = gameState.achievements[index];
              return Card(
                color: achievement.isUnlocked
                    ? Colors.green[100]
                    : Colors.grey[300],
                child: ListTile(
                  leading: Icon(
                    achievement.isUnlocked ? Icons.emoji_events : Icons.lock,
                    color: achievement.isUnlocked ? Colors.amber : Colors.grey,
                  ),
                  title: Text(
                    achievement.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: achievement.isUnlocked
                          ? null
                          : TextDecoration.lineThrough,
                      color: achievement.isUnlocked
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        achievement.description,
                        style: TextStyle(
                          color: achievement.isUnlocked
                              ? Colors.black87
                              : Colors.grey[600],
                        ),
                      ),
                      if (!achievement.isUnlocked) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: LinearProgressIndicator(
                                value: gameState.getAchievementProgress(
                                  achievement,
                                ),
                                backgroundColor: Colors.grey[400],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(gameState.getAchievementProgress(achievement) * 100).toInt()}%',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  trailing: achievement.isUnlocked
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
