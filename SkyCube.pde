class SkyCube {
  float size;

  // constructor sets cube size
  SkyCube(float s) {
    size = s;
  }

  // draw a large colored cube to simulate sky
  void display() {
    pushMatrix();
    noStroke();
    translate(0, 0, 0);
    float hs = size / 2;

    // back
    fill(200, 220, 255);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();

    // front
    fill(255, 230, 200);
    beginShape(QUADS);
    vertex(-hs, -hs, hs);
    vertex(hs, -hs, hs);
    vertex(hs, hs, hs);
    vertex(-hs, hs, hs);
    endShape();

    // left
    fill(220, 240, 255);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(-hs, -hs, hs);
    vertex(-hs, hs, hs);
    vertex(-hs, hs, -hs);
    endShape();

    // right
    fill(220, 240, 255);
    beginShape(QUADS);
    vertex(hs, -hs, hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(hs, hs, hs);
    endShape();

    // top
    fill(255, 255, 255);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, -hs, hs);
    vertex(-hs, -hs, hs);
    endShape();

    // bottom
    fill(200, 200, 220);
    beginShape(QUADS);
    vertex(-hs, hs, hs);
    vertex(hs, hs, hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();

    popMatrix();
  }
}
