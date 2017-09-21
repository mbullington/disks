part of disks.lib;

class LocalGameState extends GameState {
  String cssName = "game";

  bool isOverlay = false;

  List<StreamSubscription> _subscriptions = [];
  DivElement _div;

  LocalGameState(GameContainer container): super(container);

  @override
  void init(DivElement div) {
    _div = div;
    container.info.pop();
  }

  @override
  void push(DivElement div) {
    container.map.forEach((Disk disk) {
      if (disk != null) {
        _onClick(disk);
        _onTouch(disk);
      }
    });

    container.winner = null;
    container.map.reset();
    setTurnColor(GameColor.BLUE);

    container.info.push();
  }
  
  @override
  void pop(DivElement div) {
    container.info.pop();
    _subscriptions.forEach((sub) => sub.cancel());
  }

  void endTurn() => setTurnColor(container.turnColor.opposite);

  void setTurnColor(GameColor color) {
    String oldCssName = container.turnColor?.cssName;
    container.turnColor = color;

    if (oldCssName != null) {
      container.body.classes.remove(oldCssName);
    }
    
    container.body.classes.add(container.turnColor.cssName);
    
    document.head.querySelector('meta[name="theme-color"]').setAttribute("content", container.turnColor == GameColor.BLUE ? "#20A0FF": "#FF4949");
    container.info.setTurnIndicator();
  }

  void _onClick(Disk disk) {
    num x = 0;
    num y = 0;

    StreamSubscription sub;
    List<Position> possiblePos;
    List<BackgroundTile> tiles;

    _subscriptions.add(disk.element.onMouseDown.listen((MouseEvent e) {
      if (disk.color != container.turnColor) {
        return;
      }

      num startX = e.page.x;
      num startY = e.page.y;

      possiblePos = diskHover(disk);
      tiles = container.map.getTiles(possiblePos);

      tiles.forEach((tile) => tile.highlight(disk.color));

      x = 0;
      y = 0;
      
      sub = window.onMouseMove.listen((MouseEvent ev) {
        x = ev.page.x;
        y = ev.page.y;
        disk.moveSlightly(x - startX, y - startY);
      });
    }));

    _subscriptions.add(window.onMouseUp.listen((MouseEvent e) {
      if (sub != null) {
        sub.cancel();
        sub = null;

        tiles.forEach((tile) => tile.unhighlight());
        diskPlace(disk, x, y, possiblePos);
      }
    }));
  } 

  void _onTouch(Disk disk) {
    num x = 0;
    num y = 0;

    StreamSubscription sub;
    List<Position> possiblePos;
    List<BackgroundTile> tiles;    
    int identifier = -1;

    _subscriptions.add(disk.element.onTouchStart.listen((TouchEvent e) {
      if (disk.color != container.turnColor) {
        return;
      }

      if (identifier > -1) {
        return;
      }

      identifier = e.changedTouches[0].identifier;
      num startX = e.changedTouches[0].page.x;
      num startY = e.changedTouches[0].page.y;

      possiblePos = diskHover(disk);
      tiles = container.map.getTiles(possiblePos);

      tiles.forEach((tile) => tile.highlight(disk.color));

      x = 0;
      y = 0;
      
      sub = document.body.onTouchMove.listen((TouchEvent ev) {
        // prevent pull-to-refresh on Chrome iOS
        // prevent rubber banding on Mobile Safari
        ev.preventDefault();
        ev.stopPropagation();
        
        ev.changedTouches.forEach((Touch t) {
          if (t.identifier != identifier) {
            return;
          }
          
          x = t.page.x;
          y = t.page.y;
          disk.moveSlightly(x - startX, y - startY);
        });
      });
    }));

    _subscriptions.add(window.onTouchEnd.listen((TouchEvent e) {
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
    }));
  }

  List<Position> diskHover(Disk disk) {
    disk.startHover();

    return getPossibleMovements(disk);
  }

  void diskPlace(Disk disk, int x, int y, List<Position> possiblePos) {
    disk.stopHover();

    num gameX = ((x - _div.parent.offsetLeft) / tileHeight).floor();
    num gameY = ((y - _div.parent.offsetTop) / tileHeight).floor();
    Position gamePos = new Position(gameX, gameY);

    if (possiblePos.any((pos) => gamePos.x == pos.x && gamePos.y == pos.y)) {
      container.map.updatePosition(disk, gamePos);

      GameColor winner = container.mechanics.getWinner();
      if (winner != null) {
        container.winner = winner;
        container.setGameState(WonGameState);
      } else {
        endTurn();
      }
    } else {
      disk.moveSlightly(0, 0);
    }
  }

  List<Position> getPossibleMovements(Disk disk) {
    Position pos = disk.pos;
    List<Position> returned = [];

    void _loop(Function updateFunc) {
      Position p = updateFunc(pos);
      Position p2;

      while (p != null) {
        if (!container.map.hasPoint(p)) {
          if (p2 != null) {
            returned.add(p2);
          }
          break;
        }

        if (container.map.getFromPosition(p) == null) {
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