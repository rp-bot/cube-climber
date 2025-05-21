class Coin {
  PVector position;
  float radius = 10;
  boolean collected = false;

  // constructor takes a position vector
  Coin(PVector pos) {
    position = pos.copy();
  }

  // draw the coin if not collected
  void display() {
    if (!collected) {
      pushMatrix();
      translate(position.x, position.y, position.z);
      rotateY(radians(frameCount * 2)); // spin on y-axis
      rotateX(radians(90));             // face toward camera
      fill(255, 223, 0);                // gold color
      noStroke();
      drawDisc(radius, 3);              // custom function for disc shape
      popMatrix();
    }
  }

  // check if coin is collected by comparing distance to player
  boolean checkCollected(PVector playerPos) {
    if (!collected && PVector.dist(position, playerPos) < radius + 10) {
      collected = true;
      return true;
    }
    return false;
  }
}
