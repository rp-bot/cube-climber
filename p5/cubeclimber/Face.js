class Face {
  // constructor assigns face ID and size
  constructor(id, s) {
    this.faceID = id;
    this.cubeSize = s;
    this.platforms = [];
    this.coins = [];
    this.generatePlatforms();
  }

  // create platforms and coins based on face orientation
  generatePlatforms() {
    const cols = 4;
    const rows = 4;
    const spacing = (this.cubeSize - 60) / (cols - 1);

    for (let i = 0; i < cols; i++) {
      for (let j = 0; j < rows; j++) {
        let x = -this.cubeSize / 2 + 30 + i * spacing;
        let y = -this.cubeSize / 2 + 30 + j * spacing;
        let zOffset = this.cubeSize / 2 + 10;
        let pos;

        switch (this.faceID) {
          case 0: pos = createVector(x, y, zOffset); break;
          case 1: pos = createVector(-zOffset, y, -x); break;
          case 2: pos = createVector(-x, y, -zOffset); break;
          case 3: pos = createVector(zOffset, y, x); break;
          default: pos = createVector(0, 0, 0); break;
        }

        let plat = new Platform(pos, createVector(40, 10, 20));
        if (this.faceID === 1 || this.faceID === 3) {
          plat.setRotation(90);
        }
        this.platforms.push(plat);

        if ((i + j) % 2 === 0) {
          this.coins.push(new Coin(pos.copy().add(0, -30, 0)));
        }
      }
    }
  }

  // draw platforms and coins
  display() {
    for (let p of this.platforms) { p.display(); }
    for (let c of this.coins) { c.display(); }
  }
}
