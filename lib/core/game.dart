import 'dart:io';
import 'dart:math';
import 'character.dart';
import 'monster.dart';
import 'item.dart';
import 'shop.dart';

Shop shop = Shop();

class Game {
  Character character;
  Random random = Random();
  bool isRunning = true;

  Game({required this.character});

  void start() {
    print('\n캐릭터 성장 RPG 시작!');
    print('캐릭터 : ${character.name}');
    character.displayStatus();
    _mainMenu();
  }

  void _mainMenu() {
    while (isRunning) {
      print('\n[메인 메뉴]');
      print('1. 몬스터 사냥');
      print('2. 캐릭터 상태 확인');
      print('3. 인벤토리');
      print('4. 상점');
      print('5. 게임 종료');
      print('선택 :');

      String? input = stdin.readLineSync();

      switch (input) {
        case '1':
          _battle();
          break;
        case '2':
          character.displayStatus();
          break;
        case '3':
          _inventoryMenu();
          break;
        case '4':
          _shopMenu();
          break;
        case '5':
          _endGame();
          break;
        default:
          print('잘못된 입력입니다.');
      }
    }
  }

  void _itemActionMenu(Item selectedItem) {
    while (true) {
      print('\n[${selectedItem.name}]');
      print('설명 : ${selectedItem.description}');

      if (selectedItem.type == ItemType.POTION) {
        print('1. 사용하기');
        print('2. 버리기');
        print('3. 취소');
      } else if (selectedItem.type == ItemType.WEAPON) {
        if (character.equippedWeapon != null) {
          print(
            '1. ${character.equippedWeapon!.name}을(를) ${selectedItem.name}으로 교체하기',
          );
          print('2. 버리기');
          print('3. 취소');
        } else {
          print('1. ${selectedItem.name} 장착하기');
          print('2. 버리기');
          print('3. 취소');
        }
      } else if (selectedItem.type == ItemType.ARMOR) {
        if (character.equippedArmor != null) {
          print(
            '1. ${character.equippedArmor!.name}을(를) ${selectedItem.name}으로 교체하기',
          );
          print('2. 버리기');
          print('3. 취소');
        } else {
          print('1. ${selectedItem.name} 장착하기');
          print('2. 버리기');
          print('3. 취소');
        }
      } else {
        print('1. 버리기');
        print('2. 취소');
      }

      print('선택 :');
      String? input = stdin.readLineSync();

      if (selectedItem.type == ItemType.POTION) {
        switch (input) {
          case '1':
            character.usePotion(selectedItem.name);
            return;
          case '2':
            character.inventory.removeItem(selectedItem.name, amount: 1);
            print('\n${selectedItem.name} 1개를 버렸습니다');
            return;
          case '3':
            return;
          default:
            print('잘못된 선택입니다');
        }
      } else if (selectedItem.type == ItemType.WEAPON) {
        switch (input) {
          case '1':
            character.equipWeapon(selectedItem);
            return;
          case '2':
            character.inventory.removeItem(selectedItem.name, amount: 1);
            print('\n${selectedItem.name} 1개를 버렸습니다');
            return;
          case '3':
            return;
          default:
            print('잘못된 선택입니다');
        }
      } else if (selectedItem.type == ItemType.ARMOR) {
        switch (input) {
          case '1':
            character.equipArmor(selectedItem);
            return;
          case '2':
            character.inventory.removeItem(selectedItem.name, amount: 1);
            print('\n${selectedItem.name} 1개를 버렸습니다');
            return;
          case '3':
            return;
          default:
            print('잘못된 선택입니다');
        }
      } else {
        switch (input) {
          case '1':
            character.inventory.removeItem(selectedItem.name, amount: 1);
            print('\n${selectedItem.name} 1개를 버렸습니다');
            return;
          case '2':
            return;
          default:
            print('잘못된 선택입니다');
        }
      }
    }
  }

  void _inventoryMenu() {
    while (true) {
      character.inventory.displayInventory();

      print('아이템을 선택하세요 (뒤로가기: 0):');
      String? input = stdin.readLineSync();

      if (input == null || input.isEmpty) continue;

      int choice = int.tryParse(input) ?? -1;

      if (choice == 0) {
        break;
      }

      Item? selected = character.inventory.getItemAt(choice - 1);

      if (selected == null) {
        print('잘못된 선택입니다');
        continue;
      }

      _itemActionMenu(selected);
    }
  }

  void _shopMenu() {
    while (true) {
      print('\n[상점]');
      print('1. 아이템 구매하기');
      print('2. 아이템 판매하기');
      print('3. 뒤로가기');
      print('선택 : ');

      String? input = stdin.readLineSync();

      switch (input) {
        case '1':
          _buyMenu();
          break;
        case '2':
          _sellMenu();
          break;
        case '3':
          return;
        default:
          print('잘못된 입력입니다');
          return;
      }
    }
  }

  void _buyMenu() {
    shop.displayShopItems(character.gold, character.level);
    print('아이템을 선택하세요 (뒤로가기 : 0) :');
    String? input = stdin.readLineSync();

    if (input == null) {
      print('잘못된 입력입니다');
      return;
    }

    int choice = int.tryParse(input) ?? -1;

    if (choice == 0) {
      return;
    }

    int index = choice - 1;
    Item? selectedItem = shop.getItemAt(choice - 1);

    if (selectedItem == null) {
      print('잘못된 선택입니다');
      return;
    }

    _processBuy(selectedItem, index);
  }

  void _processBuy(Item selectedItem, int shopIndex) {
    int? price = shop.getPriceOf(selectedItem.name);

    if (price == null) {
      print('가격 정보를 찾을 수 없습니다');
      return;
    }

    if (character.inventory.isFull()) {
      print('인벤토리 가득 참!');
      return;
    }

    if (character.gold < price) {
      print('보유 골드가 부족합니다');
      print('현재 보유 골드 : ${character.gold}');
      return;
    }

    print('\n${selectedItem.name}을(를) 구매하시겠습니까?');
    print('1. 구매');
    print('2. 취소');
    print('선택 :');

    String? confirm = stdin.readLineSync();

    if (confirm != '1') {
      print('구매 취소');
      return;
    }

    character.gold -= price;

    Item newItem;

    switch (selectedItem.type) {
      case ItemType.WEAPON:
        newItem = Item.weapon(
          name: selectedItem.name,
          description: selectedItem.description,
          attack: selectedItem.attackBonus ?? 0,
          price: selectedItem.price,
          rarity: selectedItem.rarity,
        );
        break;
      case ItemType.ARMOR:
        newItem = Item.armor(
          name: selectedItem.name,
          description: selectedItem.description,
          defense: selectedItem.defenseBonus ?? 0,
          price: selectedItem.price,
          rarity: selectedItem.rarity,
        );
        break;
      case ItemType.POTION:
        newItem = Item.potion(
          name: selectedItem.name,
          description: selectedItem.description,
          hp: selectedItem.hpRestore ?? 0,
          price: selectedItem.price,
          rarity: selectedItem.rarity,
        );
        break;
      case ItemType.MATERIAL:
        newItem = Item.material(
          name: selectedItem.name,
          description: selectedItem.description,
          price: selectedItem.price,
          rarity: selectedItem.rarity,
        );
        break;
    }
    character.inventory.addItem(newItem);

    print('\n${selectedItem.name}을(를) 구매했습니다');
    print('남은 골드: ${character.gold}\n');

    shop.replaceShopItemAt(shopIndex, character.level);
  }

  void _sellMenu() {
    while (true) {
      character.inventory.displayInventory();
      print('판매할 아이템을 선택하세요 (뒤로가기 0) :');

      String? input = stdin.readLineSync();

      if (input == null || input.isEmpty) continue;

      int choice = int.tryParse(input) ?? -1;

      if (choice == 0) {
        return;
      }

      Item? selectedItem = character.inventory.getItemAt(choice - 1);

      if (selectedItem == null) {
        print('잘못된 선택입니다');
        continue;
      }

      _processSell(selectedItem);
    }
  }

  void _processSell(Item selectedItem) {
    int? shopPrice = shop.getPriceOf(selectedItem.name);

    if (shopPrice == null) {
      print('이 상점에서 판매할 수 없는 아이템입니다');
      return;
    }

    int sellPrice = (shopPrice * 0.8).toInt();

    if (selectedItem == character.equippedWeapon ||
        selectedItem == character.equippedArmor) {
      print('이 아이템은 현재 착용중입니다');
      print('착용 해제 후 판매를 시도하세요');
      return;
    }

    print('\n[${selectedItem.name}] : 판매가 $sellPrice 골드');
    print('');
    print('판매하시겠습니까?');
    print('1. 판매');
    print('2. 취소');
    print('선택 : ');

    String? confirm = stdin.readLineSync();

    if (confirm != '1') {
      print('취소되었습니다');
      return;
    }

    bool removed = character.inventory.removeItem(selectedItem.name, amount: 1);

    if (!removed) {
      print('아이템을 찾을 수 없거나 수량이 부족합니다.');
      return;
    }

    character.gold += sellPrice;

    print('${selectedItem.name}을(를) $sellPrice 골드에 판매했습니다');
    print('현재 보유 골드 : ${character.gold}');
  }

  void _battle() {
    Monster monster = _spawnMonster();

    print('\n ${monster.name}이(가) 나타났다!');
    print('${monster.name} - Lv.${monster.level} (HP : ${monster.hp})');

    while (character.isAlive() && monster.isAlive()) {
      print('\n[전투 메뉴]');
      print('1. 공격');
      print('2. 회복 (HP 20 회복)');
      print('3. 도망');
      print('선택 :');

      String? input = stdin.readLineSync();

      switch (input) {
        case '1':
          _playerAttack(monster);
          break;
        case '2':
          character.heal(20);
          break;
        case '3':
          print('전투에서 도망쳤습니다');
          return;
        default:
          print('잘못된 입력입니다.');
          continue;
      }

      if (monster.isAlive()) {
        _monsterAttack(monster);
      }
    }

    if (character.isAlive()) {
      _winBattle(monster);
    } else {
      _loseBattle();
    }
  }

  void _playerAttack(Monster monster) {
    int damage = (character.totalAttack * (0.8 + random.nextDouble() * 0.4))
        .toInt();

    print('${character.name}의 공격! ${monster.name}에게 $damage의 피해를 입혔습니다.');
    monster.takeDamage(damage);

    print('${monster.name}의 남은 HP : ${monster.hp}');
  }

  void _monsterAttack(Monster monster) {
    int damage = (monster.attack * (0.8 + random.nextDouble() * 0.4)).toInt();

    print('${monster.name}의 공격! $damage의 피해를 입었습니다');
    character.takeDamage(damage);

    print('${character.name} : ${character.hp} / ${character.maxHp}');
  }

  void _winBattle(Monster monster) {
    print('\n ${monster.name}을 쓰러뜨렸습니다!');
    character.gainExp(monster.expReward);
    character.gainGold(monster.goldReward);
    shop.refreshShopItems(character.level);
  }

  void _loseBattle() {
    print('\n세상을 구하지 못했습니다...');
    character.hp = character.maxHp;
    int lostGold = (character.gold * 0.1).toInt();
    character.gold -= lostGold;
    shop.refreshShopItems(character.level);
    print('$lostGold 골드를 잃었습니다...');
  }

  _spawnMonster() {
    List<String> monsterNames = ['고블린', '늑대', '오크', '스켈레톤', '드래곤'];
    String name = monsterNames[random.nextInt(monsterNames.length)];

    int monsterLevel = (character.level + random.nextInt(5) - 2).clamp(1, 999);

    int baseHp = 30 + (monsterLevel * 10);
    int attack = 8 + (monsterLevel * 2);
    int defense = 2 + (monsterLevel);
    int expReward = 50 * monsterLevel;
    int goldReward = 10 * monsterLevel;

    return Monster(
      name: name,
      level: monsterLevel,
      hp: baseHp,
      maxHp: baseHp,
      attack: attack,
      defense: defense,
      expReward: expReward,
      goldReward: goldReward,
    );
  }

  void _endGame() {
    print('\n게임을 종료합니다...');
    print('최종 기록');
    character.displayStatus();
    isRunning = false;
  }
}
