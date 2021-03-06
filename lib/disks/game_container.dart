part of disks.lib;

abstract class GameState {
  String get cssName;
  bool get isOverlay;

  final GameContainer container;

  GameState(this.container);

  void init(DivElement div);

  void push(DivElement div);

  void pop(DivElement div);
}

class GameContainer {
  final DivElement container;
  final Element body;

  DivElement _boardEl;
  DivElement _gameEl;
  DivElement _overlayEl;

  GameMap _map;
  GameMap get map => _map;

  GameMechanics _mechanics;
  GameMechanics get mechanics => _mechanics;

  GameInfo _info;
  GameInfo get info => _info;

  // blue always starts
  GameColor turnColor = GameColor.BLUE;
  GameColor winner;

  GameState state;
  GameState modalState;

  Map<Type, GameState> _states = {};
  Map<GameState, DivElement> _stateDivs = {};

  GameContainer({this.container, this.body, DivElement gameInfo}) {
    this._boardEl = container.querySelector(".board");
    this._gameEl = container.querySelector(".game");
    this._overlayEl = container.querySelector(".overlay");

    _map = new GameMap(_boardEl);
    _mechanics = new GameMechanics(map);
    _info = new GameInfo(this, gameInfo);

    map.forEach((Disk disk) {
      if (disk != null) {
        _gameEl.append(disk.element);
      }
    });

    addGameState(new NewGameState(this));
    addGameState(new LocalGameState(this));
    addGameState(new WonGameState(this));
    addGameState(new HowToPlayState(this));

    setGameState(NewGameState);
  }

  // main game state

  void addGameState(GameState state) {
    _states[state.runtimeType] = state;
    DivElement div = _stateDivs[state] = state.isOverlay ?
        _overlayEl.querySelector(".${state.cssName}") :
        document.body.querySelector(".${state.cssName}");

    state.init(div);
  }

  void setGameState(Type stateType) {
    GameState oldState = state;
    GameState newState = _states[stateType];
    this.state = newState;

    oldState?.pop(_stateDivs[oldState]);
    if ((oldState == null || oldState.isOverlay) && !newState.isOverlay) {
      _overlayEl.classes.add("hidden");
    }

    if (newState.isOverlay) {
      _overlayEl.classes.remove("hidden");
    }

    newState.push(_stateDivs[newState]);
  }

  // modal state is an optional state on-top of the game state
  // i.e. how-to menu

  void setModalState(Type stateType) {
    if (this.modalState != null) {
      return;
    }

    GameState newState = _states[stateType];
    this.modalState = newState;

    newState.push(_stateDivs[newState]);
  }

  void removeModalState() {
    if (this.modalState == null) {
      return;
    }

    GameState oldState = modalState;
    this.modalState = null;

    oldState.pop(_stateDivs[oldState]);
  }
}