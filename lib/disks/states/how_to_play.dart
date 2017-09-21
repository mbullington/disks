part of disks.lib;

class HowToPlayState extends GameState {
  String cssName = "how-to-play";

  bool isOverlay = false;

  HowToPlayState(GameContainer container): super(container);

  @override
  void init(DivElement div) {
    div.querySelector(".octicon").onClick.listen(_onClick);
  }

  _onClick(_) {
    container.removeModalState();
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