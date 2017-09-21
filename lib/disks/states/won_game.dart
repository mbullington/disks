part of disks.lib;

class WonGameState extends GameState {
  String cssName = "won-game";

  bool isOverlay = true;

  WonGameState(GameContainer container): super(container);

  @override
  void init(DivElement div) {
    div.querySelector(".btn").onClick.listen(_onClick);
  }

  _onClick(_) {
    container.setGameState(NewGameState);
  }

  @override
  void push(DivElement div) {
    div.classes.remove("hidden");
    div.children[0].innerHtml = "${container.winner.cssName} won!";
  }
  
  @override
  void pop(DivElement div) {
    div.classes.add("hidden");
  }
}