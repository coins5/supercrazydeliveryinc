import '../models/achievement.dart';

List<Achievement> getDefaultAchievements() {
  List<Achievement> achievements = [];

  // 1. Clicks (10)
  final clickMilestones = {
    1: 'First Tap!',
    100: 'Finger Warmup',
    500: 'Carpal Tunnel Starter',
    1000: 'Screen Smasher',
    2500: 'Tap-o-Maniac',
    5000: 'Finger of Fury',
    10000: 'Screen Destroyer',
    25000: 'The Chosen Clicker',
    50000: 'Tap God',
    100000: 'Infinity Tapper',
  };
  clickMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'clicks_$threshold',
        name: name,
        description: 'Tap $threshold times.',
        type: AchievementType.clicks,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 2. Golden Packages (5)
  final gpMilestones = {
    1: 'Lucky Find!',
    10: 'Gold Digger',
    25: 'Shiny Object Syndrome',
    50: 'Midas Touch',
    100: 'Golden Goose',
  };
  gpMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'golden_package_$threshold',
        name: name,
        description: 'Click $threshold Golden Packages.',
        type: AchievementType.goldenPackages,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 3. Boosts (4)
  final boostMilestones = {
    1: 'Nitro Boost!',
    10: 'Adrenaline Junkie',
    25: 'Warp Speed',
    50: 'Ludicrous Speed',
  };
  boostMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'boost_$threshold',
        name: name,
        description: 'Activate Boost $threshold times.',
        type: AchievementType.boosts,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 4. Managers (5)
  final managerMilestones = {
    1: "You're Hired!",
    10: 'Middle Management',
    25: 'Corporate Ladder',
    50: 'Board of Directors',
    100: 'CEO of Everything',
  };
  managerMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'manager_hired_$threshold',
        name: name,
        description: 'Hire $threshold Managers.',
        type: AchievementType.managersHired,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 5. Upgrades (6)
  final upgradeMilestones = {
    10: 'Upgrade Junkie',
    50: 'Cutting Edge',
    100: 'Future is Now',
    250: 'Singularity Seeker',
    500: 'Tech Overlord',
    1000: 'God Mode',
  };
  upgradeMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'upgrades_$threshold',
        name: name,
        description: 'Buy $threshold Upgrades.',
        type: AchievementType.upgrades,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 6. Playtime (3)
  achievements.add(
    Achievement(
      id: 'playtime_1h',
      name: 'Just 5 More Minutes',
      description: 'Play for 1 hour.',
      type: AchievementType.playTime,
      threshold: 3600,
    ),
  );
  achievements.add(
    Achievement(
      id: 'playtime_24h',
      name: 'No Life',
      description: 'Play for 24 hours.',
      type: AchievementType.playTime,
      threshold: 86400,
    ),
  );
  achievements.add(
    Achievement(
      id: 'playtime_100h',
      name: 'Touch Grass',
      description: 'Play for 100 hours.',
      type: AchievementType.playTime,
      threshold: 360000,
    ),
  );

  // 7. Evolutions (6)
  final evolutionMilestones = {
    1: "It's Evolving!",
    5: "Darwin's Favorite",
    10: 'Mutant Army',
    25: 'Genetic Freak',
    50: 'Apex Predator',
    100: 'Ultimate Lifeform',
  };
  evolutionMilestones.forEach((threshold, name) {
    achievements.add(
      Achievement(
        id: 'evolution_$threshold',
        name: name,
        description: 'Evolve units $threshold times.',
        type: AchievementType.evolutions,
        threshold: threshold.toDouble(),
      ),
    );
  });

  // 8. Completionist (3)
  achievements.add(
    Achievement(
      id: 'all_units',
      name: 'Monopoly Man',
      description: 'Unlock ALL Delivery Units.',
      type: AchievementType.allUnitsUnlocked,
      threshold: 1,
    ),
  );
  achievements.add(
    Achievement(
      id: 'all_managers',
      name: 'Wolf of Wall Street',
      description: 'Hire ALL Managers.',
      type: AchievementType.allManagersHired,
      threshold: 1,
    ),
  );
  achievements.add(
    Achievement(
      id: 'all_upgrades',
      name: 'Completionist King',
      description: 'Buy ALL Upgrades.',
      type: AchievementType.allUpgradesPurchased,
      threshold: 1,
    ),
  );

  // 9. Money (21)
  final moneyMilestones = {
    3: 'Pocket Change',
    6: 'Millionaire Status',
    9: 'Three Comma Club',
    12: 'Trillionaire Tycoon',
    15: 'Quadrillionaire Quest',
    18: 'Quintillionaire King',
    21: 'Sextillionaire Supreme',
    24: 'Septillionaire Sultan',
    27: 'Octillionaire Overlord',
    30: 'Nonillionaire Ninja',
    33: 'Decillionaire Deity',
    36: 'Undecillionaire Universe',
    39: 'Duodecillionaire Dragon',
    42: 'Tredecillionaire Titan',
    45: 'Quattuordecillionaire Quasar',
    48: 'Quindecillionaire Quantum',
    51: 'Sexdecillionaire Supernova',
    54: 'Septendecillionaire Star',
    57: 'Octodecillionaire Oracle',
    60: 'Novemdecillionaire Nebula',
  };

  moneyMilestones.forEach((power, name) {
    double val = double.parse('1e$power');
    achievements.add(
      Achievement(
        id: 'money_1e$power',
        name: name,
        description: 'Earn \$1e$power.',
        type: AchievementType.money,
        threshold: val,
      ),
    );
  });

  achievements.add(
    Achievement(
      id: 'money_googol',
      name: 'Infinite Money Glitch',
      description: 'Earn \$1e100.',
      type: AchievementType.money,
      threshold: 1e100,
    ),
  );

  // 10. Unit Collectors (60)
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
        name: 'Lord of ${data.$1}s',
        description: 'Own 1 ${data.$1}.',
        type: AchievementType.unitCount,
        threshold: 1,
        targetUnitId: data.$2,
      ),
    );
  }

  return achievements;
}
