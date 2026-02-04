import 'item.dart';

class Inventory {
  List<Item> items = [];
  int maxSlots = 20;
  int totalQuantity = 0;

  bool addItem(Item newItem) {
    try {
      final existing = items.firstWhere((i) => i.name == newItem.name);
      existing.quantity += newItem.quantity;
      totalQuantity += newItem.quantity;
      print('${newItem.name}을(를) ${newItem.quantity}개 획득!');
      return true;
    } catch (_) {
      if (isFull()) {
        print('인벤토리 가득 참!');
        return false;
      }
      items.add(newItem);
      totalQuantity += newItem.quantity;
      print('${newItem.name}을(를) 획득!');
      return true;
    }
  }

  Item? getItemAt(int index) {
    if (index < 0 || index >= items.length) {
      return null;
    }
    return items[index];
  }

  bool removeItem(String itemName, {int amount = 1}) {
    try {
      final item = items.firstWhere((i) => i.name == itemName);
      if (amount > item.quantity) {
        print('${itemName}이 부족합니다!');
        return false;
      }
      item.quantity -= amount;
      totalQuantity -= amount;
      if (item.quantity <= 0) {
        items.remove(item);
      }
      return true;
    } catch (_) {
      print('아이템을 찾을 수 없습니다!');
      return false;
    }
  }

  Item? findItem(String itemName) {
    try {
      return items.firstWhere((i) => i.name == itemName);
    } catch (_) {
      return null;
    }
  }

  bool isFull() {
    return items.length >= maxSlots;
  }

  void displayInventory() {
    items.removeWhere((item) => item.quantity <= 0);

    print('\n인벤토리 (${items.length}/$maxSlots):');
    if (items.isEmpty) {
      print('인벤토리가 비었습니다');
    } else {
      for (int i = 0; i < items.length; i++) {
        print(' ${i + 1}. ${items[i].getShortInfo()}');
      }
    }
    print('');
  }

  List<Item> findItemByType(ItemType type) {
    return items.where((item) => item.type == type).toList();
  }

  String getSummary() => '인벤토리: ${items.length}/$maxSlots (총 $totalQuantity 개)';
}
