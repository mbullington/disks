part of disks.lib;

class GameInfo {
  final GameContainer container;
  final DivElement element;

  DivElement _leftButton;
  DivElement _turnIndicator;
  DivElement _rightButton; 

  GameInfo(this.container, this.element) {
    _leftButton = element.querySelector(".left-button")..onClick.listen(_onLeftButton);
    _turnIndicator = element.querySelector(".turn-indicator");
    _rightButton = element.querySelector(".right-button")..onClick.listen(_onRightButton);
  }

  _onLeftButton(_) {
    container.setModalState(HowToPlayState);
  }

  _onRightButton(_) {
    container.setGameState(NewGameState);
  }

  push() {
    element.classes.remove("hidden");
  }

  pop() {
    element.classes.add("hidden");
  }
  
  setTurnIndicator() {
    _turnIndicator.innerHtml = "${container.turnColor.cssName}'s turn.";
  }
}