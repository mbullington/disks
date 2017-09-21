part of disks.lib;

final num tileHeight = 130;

class GameColor {
  static GameColor RED = new GameColor._("red");
  static GameColor BLUE = new GameColor._("blue");

  final String cssName;

  GameColor._(this.cssName);

  GameColor get opposite {
    if (cssName == "red") {
      return GameColor.BLUE;
    }

    return GameColor.RED;
  }
}

class Position {
  final num x;
  final num y;

  const Position(this.x, this.y);
}