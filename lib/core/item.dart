enum ItemType { POTION, WEAPON, ARMOR, MATERIAL }

enum ItemRarity { common, uncommon, rare, epic, legendary }

class Item {
  String name;
  String description;
  ItemType type;
  ItemRarity rarity;
  int price;
  int quantity;
  int? hpRestore;
  int? attackBonus;
  int? defenseBonus;

  Item.potion({
    required this.name,
    required this.description,
    required int hp,
    required this.price,
    required this.rarity,
    this.quantity = 1,
  }) : type = ItemType.POTION,
       hpRestore = hp,
       attackBonus = null,
       defenseBonus = null;

  Item.weapon({
    required this.name,
    required this.description,
    required int attack,
    required this.price,
    required this.rarity,
    this.quantity = 1,
  }) : type = ItemType.WEAPON,
       hpRestore = null,
       attackBonus = attack,
       defenseBonus = null;

  Item.armor({
    required this.name,
    required this.description,
    required int defense,
    required this.price,
    required this.rarity,
    this.quantity = 1,
  }) : type = ItemType.ARMOR,
       hpRestore = null,
       attackBonus = null,
       defenseBonus = defense;

  Item.material({
    required this.name,
    required this.description,
    required this.price,
    required this.rarity,
    this.quantity = 1,
  }) : type = ItemType.MATERIAL,
       hpRestore = null,
       attackBonus = null,
       defenseBonus = null;

  String getShortInfo() {
    return '$name x $quantity';
  }
}
