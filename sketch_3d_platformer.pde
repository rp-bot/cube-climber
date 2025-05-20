Cube cube;
Player player;
float camAngle = 0;
float targetAngle = 0;
float angleLerpSpeed = 0.1; // Adjust for smoother or quicker rotation
boolean moveLeft = false;
boolean moveRight = false;
GroundPlane ground;
int previousFace = -1;
float  groundLevelY;
 SkyCube sky;


void setup() {
  size(800, 800, P3D);
  sky = new SkyCube(5000);

  cube = new Cube(new PVector(0, 0, 0), 300);
  float faceOffset = cube.size / 2 + 10; // Z forward
  float halfHeight = 10;                 // half of player's height
  float groundY = cube.size / 2 - halfHeight;
  groundLevelY = cube.size / 2 - 10; // Same as earlier ground placement

  PVector startPos = new PVector(0, groundY, faceOffset);

  player = new Player(startPos);

  ground = new GroundPlane(2000, color(50, 50, 70));
  
  //cube.faces[0].platforms.clear(); // clear any auto platforms
  //cube.faces[0].platforms.add(
  //  new Platform(new PVector(0, 100, cube.size / 2 + 10), new PVector(80, 10, 20))
  //);
  //player = new Player(new PVector(0, 130, cube.size / 2 + 10)); 
}

void draw() {
  background(255, 230, 200); 
sky.display();
lights(); // after sky

  // Smoothly interpolate camera angle
  camAngle = lerpAngle(camAngle, targetAngle, angleLerpSpeed);

  // Set camera at a diagonal corner position, looking at cube center
  float r = 600;
  float angleY = radians(camAngle+45);
  float angleX = radians(0); // tilt slightly downward

  float camX = r * cos(angleY);
  float camZ = r * sin(angleY);
  float camY = r * sin(angleX);

  camera(
    camX, camY, camZ,
    0, 0, 0,
    0, 1, 0
  );

  ground.display();
  cube.display();
  player.display();
  
  if (moveLeft || moveRight) {
    float moveSpeed = 5;
    float moveDir = moveRight ? 1 : -1;
  
    float dx = moveSpeed * moveDir;
    float dy = 0;
  
    player.moveScreenRelative(dx, dy, cube.currentFace);
  }
  
  if (cube.currentFace != previousFace) {
    println("Switched to Face:", cube.currentFace);
    previousFace = cube.currentFace;
  }
  
  player.update(cube.faces[cube.currentFace].platforms, cube.currentFace);

}


boolean isColliding(PVector pos, Platform p, int faceID) {
  float px = pos.x, py = pos.y, pz = pos.z;
  float hx = p.size.x / 2, hy = p.size.y / 2, hz = p.size.z / 2;

  switch (faceID) {
    case 0: // Front: platforms extend in Z+
      return abs(px - p.position.x) < hx &&
             abs(py - p.position.y) < hy &&
             abs(pz - p.position.z) < hz + 1;

    case 1: // Right: platforms extend in X+
      return abs(pz - p.position.z) < hx &&
             abs(py - p.position.y) < hy &&
             abs(px - p.position.x) < hz + 1;

    case 2: // Back: platforms extend in Z-
      return abs(px - p.position.x) < hx &&
             abs(py - p.position.y) < hy &&
             abs(pz - p.position.z) < hz + 1;

    case 3: // Left: platforms extend in X-
      return abs(pz - p.position.z) < hx &&
             abs(py - p.position.y) < hy &&
             abs(px - p.position.x) < hz + 1;
  }

  return false;
}



float lerpAngle(float start, float end, float amt) {
  float diff = (end - start + 540) % 360 - 180;
  return (start + diff * amt) % 360;
}

void keyPressed() {
  if (key == 'j' || key == 'J') moveLeft = true;
  if (key == 'l' || key == 'L') moveRight = true;

  if (key == 'a' || key == 'A') {
    cube.rotateLeft();
    targetAngle = cube.getTargetAngle();
  }
  if (key == 'd' || key == 'D') {
    cube.rotateRight();
    targetAngle = cube.getTargetAngle();
  }
  
  if (key == ' ' && player.isGrounded) {
    player.velocity.y = -10; // jump impulse
  }

}

void keyReleased() {
  if (key == 'j' || key == 'J') moveLeft = false;
  if (key == 'l' || key == 'L') moveRight = false;
}
