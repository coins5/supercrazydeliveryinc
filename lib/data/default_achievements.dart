import '../models/achievement.dart';

List<Achievement> getDefaultAchievements() {
  return [
    // Clicks
    Achievement(
      id: 'first_click',
      name: 'First Step',
      description: 'Click the button once. Easy, right?',
      type: AchievementType.clicks,
      threshold: 1,
    ),
    Achievement(
      id: 'finger_workout',
      name: 'Finger Workout',
      description: 'Click 100 times. Feel the burn?',
      type: AchievementType.clicks,
      threshold: 100,
    ),
    Achievement(
      id: 'carpal_tunnel',
      name: 'Carpal Tunnel',
      description: 'Click 1,000 times. Maybe take a break.',
      type: AchievementType.clicks,
      threshold: 1000,
    ),
    Achievement(
      id: 'click_master',
      name: 'Click Master',
      description: 'Click 10,000 times. You are dedicated.',
      type: AchievementType.clicks,
      threshold: 10000,
    ),
    Achievement(
      id: 'click_god',
      name: 'Click God',
      description: 'Click 100,000 times. Are you a robot?',
      type: AchievementType.clicks,
      threshold: 100000,
    ),

    // Units (Specific Milestones)
    Achievement(
      id: 'grandma_army',
      name: 'Grandma\'s Army',
      description: 'Own 10 Grandmas on Skates.',
      type: AchievementType.unitCount,
      threshold: 10,
      targetUnitId: 'grandma',
    ),
    Achievement(
      id: 'pigeon_lord',
      name: 'Pigeon Lord',
      description: 'Own 50 Pigeon Flocks.',
      type: AchievementType.unitCount,
      threshold: 50,
      targetUnitId: 'pigeon_flock',
    ),
    Achievement(
      id: 'pizza_party',
      name: 'Pizza Party',
      description: 'Own 25 Rocket Pizzas.',
      type: AchievementType.unitCount,
      threshold: 25,
      targetUnitId: 'rocket_pizza',
    ),
    Achievement(
      id: 'teleport_tech',
      name: 'Portal Master',
      description: 'Own 10 Teleporter Stations.',
      type: AchievementType.unitCount,
      threshold: 10,
      targetUnitId: 'teleporter_station',
    ),
    Achievement(
      id: 'dragon_rider',
      name: 'Dragon Rider',
      description: 'Own 1 Dragon Express.',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'dragon_express',
    ),
    Achievement(
      id: 'galactic_empire',
      name: 'Galactic Empire',
      description: 'Own 10 Starship Enterprises.',
      type: AchievementType.unitCount,
      threshold: 10,
      targetUnitId: 'starship_enterprise',
    ),
    Achievement(
      id: 'abstract_thought',
      name: 'Abstract Thought',
      description: 'Own 1 Concept of Delivery.',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'concept_of_delivery',
    ),
    Achievement(
      id: 'divine_intervention',
      name: 'Divine Intervention',
      description: 'Own 1 God of Speed.',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'god_of_speed',
    ),
    Achievement(
      id: 'the_end',
      name: 'The End?',
      description: 'Own 1 Super Crazy Delivery Inc.',
      type: AchievementType.unitCount,
      threshold: 1,
      targetUnitId: 'super_crazy_delivery_inc.',
    ),

    // Money Milestones (Exponential)
    Achievement(
      id: 'richie_rich',
      name: 'Richie Rich',
      description: 'Earn \$1,000,000.',
      type: AchievementType.money,
      threshold: 1e6,
    ),
    Achievement(
      id: 'billionaire',
      name: 'Billionaire',
      description: 'Earn \$1,000,000,000.',
      type: AchievementType.money,
      threshold: 1e9,
    ),
    Achievement(
      id: 'trillionaire',
      name: 'Trillionaire',
      description: 'Earn \$1,000,000,000,000.',
      type: AchievementType.money,
      threshold: 1e12,
    ),
    Achievement(
      id: 'quadrillionaire',
      name: 'Quadrillionaire',
      description: 'Earn \$1e15.',
      type: AchievementType.money,
      threshold: 1e15,
    ),
    Achievement(
      id: 'quintillionaire',
      name: 'Quintillionaire',
      description: 'Earn \$1e18.',
      type: AchievementType.money,
      threshold: 1e18,
    ),
    Achievement(
      id: 'decillionaire',
      name: 'Decillionaire',
      description: 'Earn \$1e33.',
      type: AchievementType.money,
      threshold: 1e33,
    ),
    Achievement(
      id: 'googol',
      name: 'Googol',
      description: 'Earn \$1e100.',
      type: AchievementType.money,
      threshold: 1e100,
    ),

    // General Progress
    Achievement(
      id: 'upgrade_addict',
      name: 'Upgrade Addict',
      description: 'Buy 10 upgrades.',
      type: AchievementType.upgrades,
      threshold: 10,
    ),
    Achievement(
      id: 'upgrade_maniac',
      name: 'Upgrade Maniac',
      description: 'Buy 100 upgrades.',
      type: AchievementType.upgrades,
      threshold: 100,
    ),
    Achievement(
      id: 'upgrade_god',
      name: 'Upgrade God',
      description: 'Buy 500 upgrades.',
      type: AchievementType.upgrades,
      threshold: 500,
    ),

    // Playtime
    Achievement(
      id: 'addicted',
      name: 'Addicted',
      description: 'Play for 1 hour.',
      type: AchievementType.playTime,
      threshold: 3600,
    ),
    Achievement(
      id: 'dedicated',
      name: 'Dedicated',
      description: 'Play for 24 hours.',
      type: AchievementType.playTime,
      threshold: 86400,
    ),
  ];
}
