class Face {
  int faceID; // 0 = front, 1 = right, 2 = back, 3 = left
  ArrayList<Platform> platforms = new ArrayList<Platform>();
  ArrayList<Coin> coins = new ArrayList<Coin>();
  float cubeSize;

  // constructor assigns face ID and size
  Face(int id, float s) {
    faceID = id;
    cubeSize = s;
    generatePlatforms();
  }

  // create platforms and coins based on face orientation
  void generatePlatforms() {
    int cols = 4;
    int rows = 4;
    float spacing = (cubeSize - 60) / (cols - 1);

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        float x = -cubeSize / 2 + 30 + i * spacing;
        float y = -cubeSize / 2 + 30 + j * spacing;
        float zOffset = cubeSize / 2 + 10;

        PVector pos;
        switch (faceID) {
          case 0:
            pos = new PVector(x, y, zOffset);
            break;
          case 1:
            pos = new PVector(-zOffset, y, -x);
            break;
          case 2:
            pos = new PVector(-x, y, -zOffset);
            break;
          case 3:
            pos = new PVector(zOffset, y, x);
            break;
          default:
            pos = new PVector(0, 0, 0);
            break;
        }

        Platform plat = new Platform(pos, new PVector(40, 10, 20));

        if (faceID == 1 || faceID == 3) {
          plat.setRotation(90);
        }

        platforms.add(plat);

        // coin above every second platform
        if ((i + j) % 2 == 0) {
          coins.add(new Coin(pos.copy().add(0, -30, 0)));
        }
      }
    }
  }

  // draw platforms and coins
  void display() {
    for (Platform p : platforms) {
      p.display();
    }

    for (Coin c : coins) {
      c.display();
    }
  }
}
