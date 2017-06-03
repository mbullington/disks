// Copyright (c) 2017, Michael Bullington. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library disks;

import "package:disks/disks.dart";

import "dart:html";

void main() {
  GameContainer container = new GameContainer(
      querySelector(".container"),
      document.body,
      querySelector(".turn-indicator"));
}
