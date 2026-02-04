import 'inventory.dart';
import 'item.dart';

class Character {
  String name;
  int level;
  int exp;
  int expToLevelUp;
  int hp;
  int maxHp;
  int attack;
  int defense;
  int gold;
  Inventory inventory = Inventory();
  Item? equippedWeapon;
  Item? equippedArmor;

  Character({
    required this.name,
    this.level = 1,
    this.exp = 0,
    this.expToLevelUp = 100,
    this.hp = 100,
    this.maxHp = 100,
    this.attack = 10,
    this.defense = 5,
    this.gold = 0,
  });

  int get totalAttack => attack + (equippedWeapon?.attackBonus ?? 0);
  int get totalDefense => defense + (equippedArmor?.defenseBonus ?? 0);

  void gainExp(int amount) {
    exp += amount;
    print('$amount 경험치를 획득했습니다!');

    while (exp >= expToLevelUp) {
      levelUp();
    }
  }

  void levelUp() {
    exp -= expToLevelUp;
    level++;
    maxHp += 20;
    hp = maxHp;
    attack += 5;
    defense += 2;
    expToLevelUp = (expToLevelUp * 1.2).toInt();

    print('레벨업! 현재 레벨: $level');
    print('HP +20 (최대 HP $maxHp)');
    print('공격력 +5 (현재 공격력 $attack)');
    print('방어력 +2 (현재 방어력 $defense)');
  }

  void takeDamage(int damage) {
    int actualDamage = (damage - defense ~/ 2).clamp(1, damage);
    hp -= actualDamage;
    if (hp < 0) hp = 0;
    print('$actualDamage의 피해를 입었습니다');
  }

  void heal(int amount) {
    int beforeHp = hp;
    hp = (hp + amount).clamp(0, maxHp);
    int actualHealing = hp - beforeHp;
    print('$actualHealing만큼 체력을 회복했습니다! (현재 HP $hp/$maxHp)');
  }

  void usePotion(String potionName) {
    Item? potion = inventory.findItem(potionName);

    if (potion == null) {
      print('$potionName을 찾을 수 없습니다');
      return;
    }

    if (potion.type != ItemType.POTION) {
      print('이것은 물약이 아닙니다');
      return;
    }

    if (potion.hpRestore == null) {
      print('추후 구현');
      return;
    }

    if (hp == maxHp) {
      print('\n더 이상 회복할 수 없습니다 (현재 체력: $hp / $maxHp)');
      return;
    }

    heal(potion.hpRestore!);
    inventory.removeItem(potionName, amount: 1);
    print('$potionName을 사용했습니다 (현재 체력 : $hp / $maxHp)');
  }

  void equipWeapon(Item weapon) {
    if (weapon.type != ItemType.WEAPON) {
      print('이것은 무기가 아닙니다');
      return;
    }

    if (weapon.attackBonus == null) {
      print('이 무기는 아무런 효과가 없습니다');
      return;
    }

    if (equippedWeapon != null) {
      equippedWeapon!.quantity = 1;
      inventory.addItem(equippedWeapon!);
      print('${equippedWeapon!.name}을(를) 인벤토리에 넣었습니다');
    }

    equippedWeapon = weapon;
    inventory.removeItem(weapon.name, amount: 1);
    print('${weapon.name}을(를) 장착했습니다 (추가 공격력 +${weapon.attackBonus})');
  }

  void unequipWeapon() {
    if (equippedWeapon == null) {
      print('장착 중인 무기가 없습니다');
      return;
    }

    if (inventory.isFull()) {
      print('인벤토리 가득 참!');
      return;
    }

    Item weapon = equippedWeapon!;
    inventory.addItem(weapon);
    equippedWeapon = null;
    print('${weapon.name}을(를) 인벤토리에 넣었습니다');
    print('현재 공격력 : ${totalAttack}');
  }

  void equipArmor(Item armor) {
    if (armor.type != ItemType.ARMOR) {
      print('이것은 방어구가 아닙니다');
      return;
    }

    if (armor.defenseBonus == null) {
      print('이 방어구는 아무런 효과가 없습니다');
      return;
    }

    if (equippedArmor != null) {
      equippedArmor!.quantity = 1;
      inventory.addItem(equippedArmor!);
      print('${equippedArmor!.name}을(를) 인벤토리에 넣었습니다');
    }

    equippedArmor = armor;
    inventory.removeItem(armor.name, amount: 1);
    print('${armor.name}을(를) 장착했습니다 (추가 방어력 +${armor.defenseBonus})');
  }

  void unequipArmor() {
    if (equippedArmor == null) {
      print('장착 중인 방어구가 없습니다');
      return;
    }

    if (inventory.isFull()) {
      print('인벤토리 가득 참!');
      return;
    }

    Item armor = equippedArmor!;
    inventory.addItem(armor);
    equippedArmor = null;
    print('${armor.name}을(를) 인벤토리에 넣었습니다');
    print('현재 방어력 : ${totalDefense}');
  }

  void displayStatus() {
    print('캐릭터 정보');
    print('이름 : $name');
    print('레벨 : $level');
    print('HP : $hp/$maxHp');
    print('공격력 : $attack');
    print('방어력 : $defense');
    print('보유 골드 : $gold');
    print(inventory.getSummary());
  }

  bool isAlive() {
    return hp > 0;
  }

  void gainGold(int amount) {
    gold += amount;
    print('$amount 골드 획득!');
  }
}
