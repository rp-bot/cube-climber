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
int score = 0;
PFont font;
boolean isPaused = false;
PGraphics menuOverlay;
PFont uiFont;
Button resumeBtn, restartBtn;
float musicVolume = 1.0;
float sfxVolume = 1.0;
Slider musicSlider, sfxSlider;


void setup() {
  size(800, 800, P3D);
  font = createFont("Arial", 24, true);
  uiFont = createFont("Arial", 18, true);
  resumeBtn = new Button("Resume", width/2 - 60, height/2 - 60, 120, 40);
  restartBtn = new Button("Restart", width/2 - 60, height/2 - 10, 120, 40);
  musicSlider = new Slider("Music Volume", width/2 - 60, height/2 + 50, 120, 1.0);
  sfxSlider = new Slider("SFX Volume", width/2 - 60, height/2 + 100, 120, 1.0);


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
  hint(DISABLE_DEPTH_TEST); // Overlay 2D HUD on top of 3D
  camera(); // reset 2D camera
  fill(0);
  textFont(font);
  textAlign(RIGHT, TOP);
  text("Coins: " + score + "/320", width - 20, 20);
  hint(ENABLE_DEPTH_TEST);
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
  
  player.update(cube.faces[cube.currentFace].platforms);

  if (moveLeft || moveRight) {
    float moveSpeed = 5;
    float moveDir = moveRight ? 1 : -1;
  
    float dx = 0;
    float dy = 0;
  
    switch (cube.currentFace) {
      case 0: // Front
        dx = moveSpeed * moveDir;
        break;
      case 1: // Right
        dx = -moveSpeed * moveDir; // Flip to preserve screen-relative motion
        break;
      case 2: // Back
        dx = -moveSpeed * moveDir;
        break;
      case 3: // Left
        dx = moveSpeed * moveDir;
        break;
    }
  
    player.moveScreenRelative(dx, dy, cube.currentFace);
  }

  
  player.display(); // draw after logic update
  
  if (cube.currentFace != previousFace) {
    println("Switched to Face:", cube.currentFace);
    previousFace = cube.currentFace;
  }
  
  // Check for coin collection
  ArrayList<Coin> coins = cube.faces[cube.currentFace].coins;
  for (Coin c : coins) {
    if (c.checkCollected(player.position)) {
      score += 10;
      println("Coin collected!");
    }
  }
  
  if (isPaused) {
    hint(DISABLE_DEPTH_TEST);
    camera();
    fill(0, 200);
    noStroke();
    rect(0, 0, width*2, height*2);
  
    textFont(uiFont);
    resumeBtn.display();
    restartBtn.display();
    musicSlider.update();
    sfxSlider.update();
    musicSlider.display();
    sfxSlider.display();
    
    musicVolume = musicSlider.value;
    sfxVolume = sfxSlider.value;
    hint(ENABLE_DEPTH_TEST);
    return; // Skip game updates
  }


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
  if (key == ESC) {
    key = 0; // prevent default behavior
    isPaused = !isPaused;
  }
  
  if (!isPaused) {
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
}

void mousePressed() {
  if (isPaused) {
    if (resumeBtn.isHovered()) isPaused = false;
    if (restartBtn.isHovered()) restartGame();
  }
}





void keyReleased() {
  if (key == 'j' || key == 'J') moveLeft = false;
  if (key == 'l' || key == 'L') moveRight = false;
}


void restartGame() {
  // Reset player, cube, score
  score = 0;
  cube = new Cube(new PVector(0, 0, 0), 300);
  player = new Player(new PVector(0, groundLevelY, cube.size/2 + 10));
}
