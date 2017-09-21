part of disks.lib;

class NewGameState extends GameState {
  String cssName = "new-game";

  bool isOverlay = true;

  NewGameState(GameContainer container): super(container);

  @override
  void init(DivElement div) {
    div.querySelector(".btn").onClick.listen(_onClick);
    div.querySelector(".btn--how-to-play").onClick.listen(_onHowToPlay);
  }

  _onClick(_) {
    container.setGameState(LocalGameState);
  }

  _onHowToPlay(_) {
    container.setModalState(HowToPlayState);
  }

  @override
  void push(DivElement div) {
    div.classes.remove("hidden");
  }
  
  @override
  void pop(DivElement div) {
    print('hello');
    div.classes.add("hidden");
  }
}