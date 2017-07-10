@JS()
library anime;

import "package:js/js.dart";

@JS()
class AnimeOptions {
  // String, Element, List
  external dynamic get targets;
  external set targets(dynamic v);

  external String get easing;
  external set easing(String v);

  external Function get update;
  external set update(Function v);

  external factory AnimeOptions({
      dynamic targets,
      String easing,
      Function update
      });
} 

@JS("anime")
external void anime(AnimeOptions options);