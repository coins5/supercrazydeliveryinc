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

    // Golden Packages
    Achievement(
      id: 'lucky_find',
      name: 'Lucky Find',
      description: 'Click 1 Golden Package.',
      type: AchievementType.goldenPackages,
      threshold: 1,
    ),
    Achievement(
      id: 'treasure_hunter',
      name: 'Treasure Hunter',
      description: 'Click 10 Golden Packages.',
      type: AchievementType.goldenPackages,
      threshold: 10,
    ),
    Achievement(
      id: 'gold_rush',
      name: 'Gold Rush',
      description: 'Click 50 Golden Packages.',
      type: AchievementType.goldenPackages,
      threshold: 50,
    ),
    Achievement(
      id: 'midas_touch',
      name: 'Midas Touch',
      description: 'Click 100 Golden Packages.',
      type: AchievementType.goldenPackages,
      threshold: 100,
    ),

    // Boosts
    Achievement(
      id: 'need_for_speed',
      name: 'Need for Speed',
      description: 'Activate Boost 1 time.',
      type: AchievementType.boosts,
      threshold: 1,
    ),
    Achievement(
      id: 'turbo_charged',
      name: 'Turbo Charged',
      description: 'Activate Boost 10 times.',
      type: AchievementType.boosts,
      threshold: 10,
    ),
    Achievement(
      id: 'warp_speed',
      name: 'Warp Speed',
      description: 'Activate Boost 50 times.',
      type: AchievementType.boosts,
      threshold: 50,
    ),

    // Managers
    Achievement(
      id: 'hiring_manager',
      name: 'Hiring Manager',
      description: 'Hire 1 Manager.',
      type: AchievementType.managersHired,
      threshold: 1,
    ),
    Achievement(
      id: 'middle_management',
      name: 'Middle Management',
      description: 'Hire 10 Managers.',
      type: AchievementType.managersHired,
      threshold: 10,
    ),
    Achievement(
      id: 'executive_board',
      name: 'Executive Board',
      description: 'Hire 50 Managers.',
      type: AchievementType.managersHired,
      threshold: 50,
    ),
    Achievement(
      id: 'corporate_overlord',
      name: 'Corporate Overlord',
      description: 'Hire ALL Managers.',
      type: AchievementType.allManagersHired,
      threshold: 1, // Boolean check
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
    Achievement(
      id: 'gotta_catch_em_all',
      name: 'Gotta Catch \'Em All',
      description: 'Unlock ALL Delivery Units.',
      type: AchievementType.allUnitsUnlocked,
      threshold: 1, // Boolean check
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
    Achievement(
      id: 'maxed_out',
      name: 'Maxed Out',
      description: 'Buy ALL Upgrades.',
      type: AchievementType.allUpgradesPurchased,
      threshold: 1, // Boolean check
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
