part of disks.lib;

class GameMechanics {
  final GameMap map;

  GameMechanics(this.map);

  GameColor _checkHorLines(int row) {
    int redCount = 0;
    int blueCount = 0;

    map[row].forEach((disk) {
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

  GameColor _checkVertLines(int row) {
    int redCount = 0;
    int blueCount = 0;

    _checkDisk(disk) {
      if (disk == null) {
        return;
      }

      if (disk.color == GameColor.RED) {
        redCount++;
      }

      if (disk.color == GameColor.BLUE) {
        blueCount++;
      }
    }

    _checkDisk(map[0][row]);
    _checkDisk(map[1][row]);
    _checkDisk(map[2][row]);
    _checkDisk(map[3][row]);

    if (redCount == 4) {
      return GameColor.RED;
    }

    if (blueCount == 4) {
      return GameColor.BLUE;
    }
    
    return null;
  }

  GameColor _checkBox(int x, int y) {
    int redCount = 0;
    int blueCount = 0;

    _checkDisk(disk) {
      if (disk == null) {
        return;
      }

      if (disk.color == GameColor.RED) {
        redCount++;
      }

      if (disk.color == GameColor.BLUE) {
        blueCount++;
      }
    }

    _checkDisk(map[x][y]);
    _checkDisk(map[x + 1][y]);
    _checkDisk(map[x + 1][y + 1]);
    _checkDisk(map[x][y + 1]);

    if (redCount == 4) {
      return GameColor.RED;
    }

    if (blueCount == 4) {
      return GameColor.BLUE;
    }
    
    return null;
  }

  GameColor _checkCorners() {
    int redCount = 0;
    int blueCount = 0;

    _checkDisk(disk) {
      if (disk == null) {
        return;
      }

      if (disk.color == GameColor.RED) {
        redCount++;
      }

      if (disk.color == GameColor.BLUE) {
        blueCount++;
      }
    }

    _checkDisk(map[0][0]);
    _checkDisk(map[0][3]);
    _checkDisk(map[3][3]);
    _checkDisk(map[3][0]);

    if (redCount == 4) {
      return GameColor.RED;
    }

    if (blueCount == 4) {
      return GameColor.BLUE;
    }
    
    return null;
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