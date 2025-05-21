class Platform {
  PVector position;
  PVector size;
  float rotationY = 0;

  // constructor sets position and size
  Platform(PVector pos, PVector sz) {
    position = pos;
    size = sz;
  }

  // set y-axis rotation in degrees
  void setRotation(float angle) {
    rotationY = angle;
  }

  // draw the platform box
  void display() {
    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(radians(rotationY));
    fill(255, 120, 0);
    noStroke();
    box(size.x, size.y, size.z);
    popMatrix();
  }
}
