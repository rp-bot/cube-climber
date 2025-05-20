class Player {
  PVector position;
  PVector velocity = new PVector(0, 0, 0);
  float gravityStrength = 0.5;
  boolean isGrounded = false;

  
  
  
  Player(PVector pos) {
    position = pos.copy();
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    fill(0, 255, 0);
    box(20);
    popMatrix();
  }

  void moveScreenRelative(float dx, float dy, int faceID) {
    float halfSize = cube.size / 2 - 10;
  
    switch (faceID) {
      case 0: // Front (X/Y plane at Z+)
        position.x = constrain(position.x + dx, cube.position.x - halfSize, cube.position.x + halfSize);
        position.y += dy; // let gravity and platform collision handle vertical limits
        position.z = cube.position.z + cube.size / 2 +10;
        break;
  
      case 1: // Right (Z/Y plane at X+)
        position.z = constrain(position.z - dx, cube.position.z - halfSize, cube.position.z + halfSize); // reversed
        position.y +=dy;
        position.x = - (cube.position.x + cube.size / 2 + 10);
        break;
  
      case 2: // Back (X/Y plane at Z-)
        position.x = constrain(position.x + dx, cube.position.x - halfSize, cube.position.x + halfSize); // reversed
        position.y +=dy;
        position.z = cube.position.z - cube.size / 2 -10 ;
        break;
  
      case 3: // Left (Z/Y plane at X-)
        position.z = constrain(position.z - dx, cube.position.z - halfSize, cube.position.z + halfSize);
        position.y +=dy;
        position.x = -(cube.position.x - cube.size / 2 -10);
        break;
    }
  
  }




  void update(ArrayList<Platform> platforms) {
    isGrounded = false;
    velocity.y += gravityStrength;
  
    // Predict position
    PVector nextPos = position.copy();
    nextPos.y += velocity.y;
  
    for (Platform p : platforms) {
      float topY = p.position.y + p.size.y / 2 - 20;  // top surface
      float bottomY = p.position.y - p.size.y / 2 + 20; // bottom surface
  
      boolean horizontallyAligned =
        abs(position.x - p.position.x) < p.size.x/2 +10  &&
        abs(position.z - p.position.z) < p.size.z/2 +10 ;
  
      // Collision from top (landing)
      if (velocity.y > 0 &&
          position.y + velocity.y >= topY &&
          position.y < topY + 5 &&
          horizontallyAligned) {
        velocity.y = 0;
        nextPos.y = topY;
        isGrounded = true;
        break;
      }
  
      // Collision from below (head bump)
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
