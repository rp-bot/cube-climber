class Platform {
  // constructor sets position and size
  constructor(pos, sz) {
    this.position = pos;
    this.size = sz;
    this.rotationY = 0;
  }

  setRotation(angle) { this.rotationY = angle; }

  // draw the platform box
  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z);
    rotateY(radians(this.rotationY));
    fill(255, 120, 0);
    noStroke();
    box(this.size.x, this.size.y, this.size.z);
    pop();
  }
}
