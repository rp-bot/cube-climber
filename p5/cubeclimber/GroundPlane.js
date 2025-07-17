class GroundPlane {
  // constructor assigns size and color
  constructor(s, c) {
    this.size = s;
    this.planeColor = c;
  }

  // draw horizontal ground plane below cube
  display() {
    push();
    translate(0, 0, 200); // Adjusted Y position to be under the cube
    rotateX(HALF_PI);
    fill(this.planeColor);
    noStroke();
    rectMode(CENTER);
    rect(0, 0, this.size, this.size);
    pop();
  }
}
