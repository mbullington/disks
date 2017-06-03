part of disks.lib;

typedef void GameMapCallback(Disk disk);

class BackgroundTile {
  final int index;
  DivElement element;

  BackgroundTile(this.index) {
    element = new DivElement()
      ..classes.addAll(["tile", "t$index"]);
  }

  void highlight(GameColor color) {
    element.classes.add("highlight-${color.cssName}");
  }

  void unhighlight() {
    element.classes.removeWhere((c) => c.startsWith("highlight-"));
  }
}

class GameMap {
  static int MAP_SIZE = 16;

  final DivElement background;

  List<List<BackgroundTile>> _tileMap;  
  List<List<Disk>> _gameMap;

  GameMap(this.background) {
    int blueIndex = 0;
    int redIndex = 3;

    _tileMap = [];
    _gameMap = [];

    for (int row = 0; row < 4; row++) {
      _tileMap.add([]);

      DivElement rowEl = new DivElement()..classes.add("row");
      background.append(rowEl);

      for (int column = 0; column < 4; column++) {
        BackgroundTile tile = new BackgroundTile(column + 1);
        _tileMap[row].add(tile);
        
        rowEl.append(tile.element);
      }

      _gameMap.add([null, null, null, null]);

      _gameMap[row][blueIndex] = new Disk(GameColor.BLUE)..updatePosition(new Position(blueIndex, row));
      _gameMap[row][redIndex] = new Disk(GameColor.RED)..updatePosition(new Position(redIndex, row));

      blueIndex++;
      redIndex--;
    }
  }

  void forEach(GameMapCallback callback) {
    for (int i = 0; i < MAP_SIZE; i++) {
      callback(_gameMap[(i / 4).floor()][i % 4]);
    }
  }

  void updatePosition(Disk disk, Position newPos) {
    _gameMap[disk.pos.x][disk.pos.y] = null;
    disk.updatePosition(newPos);
    _gameMap[newPos.x][newPos.y] = disk;
  }

  List<BackgroundTile> getTiles(List<Position> points) {
    return points.map((point) => _tileMap[point.y][point.x]).toList(growable: false);
  }

  bool hasPoint(Position pos) {
    if (pos.x < 0 || pos.y < 0) {
      return false;
    }

    if (pos.x >= 4 || pos.y >= 4) {
      return false;
    }

    return true;
  }

  List<Disk> operator [](int index) => _gameMap[index];
}