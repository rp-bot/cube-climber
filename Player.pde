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
    float limit = cube.size / 2 + 10;
  
    switch (faceID) {
      case 0: // Front
        position.x = constrain(position.x + dx, -limit, limit);
        position.y = constrain(position.y + dy, -limit, limit);
        break;
      case 1: // Right
        position.z = constrain(position.z + dx, -limit, limit);
        position.y = constrain(position.y + dy, -limit, limit);
        break;
      case 2: // Back
        position.x = constrain(position.x - dx, -limit, limit);
        position.y = constrain(position.y + dy, -limit, limit);
        break;
      case 3: // Left
        position.z = constrain(position.z - dx, -limit, limit);
        position.y = constrain(position.y + dy, -limit, limit);
        break;
    }
  }


  void update(ArrayList<Platform> platforms, int faceID) {
    isGrounded = false;
    velocity.y += gravityStrength;
  
    // Predict position
    PVector nextPos = position.copy();
    nextPos.y += velocity.y;
  
    for (Platform p : platforms) {
      float platformTopY = p.position.y + p.size.y / 2 - 20; // Adjust for player half-height
    
      if (velocity.y > 0 &&
          position.y + velocity.y >= platformTopY &&
          position.y < platformTopY + 5) {
    
        boolean horizontalAligned = false;
    
        horizontalAligned =
        abs(position.x - p.position.x) < p.size.x / 2 &&
        abs(position.z - p.position.z) < p.size.z / 2;


    
        if (horizontalAligned) {
          velocity.y = 0;
          nextPos.y = platformTopY;
          isGrounded = true;
          break;
        }
      }
    }





  
    // Ground collision for all faces
    float groundY = 150; // Ground plane Y minus half player height

    if (nextPos.y > groundY) {
      nextPos.y = groundY;
      velocity.y = 0;
      isGrounded = true;
    }
  
    position.y = nextPos.y;
  }
}
