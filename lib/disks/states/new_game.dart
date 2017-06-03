part of disks.lib;

class NewGameState extends GameState {
  String cssName = "new-game";

  bool isOverlay = true;

  NewGameState(GameContainer container): super(container);

  @override
  void init(DivElement div) {
    div.querySelector(".btn").onClick.listen(_onClick);
  }

  _onClick(_) {
    container.setGameState(LocalGameState);
  }

  @override
  void push(DivElement div) {
    div.classes.remove("hidden");
  }
  
  @override
  void pop(DivElement div) {
    div.classes.add("hidden");
  }
}