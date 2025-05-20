class Coin {
  PVector position;
  float radius = 10;
  boolean collected = false;

  Coin(PVector pos) {
    position = pos.copy();
  }

  void display() {
    if (!collected) {
      pushMatrix();
      translate(position.x, position.y, position.z);
      fill(255, 223, 0); // gold
      noStroke();
      sphere(radius);
      popMatrix();
    }
  }

  boolean checkCollected(PVector playerPos) {
    if (!collected && PVector.dist(position, playerPos) < radius + 10) {
      collected = true;
      return true;
    }
    return false;
  }
}
