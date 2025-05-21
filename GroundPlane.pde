class GroundPlane {
  float size;
  color planeColor;

  // constructor assigns size and color
  GroundPlane(float s, color c) {
    size = s;
    planeColor = c;
  }

  // draw horizontal ground plane below cube
  void display() {
    pushMatrix();
    rotateX(HALF_PI);         // rotate to lie flat in XZ plane
    translate(0, 0, -200);    // move it below origin
    fill(planeColor);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, size, size);
    popMatrix();
  }
}
