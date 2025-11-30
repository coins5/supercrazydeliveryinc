import '../models/achievement.dart';

List<Achievement> getDefaultAchievements() {
  List<Achievement> achievements = [];

  // 1. Clicks (10)
  final clickMilestones = [
    1,
    100,
    500,
    1000,
    2500,
    5000,
    10000,
    25000,
    50000,
    100000,
  ];
  for (var threshold in clickMilestones) {
    achievements.add(
      Achievement(
        id: 'clicks_$threshold',
        name: 'Clicker $threshold',
        description: 'Click the button $threshold times.',
        type: AchievementType.clicks,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 2. Golden Packages (5)
  final gpMilestones = [1, 10, 25, 50, 100];
  for (var threshold in gpMilestones) {
    achievements.add(
      Achievement(
        id: 'golden_package_$threshold',
        name: 'Treasure Hunter $threshold',
        description: 'Click $threshold Golden Packages.',
        type: AchievementType.goldenPackages,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 3. Boosts (4)
  final boostMilestones = [1, 10, 25, 50];
  for (var threshold in boostMilestones) {
    achievements.add(
      Achievement(
        id: 'boost_$threshold',
        name: 'Speed Demon $threshold',
        description: 'Activate Boost $threshold times.',
        type: AchievementType.boosts,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 4. Managers (5)
  final managerMilestones = [1, 10, 25, 50, 100];
  for (var threshold in managerMilestones) {
    achievements.add(
      Achievement(
        id: 'manager_hired_$threshold',
        name: 'HR Department $threshold',
        description: 'Hire $threshold Managers.',
        type: AchievementType.managersHired,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 5. Upgrades (6)
  final upgradeMilestones = [10, 50, 100, 250, 500, 1000];
  for (var threshold in upgradeMilestones) {
    achievements.add(
      Achievement(
        id: 'upgrades_$threshold',
        name: 'Tech Enthusiast $threshold',
        description: 'Buy $threshold Upgrades.',
        type: AchievementType.upgrades,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 6. Playtime (3)
  achievements.add(
    Achievement(
      id: 'playtime_1h',
      name: 'Getting Started',
      description: 'Play for 1 hour.',
      type: AchievementType.playTime,
      threshold: 3600,
    ),
  );
  achievements.add(
    Achievement(
      id: 'playtime_24h',
      name: 'Dedicated',
      description: 'Play for 24 hours.',
      type: AchievementType.playTime,
      threshold: 86400,
    ),
  );
  achievements.add(
    Achievement(
      id: 'playtime_100h',
      name: 'Addicted',
      description: 'Play for 100 hours.',
      type: AchievementType.playTime,
      threshold: 360000,
    ),
  );

  // 7. Evolutions (6)
  final evolutionMilestones = [1, 5, 10, 25, 50, 100];
  for (var threshold in evolutionMilestones) {
    achievements.add(
      Achievement(
        id: 'evolution_$threshold',
        name: 'Evolution Master $threshold',
        description: 'Evolve units $threshold times.',
        type: AchievementType.evolutions,
        threshold: threshold.toDouble(),
      ),
    );
  }

  // 8. Completionist (3)
  achievements.add(
    Achievement(
      id: 'all_units',
      name: 'Gotta Catch \'Em All',
      description: 'Unlock ALL Delivery Units.',
      type: AchievementType.allUnitsUnlocked,
      threshold: 1,
    ),
  );
  achievements.add(
    Achievement(
      id: 'all_managers',
      name: 'Corporate Overlord',
      description: 'Hire ALL Managers.',
      type: AchievementType.allManagersHired,
      threshold: 1,
    ),
  );
  achievements.add(
    Achievement(
      id: 'all_upgrades',
      name: 'Maxed Out',
      description: 'Buy ALL Upgrades.',
      type: AchievementType.allUpgradesPurchased,
      threshold: 1,
    ),
  );

  // 9. Money (21)
  // Powers of 10 from 1e3 to 1e60 (every 3 orders of magnitude) + 1e100
  for (int i = 3; i <= 60; i += 3) {
    double val = double.parse('1e$i');
    achievements.add(
      Achievement(
        id: 'money_1e$i',
        name: 'Wealth 1e$i',
        description: 'Earn \$1e$i.',
        type: AchievementType.money,
        threshold: val,
      ),
    );
  }
  achievements.add(
    Achievement(
      id: 'money_googol',
      name: 'Googol',
      description: 'Earn \$1e100.',
      type: AchievementType.money,
      threshold: 1e100,
    ),
  );

  // 10. Unit Collectors (60)
  // We need the IDs of the first 60 units.
  // I'll reconstruct the list here to ensure IDs match exactly what's in default_units.dart
  final List<(String, String)> unitData = [
    ('Grandma on Skates', 'grandma'),
    ('Paper Boy', 'paper_boy'),
    ('Rusty Drone', 'drone'),
    ('Pigeon Flock', 'pigeon_flock'),
    ('Skateboard Kid', 'skateboard_kid'),
    ('Roller Derby Team', 'roller_derby_team'),
    ('Unicycle Clown', 'unicycle_clown'),
    ('Rickshaw Runner', 'rickshaw_runner'),
    ('Shopping Cart Hero', 'shopping_cart_hero'),
    ('Segway Tour', 'segway_tour'),
    ('Moped Gang', 'moped_gang'),
    ('Pizza Scooter', 'pizza_scooter'),
    ('Golf Cart', 'golf_cart'),
    ('Mail Truck', 'mail_truck'),
    ('Ice Cream Van', 'ice_cream_van'),
    ('Rocket Pizza', 'rocket_pizza'),
    ('Monster Truck', 'monster_truck'),
    ('Formula 1 Car', 'formula_1_car'),
    ('Bullet Train', 'bullet_train'),
    ('Cargo Plane', 'cargo_plane'),
    ('Delivery Drone Swarm', 'delivery_drone_swarm'),
    ('Robot Courier', 'robot_courier'),
    ('Hoverboarder', 'hoverboarder'),
    ('Jetpack Joyrider', 'jetpack_joyrider'),
    ('Hyperloop Pod', 'hyperloop_pod'),
    ('Package Catapult', 'package_catapult'),
    ('Delivery Cannon', 'delivery_cannon'),
    ('Railgun Launcher', 'railgun_launcher'),
    ('Orbital Drop Pod', 'orbital_drop_pod'),
    ('Teleporting Dog', 'teleporting_dog'),
    ('Cybernetic Runner', 'cybernetic_runner'),
    ('Anti-Gravity Van', 'anti-gravity_van'),
    ('UFO', 'ufo'),
    ('Alien Mothership', 'alien_mothership'),
    ('Portal Gun', 'portal_gun'),
    ('Teleporter Station', 'teleporter_station'),
    ('Matter Replicator', 'matter_replicator'),
    ('Nanobot Cloud', 'nanobot_cloud'),
    ('Time Traveler', 'time_traveler'),
    ('TARDIS', 'tardis'),
    ('Running Wizard', 'running_wizard'),
    ('Magic Carpet', 'magic_carpet'),
    ('Broomstick Rider', 'broomstick_rider'),
    ('Griffin Rider', 'griffin_rider'),
    ('Dragon Express', 'dragon_express'),
    ('Phoenix', 'phoenix'),
    ('Pegasus', 'pegasus'),
    ('Giant Eagle', 'giant_eagle'),
    ('Telepathic Monk', 'telepathic_monk'),
    ('Genie', 'genie'),
    ('Moon Lander', 'moon_lander'),
    ('Mars Rover', 'mars_rover'),
    ('Solar Sailer', 'solar_sailer'),
    ('Asteroid Miner', 'asteroid_miner'),
    ('Comet Surfer', 'comet_surfer'),
    ('Starship Enterprise', 'starship_enterprise'),
    ('Dyson Sphere', 'dyson_sphere'),
    ('Black Hole Courier', 'black_hole_courier'),
    ('Wormhole Express', 'wormhole_express'),
    ('Quasar Beam', 'quasar_beam'),
  ];

  for (var data in unitData) {
    achievements.add(
      Achievement(
        id: 'own_${data.$2}',
        name: 'Owner: ${data.$1}',
        description: 'Own 1 ${data.$1}.',
        type: AchievementType.unitCount,
        threshold: 1,
        targetUnitId: data.$2,
      ),
    );
  }

  return achievements;
}
