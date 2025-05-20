

class Cube {
  PVector position;
  float size;
  int currentFace = 0;
  Face[] faces;
color[] faceColors = {
  color(255, 128, 128),  // Front - light red
  color(255, 153, 153),  // Right - lighter red
  color(255, 178, 178),  // Back - soft rose
  color(255, 204, 204)   // Left - very pale red
};

  Cube(PVector pos, float s) {
    position = pos;
    size = s;
    faces = new Face[4];
    for (int i = 0; i < 4; i++) {
      faces[i] = new Face(i, size);
    }
  }

  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    float hs = size / 2;

    // FRONT
    fill(faceColors[0]);
    beginShape(QUADS);
    vertex(-hs, -hs, hs);
    vertex(hs, -hs, hs);
    vertex(hs, hs, hs);
    vertex(-hs, hs, hs);
    endShape();

    // RIGHT
    fill(faceColors[1]);
    beginShape(QUADS);
    vertex(hs, -hs, hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(hs, hs, hs);
    endShape();

    // BACK
    fill(faceColors[2]);
    beginShape(QUADS);
    vertex(hs, -hs, -hs);
    vertex(-hs, -hs, -hs);
    vertex(-hs, hs, -hs);
    vertex(hs, hs, -hs);
    endShape();

    // LEFT
    fill(faceColors[3]);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(-hs, -hs, hs);
    vertex(-hs, hs, hs);
    vertex(-hs, hs, -hs);
    endShape();

    // TOP (gray)
    fill(150);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, -hs, hs);
    vertex(-hs, -hs, hs);
    endShape();

    // BOTTOM (dark gray)
    fill(80);
    beginShape(QUADS);
    vertex(-hs, hs, hs);
    vertex(hs, hs, hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();
    
    
    for (Face f : faces) {
      f.display();
    }
    
    popMatrix();
  }

  void rotateLeft() {
    currentFace = (currentFace + 1) % 4;
  }
  
  void rotateRight() {
    currentFace = (currentFace + 3) % 4;
  }
  
  float getTargetAngle() {
    return currentFace * 90;
  }
}
