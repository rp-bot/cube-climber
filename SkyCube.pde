class SkyCube {
  float size;

  SkyCube(float s) {
    size = s;
  }

  void display() {
    pushMatrix();
    noStroke();
    translate(0, 0, 0);
    float hs = size / 2;

    // Back
    fill(200, 220, 255); // cool sky blue
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();

    // Front
    fill(255, 230, 200); // warm sunrise peach
    beginShape(QUADS);
    vertex(-hs, -hs, hs);
    vertex(hs, -hs, hs);
    vertex(hs, hs, hs);
    vertex(-hs, hs, hs);
    endShape();

    // Left
    fill(220, 240, 255);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(-hs, -hs, hs);
    vertex(-hs, hs, hs);
    vertex(-hs, hs, -hs);
    endShape();

    // Right
    fill(220, 240, 255);
    beginShape(QUADS);
    vertex(hs, -hs, hs);
    vertex(hs, -hs, -hs);
    vertex(hs, hs, -hs);
    vertex(hs, hs, hs);
    endShape();

    // Top
    fill(255, 255, 255); // bright sky overhead
    beginShape(QUADS);
    vertex(-hs, -hs, -hs);
    vertex(hs, -hs, -hs);
    vertex(hs, -hs, hs);
    vertex(-hs, -hs, hs);
    endShape();

    // Bottom
    fill(200, 200, 220); // subtle reflection tone
    beginShape(QUADS);
    vertex(-hs, hs, hs);
    vertex(hs, hs, hs);
    vertex(hs, hs, -hs);
    vertex(-hs, hs, -hs);
    endShape();

    popMatrix();
  }
}
