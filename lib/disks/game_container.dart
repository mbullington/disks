part of disks.lib;

class GameContainer {
  DivElement _container;
  DivElement _background;

  final Element body;
  final DivElement turnIndicator;

  GameMap _map;
  GameMechanics _mechanics;

  // blue always starts
  GameColor turnColor = GameColor.BLUE;

  GameContainer(DivElement container, this.body, this.turnIndicator) {
    _container = container.querySelector(".game-container");
    _background = container.querySelector(".background");

    _map = new GameMap(_background);
    _mechanics = new GameMechanics(_map);

    _map.forEach((Disk disk) {
      if (disk != null) {
        _container.append(disk.element);
        _onClick(disk);
        _onTouch(disk);
      }
    });

    body.classes..add(turnColor.cssName);
    turnIndicator.innerHtml = "${turnColor.cssName}'s turn.";
    turnIndicator.style.opacity = "1";
  }

  void endTurn() {
    String oldCssName = turnColor.cssName;
    turnColor = turnColor.opposite;

    body.classes..remove(oldCssName)..add(turnColor.cssName);
    turnIndicator.innerHtml = "${turnColor.cssName}'s turn.";
  }

  void _onClick(Disk disk) {
    num x = 0;
    num y = 0;

    StreamSubscription sub;
    List<Position> possiblePos;
    List<BackgroundTile> tiles;

    disk.element.onMouseDown.listen((MouseEvent e) {
      if (disk.color != turnColor) {
        return;
      }

      num startX = e.page.x;
      num startY = e.page.y;

      possiblePos = diskHover(disk);
      tiles = _map.getTiles(possiblePos);

      tiles.forEach((tile) => tile.highlight(disk.color));

      x = 0;
      y = 0;
      
      sub = window.onMouseMove.listen((MouseEvent ev) {
        x = ev.page.x;
        y = ev.page.y;
        disk.moveSlightly(x - startX, y - startY);
      });
    });

    window.onMouseUp.listen((MouseEvent e) {
      if (sub != null) {
        sub.cancel();
        sub = null;

        tiles.forEach((tile) => tile.unhighlight());
        diskPlace(disk, x, y, possiblePos);
      }
    });
  } 

  void _onTouch(Disk disk) {
    num x = 0;
    num y = 0;

    StreamSubscription sub;
    List<Position> possiblePos;
    List<BackgroundTile> tiles;    
    int identifier = -1;

    disk.element.onTouchStart.listen((TouchEvent e) {
      if (disk.color != turnColor) {
        return;
      }

      if (identifier > -1) {
        return;
      }

      identifier = e.changedTouches[0].identifier;
      num startX = e.changedTouches[0].page.x;
      num startY = e.changedTouches[0].page.y;

      possiblePos = diskHover(disk);
      tiles = _map.getTiles(possiblePos);

      tiles.forEach((tile) => tile.highlight(disk.color));

      x = 0;
      y = 0;
      
      sub = window.onTouchMove.listen((TouchEvent ev) {
        ev.changedTouches.forEach((Touch t) {
          if (t.identifier != identifier) {
            return;
          }
          
          x = t.page.x;
          y = t.page.y;
          disk.moveSlightly(x - startX, y - startY);
        });
      });
    });

    window.onTouchEnd.listen((TouchEvent e) {
      if (sub == null) {
        return;
      }

      e.changedTouches.forEach((Touch t) {
        if (t.identifier == identifier) {
          sub.cancel();
          sub = null;
          identifier = -1;

          tiles.forEach((tile) => tile.unhighlight());
          diskPlace(disk, x, y, possiblePos);
        }
      });
    });
  }

  List<Position> diskHover(Disk disk) {
    disk.startHover();

    return getPossibleMovements(disk);
  }

  void diskPlace(Disk disk, int x, int y, List<Position> possiblePos) {
    disk.stopHover();

    num gameX = ((x - _container.parent.offsetLeft) / tileHeight).floor();
    num gameY = ((y - _container.parent.offsetTop) / tileHeight).floor();
    Position gamePos = new Position(gameX, gameY);

    if (possiblePos.any((pos) => gamePos.x == pos.x && gamePos.y == pos.y)) {
      _map.updatePosition(disk, gamePos);

      GameColor winner = _mechanics.getWinner();
      if (winner != null) {
        print("${winner == GameColor.RED ? "red" : "blue"} wins!");
      }

      endTurn();
    } else {
      disk.moveSlightly(0, 0);
    }
  }

  List<Position> getPossibleMovements(Disk disk) {
    Position pos = disk.pos;
    List<Position> returned = [];

    Position _loop(Function updateFunc) {
      Position p = updateFunc(pos);
      Position p2;

      while (p != null) {
        if (!_map.hasPoint(p)) {
          if (p2 != null) {
            returned.add(p2);
          }
          break;
        }

        if (_map[p.x][p.y] == null) {
          p2 = p;
          p = updateFunc(p);
        } else {
          if (p2 != null) {
            returned.add(p2);
          }
          break;
        }
      }
    }

    _loop((Position pos) => new Position(pos.x + 1, pos.y));
    _loop((Position pos) => new Position(pos.x - 1, pos.y));
    _loop((Position pos) => new Position(pos.x, pos.y + 1));
    _loop((Position pos) => new Position(pos.x, pos.y - 1));

    return returned;
  }
}