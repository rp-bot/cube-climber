class GroundPlane {
  float size;
  color planeColor;

  GroundPlane(float s, color c) {
    size = s;
    planeColor = c;
  }

  void display() {
    pushMatrix();
    rotateX(HALF_PI); // Rotate to make it horizontal (XZ plane)
    translate(0, 0,  -200); // Position it below the cube
    fill(planeColor);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, size, size);
    popMatrix();
  }
}
