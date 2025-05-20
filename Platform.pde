class Platform {
  PVector position;
  PVector size;
  float rotationY = 0;
  
  Platform(PVector pos, PVector sz) {
    position = pos;
    size = sz;
  }

  void setRotation(float angle) {
    rotationY = angle;
  }

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
