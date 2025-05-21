class Cube {
  PVector position;
  float size;
  int currentFace = 0;
  Face[] faces;

  // colors for 4 cube sides
  color[] faceColors = {
    color(255, 128, 128),
    color(255, 153, 153),
    color(255, 178, 178),
    color(255, 204, 204)
  };

  // constructor sets position, size, and face array
  Cube(PVector pos, float s) {
    position = pos;
    size = s;
    faces = new Face[4];
    for (int i = 0; i < 4; i++) {
      faces[i] = new Face(i, size);
    }
  }

  // draw cube with color-coded faces
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    float hs = size / 2;

    // front
    fill(faceColors[0]);
    beginShape(QUADS);
    vertex(-hs, -hs, hs);
    vertex(hs, -hs, hs);
    vertex(hs, hs, hs);
    vertex(-hs, hs, hs);
    endShape();

    // right
    fill(faceColors[1]);
    beginShape(QUADS);
    vertex(hs, -hs, hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(hs, hs, hs);
    endShape();

    // back
    fill(faceColors[2]);
    beginShape(QUADS);
    vertex(hs, -hs, -hs);
    vertex(-hs, -hs, -hs);
    vertex(-hs, hs, -hs);
    vertex(hs, hs, -hs);
    endShape();

    // left
    fill(faceColors[3]);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(-hs, -hs, hs);
    vertex(-hs, hs, hs);
    vertex(-hs, hs, -hs);
    endShape();

    // top
    fill(150);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, -hs, hs);
    vertex(-hs, -hs, hs);
    endShape();

    // bottom
    fill(80);
    beginShape(QUADS);
    vertex(-hs, hs, hs);
    vertex(hs, hs, hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();

    // draw attached faces
    for (Face f : faces) {
      f.display();
    }

    popMatrix();
  }

  // rotate view to the left
  void rotateLeft() {
    currentFace = (currentFace + 1) % 4;
  }

  // rotate view to the right
  void rotateRight() {
    currentFace = (currentFace + 3) % 4;
  }

  // angle to rotate to face front
  float getTargetAngle() {
    return currentFace * 90;
  }
}
