class Cube {
  // constructor sets position, size, and face array
  constructor(pos, s) {
    this.position = pos;
    this.size = s;
    this.currentFace = 0;
    
    // colors for 4 cube sides
    this.faceColors = [
      color(255, 128, 128),
      color(255, 153, 153),
      color(255, 178, 178),
      color(255, 204, 204)
    ];

    this.faces = []; // Use a standard JS array
    for (let i = 0; i < 4; i++) {
      this.faces.push(new Face(i, this.size));
    }
  }

  // draw cube with color-coded faces
  display() {
    push();
    translate(this.position.x, this.position.y, this.position.z);
    let hs = this.size / 2;

    noStroke();
    
    // front
    fill(this.faceColors[0]);
    beginShape(QUADS);
    vertex(-hs, -hs, hs); vertex(hs, -hs, hs); vertex(hs, hs, hs); vertex(-hs, hs, hs);
    endShape();

    // right
    fill(this.faceColors[1]);
    beginShape(QUADS);
    vertex(hs, -hs, hs); vertex(hs, -hs, -hs); vertex(hs, hs, -hs); vertex(hs, hs, hs);
    endShape();

    // back
    fill(this.faceColors[2]);
    beginShape(QUADS);
    vertex(hs, -hs, -hs); vertex(-hs, -hs, -hs); vertex(-hs, hs, -hs); vertex(hs, hs, -hs);
    endShape();

    // left
    fill(this.faceColors[3]);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs); vertex(-hs, -hs, hs); vertex(-hs, hs, hs); vertex(-hs, hs, -hs);
    endShape();

    // top
    fill(150);
    beginShape(QUADS);
    vertex(-hs, -hs, -hs); vertex(hs, -hs, -hs); vertex(hs, -hs, hs); vertex(-hs, -hs, hs);
    endShape();

    // bottom
    fill(80);
    beginShape(QUADS);
    vertex(-hs, hs, hs); vertex(hs, hs, hs); vertex(hs, hs, -hs); vertex(-hs, hs, -hs);
    endShape();

    // draw attached faces
    for (let f of this.faces) {
      f.display();
    }
    pop();
  }

  rotateLeft() { this.currentFace = (this.currentFace + 1) % 4; }
  rotateRight() { this.currentFace = (this.currentFace + 3) % 4; }
  getTargetAngle() { return this.currentFace * 90; }
}
