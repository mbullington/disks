part of disks.lib;

class GameMechanics {
  final GameMap map;

  GameMechanics(this.map);

  GameColor _getResult(List<Disk> disks) {
    int redCount = 0;
    int blueCount = 0;

    disks.forEach((disk) {
      if (disk == null) {
        return;
      }

      if (disk.color == GameColor.RED) {
        redCount++;
      }

      if (disk.color == GameColor.BLUE) {
        blueCount++;
      }
    });

    if (redCount == 4) {
      return GameColor.RED;
    }

    if (blueCount == 4) {
      return GameColor.BLUE;
    }

    return null;
  }

  GameColor _checkHorLines(int row) {
    return _getResult([
      map[row][0],
      map[row][1],
      map[row][2],
      map[row][3]
    ]);
  }

  GameColor _checkVertLines(int row) {
    return _getResult([
      map[0][row],
      map[1][row],
      map[2][row],
      map[3][row]
    ]);
  }

  GameColor _checkBox(int x, int y) {
    return _getResult([
      map[x][y],
      map[x + 1][y],
      map[x + 1][y + 1],
      map[x][y + 1]
    ]);
  }

  GameColor _checkCorners() {
    return _getResult([
      map[0][0],
      map[0][3],
      map[3][3],
      map[3][0]
    ]);
  }

  GameColor getWinner() {
    GameColor color = _checkHorLines(0);
    if (color != null) {
      return color;
    }

    color = _checkHorLines(3);
    if (color != null) {
      return color;
    }

    color = _checkVertLines(0);
    if (color != null) {
      return color;
    }

    color = _checkVertLines(3);
    if (color != null) {
      return color;
    }

    color = _checkBox(0, 0);
    if (color != null) {
      return color;
    }

    color = _checkBox(0, 2);
    if (color != null) {
      return color;
    }

    color = _checkBox(2, 2);
    if (color != null) {
      return color;
    }

    color = _checkBox(2, 0);
    if (color != null) {
      return color;
    }

    color = _checkCorners();
    return color;
  }
}