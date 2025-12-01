import '../models/delivery_unit.dart';

List<DeliveryUnit> getDefaultUnits() {
  final List<(String, String)> unitData = [
    // Tier 1: Basics (1-10)
    ('Grandma on Skates', 'Slow but reliable. Cookies included.'),
    ('Paper Boy', 'Throws newspapers with surprising accuracy.'),
    ('Rusty Drone', 'Might drop the package, but it flies.'),
    ('Pigeon Flock', 'Thousands of them. Very messy.'),
    ('Skateboard Kid', 'Radical delivery speeds.'),
    ('Roller Derby Team', 'Aggressive delivery tactics.'),
    ('Unicycle Clown', 'Honk honk! Delivery is here!'),
    ('Rickshaw Runner', 'Leg day is every day.'),
    ('Shopping Cart Hero', 'Downhill delivery specialist.'),
    ('Segway Tour', 'Tourists delivering packages accidentally.'),

    // Tier 2: Vehicles (11-20)
    ('Moped Gang', 'Loud and efficient.'),
    ('Pizza Scooter', 'Hot and fresh deliveries.'),
    ('Golf Cart', 'Leisurely but steady.'),
    ('Mail Truck', 'Neither rain nor snow...'),
    ('Ice Cream Van', 'Delivers packages and frozen treats.'),
    ('Rocket Pizza', 'Delivered hot, or it explodes.'),
    ('Monster Truck', 'Crushes traffic (and packages).'),
    ('Formula 1 Car', 'Pit stop delivery.'),
    ('Bullet Train', 'High-speed rail logistics.'),
    ('Cargo Plane', 'Flying warehouses.'),

    // Tier 3: Advanced Tech (21-30)
    ('Delivery Drone Swarm', 'The sky is dark with drones.'),
    ('Robot Courier', 'Beep boop. Package delivered.'),
    ('Hoverboarder', 'McFly style delivery.'),
    ('Jetpack Joyrider', 'Flying high, delivering fast.'),
    ('Hyperloop Pod', 'Vacuum tube velocity.'),
    ('Package Catapult', 'Yeet the package!'),
    ('Delivery Cannon', 'Precision is overrated.'),
    ('Railgun Launcher', 'Hypersonic package delivery.'),
    ('Orbital Drop Pod', 'Stand by for Titanfall.'),
    ('Teleporting Dog', 'Good boy appears instantly.'),

    // Tier 4: Sci-Fi (31-40)
    ('Cybernetic Runner', 'Enhanced legs for speed.'),
    ('Anti-Gravity Van', 'Roads? Where we are going we don\'t need roads.'),
    ('UFO', 'Abducting packages to their destination.'),
    ('Alien Mothership', 'Delivering entire neighborhoods.'),
    ('Portal Gun', 'Thinking with portals.'),
    ('Teleporter Station', 'Beam me up, package.'),
    ('Matter Replicator', 'Why deliver when you can copy?'),
    ('Nanobot Cloud', 'Assembling packages at destination.'),
    ('Time Traveler', 'Delivered yesterday.'),
    ('TARDIS', 'It\'s bigger on the inside.'),

    // Tier 5: Fantasy (41-50)
    ('Running Wizard', 'A wizard is never late.'),
    ('Magic Carpet', 'A whole new world of delivery.'),
    ('Broomstick Rider', 'Quidditch player side hustle.'),
    ('Griffin Rider', 'Majestic air freight.'),
    ('Dragon Express', 'Fire-proof packaging required.'),
    ('Phoenix', 'Reborn from the ashes of lost packages.'),
    ('Pegasus', 'Mythical delivery speeds.'),
    ('Giant Eagle', 'Fly, you fools!'),
    ('Telepathic Monk', 'Delivers packages with his mind.'),
    ('Genie', 'Your package is my command.'),

    // Tier 6: Cosmic (51-60)
    ('Moon Lander', 'One small step for a package.'),
    ('Mars Rover', 'Red planet logistics.'),
    ('Solar Sailer', 'Riding the solar wind.'),
    ('Asteroid Miner', 'Delivering space rocks.'),
    ('Comet Surfer', 'Icy delivery trails.'),
    ('Starship Enterprise', 'Boldly going where no package has gone.'),
    ('Dyson Sphere', 'Harnessing stars for postage.'),
    ('Black Hole Courier', 'Sucks the package to the customer.'),
    ('Wormhole Express', 'Shortcuts through space-time.'),
    ('Quasar Beam', 'Brightest delivery in the universe.'),

    // Tier 7: Abstract (61-70)
    ('Quantum Entanglement', 'Spooky action at a distance.'),
    ('Schrodinger\'s Cat', 'The package is both delivered and not.'),
    ('Dark Matter Flow', 'Invisible delivery forces.'),
    ('String Theory', 'Vibrating strings of delivery.'),
    ('Multiverse Skipper', 'Delivers to all parallel universes.'),
    ('Reality Bender', 'I reject your reality and substitute my delivery.'),
    ('Concept of Delivery', 'It just happens.'),
    ('Thought Transfer', 'You think it, you get it.'),
    ('Omnipresent Postman', 'He is everywhere, always.'),
    ('The Developer', 'Hardcoding the package into existence.'),

    // Tier 8: Absurd (71-80)
    ('Hamster Wheel Power', 'Infinite rodent energy.'),
    ('Cat Video Viral', 'Delivered by internet fame.'),
    ('Meme Lord', 'Much delivery. Very wow.'),
    ('Glitch in the Matrix', 'Package clipped through the wall.'),
    ('Infinite Monkey', 'Eventually wrote the correct address.'),
    ('Rubber Duck Debugger', 'Explains the route perfectly.'),
    ('Spaghetti Code', 'Tangled but functional delivery.'),
    ('Blue Screen of Death', 'Restarting delivery...'),
    ('404 Courier', 'Package not found (just kidding).'),
    ('Stack Overflow', 'Copy-pasting deliveries.'),

    // Tier 9: Divine (81-90)
    ('Angel of Logistics', 'Heavenly sorting.'),
    ('God of Speed', 'Hermes himself.'),
    ('Titan of Industry', 'Shouldering the world\'s packages.'),
    ('Cosmic Turtle', 'Carrying the delivery universe.'),
    ('Galactic Overlord', 'Demands successful delivery.'),
    ('Universal Constant', 'Delivery is inevitable.'),
    ('Big Bang', 'Explosive distribution.'),
    ('Entropy Reverser', 'Ordering the chaos.'),
    ('Time Lord', 'Master of when.'),
    ('Existence Itself', 'I am the delivery.'),

    // Tier 10: The End (91-100)
    ('Singularity', 'Infinite density of packages.'),
    ('Event Horizon', 'Point of no return delivery.'),
    ('Vacuum Decay', 'Rewriting physics for postage.'),
    ('False Vacuum', 'Stable until delivered.'),
    ('Heat Death', 'The final delivery.'),
    ('The Simulation', 'It was all just code.'),
    ('The Player', 'You are the ultimate delivery unit.'),
    ('Game Over', 'Thanks for playing!'),
    ('New Game+', 'Starting over with packages.'),
    ('Super Crazy Delivery Inc.', 'The company itself.'),
  ];

  List<DeliveryUnit> units = [];

  // Base values to start the exponential curve
  double currentCost = 10;
  double currentIncome = 1;

  for (int i = 0; i < unitData.length; i++) {
    final data = unitData[i];

    // Create ID from name (lowercase, underscores)
    String id = data.$1.toLowerCase().replaceAll(' ', '_').replaceAll('\'', '');

    // Manual overrides for legacy IDs to prevent save breakage if possible
    // (Though user did a reset recently, better safe or just migrate)
    // Actually, user wants a massive expansion. Let's stick to consistent IDs.
    // If we change IDs, old saves might lose progress on specific units.
    // Let's try to map some old ones if they match names.
    if (data.$1 == 'Grandma on Skates') id = 'grandma';
    if (data.$1 == 'Rusty Drone') id = 'drone';
    if (data.$1 == 'Rocket Pizza') id = 'rocket_pizza';
    // ... others might change, but that's acceptable for a "Massive Expansion" update.

    units.add(
      DeliveryUnit(
        id: id,
        name: data.$1,
        description: data.$2,
        baseCost: currentCost,
        baseIncome: currentIncome,
      ),
    );

    // Exponential Growth Factors
    // Cost grows by ~1.6x per unit
    // Income grows by ~1.5x per unit
    // This ensures later units are always better but harder to get
    currentCost *= 1.6;
    currentIncome *= 1.5;

    // Every 10 units (Tier jump), give a bigger jump
    if ((i + 1) % 10 == 0) {
      currentCost *= 5;
      currentIncome *= 4;
    }
  }

  return units;
}
