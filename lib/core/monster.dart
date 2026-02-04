class Monster {
  String name;
  int level;
  int hp;
  int maxHp;
  int attack;
  int defense;
  int expReward;
  int goldReward;

  Monster({
    required this.name,
    required this.level,
    required this.hp,
    required this.maxHp,
    required this.attack,
    required this.defense,
    required this.expReward,
    required this.goldReward,
  });

  void takeDamage(int damage) {
    int actualDamage = (damage - defense ~/ 2).clamp(1, damage);
    hp -= actualDamage;
    if (hp < 0) hp = 0;
  }

  bool isAlive() {
    return hp > 0;
  }
}
