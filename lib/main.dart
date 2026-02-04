import 'core/character.dart';
import 'core/game.dart';

void main() {
  Character myCharacter = Character(name: '용사');

  Game game = Game(character: myCharacter);

  game.start();
}
