// Coin.js

class Coin {
  // constructor takes a position vector
  constructor(pos) {
    this.position = pos.copy();
    this.radius = 10;
    this.collected = false;
  }

  // draw the coin if not collected
  display() {
    if (!this.collected) {
      push();
      translate(this.position.x, this.position.y, this.position.z);
      rotateY(radians(frameCount * 2));
      rotateX(radians(90));
      fill(255, 223, 0);
      noStroke();
      // This call will now work because the function is in the same file
      drawDisc(this.radius, 3);
      pop();
    }
  }

  // check if coin is collected by comparing distance to player
  checkCollected(playerPos) {
    if (!this.collected && dist(this.position, playerPos) < this.radius + 10) {
      this.collected = true;
      return true;
    }
    return false;
  }
}

// Helper function, moved from sketch.js
function drawDisc(r, thickness) {
  let sides = 30;
  let angleStep = TWO_PI / sides;

  // Top face
  beginShape(TRIANGLE_FAN);
  vertex(0, -thickness / 2, 0);
  for (let i = 0; i <= sides; i++) {
    let angle = i * angleStep;
    vertex(cos(angle) * r, -thickness / 2, sin(angle) * r);
  }
  endShape();

  // Bottom face
  beginShape(TRIANGLE_FAN);
  vertex(0, thickness / 2, 0);
  for (let i = 0; i <= sides; i++) {
    let angle = -i * angleStep;
    vertex(cos(angle) * r, thickness / 2, sin(angle) * r);
  }
  endShape();

  // Side wall
  beginShape(QUAD_STRIP);
  for (let i = 0; i <= sides; i++) {
    let angle = i * angleStep;
    let x = cos(angle) * r;
    let z = sin(angle) * r;
    vertex(x, -thickness / 2, z);
    vertex(x, thickness / 2, z);
  }
  endShape();
}
