// Copyright (c) 2017, Michael Bullington. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library disks;

import "package:disks/disks.dart";
import "package:pwa/client.dart" as pwa;

import "dart:html";

void main() {
  new pwa.Client();

  new GameContainer(
      container: querySelector(".container"),
      gameInfo: querySelector(".game-info"),
      body: document.body,
  );
}
