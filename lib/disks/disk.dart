part of disks.lib;

class Disk {
  final GameColor color;
  Position pos = new Position(0, 0);

  DivElement element;

  Disk(this.color) {
    element = new DivElement()
      ..classes.addAll(["disk", color == GameColor.RED ? "red" : "blue"]);
  }

  void updatePosition(Position pos) {
    this.pos = pos;
    this.element.style.transform = "translate(${pos.x * tileHeight}px, ${pos.y * tileHeight}px)";
  }

  void moveSlightly(num xDiff, num yDiff) {
    this.element.style.transform = "translate(${pos.x * tileHeight + xDiff}px, ${pos.y * tileHeight + yDiff}px)";
  }

  void startHover() {
    element.classes.add("hover");
  }

  void stopHover() {
    element.classes.remove("hover");
  }
}