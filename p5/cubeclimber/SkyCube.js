class SkyCube {
  // constructor sets cube size
  constructor(s) {
    this.size = s;
  }

  // draw a large colored cube to simulate sky
  display() {
    push();
    noStroke();
    let hs = this.size / 2;

    // To prevent the camera from going inside the skybox, we draw it at the origin
    // and make sure the camera never moves further than its radius.
    // The faces are inverted because we are inside the cube.
    
    // back
    fill(200, 220, 255);
    beginShape(); vertex(hs, hs, -hs); vertex(-hs, hs, -hs); vertex(-hs, -hs, -hs); vertex(hs, -hs, -hs); endShape(CLOSE);
    // front
    fill(255, 230, 200);
    beginShape(); vertex(-hs, hs, hs); vertex(hs, hs, hs); vertex(hs, -hs, hs); vertex(-hs, -hs, hs); endShape(CLOSE);
    // left
    fill(220, 240, 255);
    beginShape(); vertex(-hs, hs, -hs); vertex(-hs, hs, hs); vertex(-hs, -hs, hs); vertex(-hs, -hs, -hs); endShape(CLOSE);
    // right
    fill(220, 240, 255);
    beginShape(); vertex(hs, hs, hs); vertex(hs, hs, -hs); vertex(hs, -hs, -hs); vertex(hs, -hs, hs); endShape(CLOSE);
    // top
    fill(255, 255, 255);
    beginShape(); vertex(hs, -hs, hs); vertex(hs, -hs, -hs); vertex(-hs, -hs, -hs); vertex(-hs, -hs, hs); endShape(CLOSE);
    // bottom
    fill(200, 200, 220);
    beginShape(); vertex(-hs, hs, -hs); vertex(hs, hs, -hs); vertex(hs, hs, hs); vertex(-hs, hs, hs); endShape(CLOSE);
    
    pop();
  }
}
