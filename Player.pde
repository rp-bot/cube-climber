class Player {
  PVector position;
  PVector velocity = new PVector(0, 0, 0);
  float gravityStrength = 0.5;
  boolean isGrounded = false;

  // constructor sets initial position
  Player(PVector pos) {
    position = pos.copy();
  }

  // draw the player as a green cube
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(0, 255, 0);
    box(20);
    popMatrix();
  }

  // move the player on the active cube face
  void moveScreenRelative(float dx, float dy, int faceID) {
    float halfSize = cube.size / 2 - 10;

    switch (faceID) {
      case 0: // front
        position.x = constrain(position.x + dx, cube.position.x - halfSize, cube.position.x + halfSize);
        position.y += dy;
        position.z = cube.position.z + cube.size / 2 + 10;
        break;
      case 1: // right
        position.z = constrain(position.z - dx, cube.position.z - halfSize, cube.position.z + halfSize);
        position.y += dy;
        position.x = -(cube.position.x + cube.size / 2 + 10);
        break;
      case 2: // back
        position.x = constrain(position.x + dx, cube.position.x - halfSize, cube.position.x + halfSize);
        position.y += dy;
        position.z = cube.position.z - cube.size / 2 - 10;
        break;
      case 3: // left
        position.z = constrain(position.z - dx, cube.position.z - halfSize, cube.position.z + halfSize);
        position.y += dy;
        position.x = -(cube.position.x - cube.size / 2 - 10);
        break;
    }
  }

  // apply gravity, handle platform collisions and ground
  void update(ArrayList<Platform> platforms) {
    isGrounded = false;
    velocity.y += gravityStrength;

    PVector nextPos = position.copy();
    nextPos.y += velocity.y;

    for (Platform p : platforms) {
      float topY = p.position.y + p.size.y / 2 - 20;
      float bottomY = p.position.y - p.size.y / 2 + 20;

      boolean horizontallyAligned =
        abs(position.x - p.position.x) < p.size.x / 2 + 10 &&
        abs(position.z - p.position.z) < p.size.z / 2 + 10;

      if (velocity.y > 0 &&
          position.y + velocity.y >= topY &&
          position.y < topY + 5 &&
          horizontallyAligned) {
        velocity.y = 0;
        nextPos.y = topY;
        isGrounded = true;
        break;
      }

      if (velocity.y < 0 &&
          position.y + velocity.y <= bottomY &&
          position.y > bottomY - 5 &&
          horizontallyAligned) {
        velocity.y = 0;
        nextPos.y = bottomY;
        break;
      }
    }

    float groundY = 150;
    if (nextPos.y > groundY) {
      nextPos.y = groundY;
      velocity.y = 0;
      isGrounded = true;
    }

    position.y = nextPos.y;
  }
}
