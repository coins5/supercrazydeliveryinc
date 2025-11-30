import '../models/manager.dart';
import '../models/delivery_unit.dart';

List<Manager> getDefaultManagers(List<DeliveryUnit> units) {
  List<Manager> managers = [];

  // 1. Special Managers (Auto-Click, Discount)
  managers.addAll([
    Manager(
      id: 'manager_click_1',
      name: 'Clicky Pete',
      description: 'Auto-clicks 1 time per second.',
      cost: 500,
      type: ManagerType.autoClick,
      value: 1.0,
    ),
    Manager(
      id: 'manager_discount_1',
      name: 'Coupon Carl',
      description: 'Reduces all unit costs by 10%.',
      cost: 10000,
      type: ManagerType.discount,
      value: 0.10,
    ),
    Manager(
      id: 'manager_click_2',
      name: 'Tapping Tom',
      description: 'Auto-clicks 5 times per second.',
      cost: 50000,
      type: ManagerType.autoClick,
      value: 5.0,
    ),
    Manager(
      id: 'manager_discount_2',
      name: 'Bargain Betty',
      description: 'Reduces all unit costs by another 10%.',
      cost: 5000000,
      type: ManagerType.discount,
      value: 0.10,
    ),
    Manager(
      id: 'manager_click_3',
      name: 'Hyper Hans',
      description: 'Auto-clicks 20 times per second.',
      cost: 100000000,
      type: ManagerType.autoClick,
      value: 20.0,
    ),
  ]);

  // 2. Unit Managers (One for each unit)
  for (var unit in units) {
    // Manager cost is 10x the unit base cost (approx)
    // To make it a mid-game goal for that unit tier
    double cost = unit.baseCost * 10;

    // Ensure unique ID
    String id = 'manager_${unit.id}';

    // Creative naming based on unit name?
    // Let's just prefix "Manager of" or "Boss" for now to be safe and scalable.
    // Or use a helper for variety if we want.
    String name = "Boss ${unit.name}";

    managers.add(
      Manager(
        id: id,
        name: name,
        description: 'Doubles income of ${unit.name}.',
        cost: cost,
        type: ManagerType.unitBoost,
        value: 2.0,
        targetUnitId: unit.id,
      ),
    );
  }

  // Sort by cost so they appear in a logical order
  managers.sort((a, b) => a.cost.compareTo(b.cost));

  return managers;
}
