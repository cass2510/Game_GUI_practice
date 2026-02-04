import 'dart:math';
import 'item.dart';

class Shop {
  List<Item> allAvailableItems = [];
  List<Item> currentShopItems = [];
  Map<String, int> itemPrices = {};
  Random random = Random();

  static const int DISPLAY_COUNT = 4;

  Shop() {
    _initializeAllItems();
  }

  void _addWeapon(
    String name,
    String description,
    int attack,
    int price,
    ItemRarity rarity,
  ) {
    Item weapon = Item.weapon(
      name: name,
      description: description,
      attack: attack,
      price: price,
      quantity: 1,
      rarity: rarity,
    );
    allAvailableItems.add(weapon);
    itemPrices[name] = price;
  }

  void _addArmor(
    String name,
    String description,
    int defense,
    int price,
    ItemRarity rarity,
  ) {
    Item armor = Item.armor(
      name: name,
      description: description,
      defense: defense,
      price: price,
      quantity: 1,
      rarity: rarity,
    );
    allAvailableItems.add(armor);
    itemPrices[name] = price;
  }

  void _addPotion(
    String name,
    String description,
    int hp,
    int price,
    ItemRarity rarity,
  ) {
    Item potion = Item.potion(
      name: name,
      description: description,
      hp: hp,
      price: price,
      quantity: 1,
      rarity: rarity,
    );
    allAvailableItems.add(potion);
    itemPrices[name] = price;
  }

  void _initializeAllItems() {
    _addWeapon('목검', '목재로 만든 기본 검', 1, 100, ItemRarity.common);
    _addWeapon('철검', '튼튼한 철로 만든 검', 3, 300, ItemRarity.common);
    _addArmor('천옷', '일반적인 천으로 만든 옷', 1, 100, ItemRarity.common);
    _addArmor('가죽옷', '가죽으로 만든 방어구', 2, 250, ItemRarity.common);
    _addPotion('작은 물약', '체력 30 회복', 30, 100, ItemRarity.common);
    _addPotion('빨간 물약', '체력 50 회복', 50, 150, ItemRarity.common);

    _addWeapon('철강검', '철강으로 만든 강력한 검', 5, 600, ItemRarity.uncommon);
    _addWeapon('베르세르크 검', '광전사의 검', 6, 700, ItemRarity.uncommon);
    _addArmor('철갑옷', '철로 만든 튼튼한 갑옷', 4, 550, ItemRarity.uncommon);
    _addArmor('강화 가죽옷', '강화된 가죽 방어구', 3, 400, ItemRarity.uncommon);
    _addPotion('파란 물약', '체력 80 회복', 80, 250, ItemRarity.uncommon);
    _addPotion('마나 물약', '마나 30 회복', 30, 200, ItemRarity.uncommon);

    _addWeapon('강철검', '매우 강한 강철로 만든 검', 8, 1200, ItemRarity.rare);
    _addWeapon('미스릴 검', '신비로운 금속 미스릴로 만든 검', 9, 1400, ItemRarity.rare);
    _addWeapon('라이트닝 소드', '번개 속성의 검', 10, 1600, ItemRarity.rare);
    _addArmor('강철갑옷', '강철로 만든 견고한 갑옷', 7, 1100, ItemRarity.rare);
    _addArmor('미스릴 갑옷', '미스릴로 만든 신비로운 갑옷', 8, 1300, ItemRarity.rare);
    _addArmor('드래곤 가죽옷', '드래곤 가죽으로 만든 방어구', 9, 1500, ItemRarity.rare);
    _addPotion('황금 물약', '체력 150 회복', 150, 500, ItemRarity.rare);
    _addPotion('생명의 물약', '최대 체력의 50% 회복', 999, 800, ItemRarity.rare);

    _addWeapon('용의 검', '고대 용으로부터 만든 전설의 검', 12, 2500, ItemRarity.epic);
    _addWeapon('오디움', '어둠의 검', 13, 2800, ItemRarity.epic);
    _addWeapon('라이트닝 플러스', '강화된 번개 검', 14, 3100, ItemRarity.epic);
    _addArmor('용의 갑옷', '고대 용 가죽 갑옷', 11, 2300, ItemRarity.epic);
    _addArmor('신의 갑옷', '신의 축복을 받은 갑옷', 13, 2900, ItemRarity.epic);
    _addArmor('어둠의 망토', '어둠 에너지로 강화된 망토', 12, 2600, ItemRarity.epic);
    _addPotion('봉인된 물약', '체력 300 회복', 300, 1500, ItemRarity.epic);
    _addPotion('신비한 엘릭서', '최대 체력 영구 +10', 999, 2000, ItemRarity.epic);

    _addWeapon('엑스칼리버', '전설 중의 전설 검', 20, 5000, ItemRarity.legendary);
    _addWeapon('무한의 검', '무한한 힘의 검', 18, 4500, ItemRarity.legendary);
    _addWeapon('신의 번개', '신의 분노를 담은 번개 검', 19, 4800, ItemRarity.legendary);
    _addArmor('신의 갑옷 +', '신이 강화한 완벽한 갑옷', 17, 4200, ItemRarity.legendary);
    _addArmor('불멸의 보호', '죽음을 거스르는 갑옷', 18, 4600, ItemRarity.legendary);
    _addArmor('차원의 망토', '차원을 초월한 망토', 19, 4900, ItemRarity.legendary);
    _addPotion('신약', '모든 상태 회복 및 강화', 9999, 5000, ItemRarity.legendary);
    _addPotion('영원의 물약', '체력 및 능력 대폭 상승', 500, 3000, ItemRarity.legendary);
  }

  List<Item> _getItemsForLevel(int characterLevel) {
    List<Item> availableItems = [];

    for (Item item in allAvailableItems) {
      ItemRarity rarity = item.rarity;
      bool shouldDisplay = false;

      if (characterLevel <= 3 && (rarity == ItemRarity.common)) {
        shouldDisplay = true;
      } else if (characterLevel >= 3 &&
          characterLevel <= 6 &&
          (rarity == ItemRarity.common || rarity == ItemRarity.uncommon)) {
        shouldDisplay = true;
      } else if (characterLevel >= 6 &&
          characterLevel <= 10 &&
          (rarity == ItemRarity.uncommon || rarity == ItemRarity.rare)) {
        shouldDisplay = true;
      } else if (characterLevel >= 10 &&
          characterLevel <= 15 &&
          (rarity == ItemRarity.rare || rarity == ItemRarity.legendary)) {
        shouldDisplay = true;
      } else if (characterLevel >= 15) {
        shouldDisplay = true;
      }

      if (shouldDisplay) {
        availableItems.add(item);
      }
    }

    return availableItems;
  }

  void refreshShopItems(int characterLevel) {
    currentShopItems.clear();

    List<Item> availableItems = _getItemsForLevel(characterLevel);

    if (availableItems.isEmpty) {
      return;
    }

    List<Item> shuffled = List.from(availableItems);
    shuffled.shuffle(random);

    for (int i = 0; i < DISPLAY_COUNT && i < shuffled.length; i++) {
      currentShopItems.add(shuffled[i]);
    }
  }

  void replaceShopItemAt(int index, int characterLevel) {
    if (index < 0 || index >= currentShopItems.length) {
      return;
    }

    List<Item> available = _getItemsForLevel(characterLevel);
    if (available.isEmpty) {
      return;
    }

    Set<String> currentNames = currentShopItems
        .map((item) => item.name)
        .toSet();
    List<Item> candidates = available
        .where((item) => !currentNames.contains(item.name))
        .toList();

    if (candidates.isEmpty) {
      candidates = available;
    }

    Item newItem = candidates[random.nextInt(candidates.length)];
    currentShopItems[index] = newItem;
  }

  void displayShopItems(int playerGold, int playerLevel) {
    print('\n[상점 상품] - Lv.${playerLevel}');
    print('현재 보유 골드 :${playerGold} 골드');
    print('');

    if (currentShopItems.isEmpty) {
      print('판매 중인 상품이 없습니다');
      return;
    }

    for (int i = 0; i < currentShopItems.length; i++) {
      Item item = currentShopItems[i];
      int price = itemPrices[item.name] ?? 0;

      String info = '';
      String rarity = _getRarityEmoji(item.rarity);

      if (item.type == ItemType.POTION) {
        info = '(체력 + ${item.hpRestore})';
      } else if (item.type == ItemType.WEAPON) {
        info = '(공격력 + ${item.attackBonus})';
      } else if (item.type == ItemType.ARMOR) {
        info = '(방어력 + ${item.defenseBonus})';
      }

      print('${i + 1}. ${rarity} ${item.name} $info - $price골드');
    }
    print('');
  }

  String _getRarityEmoji(ItemRarity rarity) {
    switch (rarity) {
      case ItemRarity.common:
        return '⚪';
      case ItemRarity.uncommon:
        return '🟢';
      case ItemRarity.rare:
        return '🔷';
      case ItemRarity.epic:
        return '💜';
      case ItemRarity.legendary:
        return '🌟';
    }
  }

  Item? getItemAt(int index) {
    if (index < 0 || index >= currentShopItems.length) {
      return null;
    }
    return currentShopItems[index];
  }

  int? getPriceOf(String itemName) {
    return itemPrices[itemName];
  }
}
