/**
 * ===========================
 * Cube Climber - Controls Guide
 * ===========================
 * 
 * Keyboard Controls:
 * ------------------
 * J key        - Move Left
 * L key        - Move Right
 * A key        - Rotate Cube Left
 * D key        - Rotate Cube Right
 * SPACEBAR     - Jump (only if player is grounded)
 * ESC key      - Pause/Resume the game
 * 
 * Mouse Controls:
 * ----------------
 * Click on buttons (Resume, Restart) in the pause or end menus
 * Use sliders to adjust music and sound effect volume
 *
 * Objective:
 * -----------
 * Collect all 32 coins (10 points each = 320 total) before time runs out.
 * Rotate the cube and navigate all faces to win!
 */
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
float musicVolume = 0.5;
float sfxVolume = 1.0;
Slider musicSlider, sfxSlider;
AudioManager audio;
Sample coinSample, jumpSample;
int totalTime = 180000; // 3 minutes in milliseconds
int startTime;
boolean isGameOver = false;
int pauseStartTime = 0;
int totalPausedTime = 0;
boolean isWin = false;
int winTime = 0;
int starsEarned = 0;
PImage customCursor;

void setup() {
  size(800, 800, P3D);
  customCursor = loadImage("coin.png");
  customCursor.resize(32, 32); // Resize to 16x16 pixels
  cursor(customCursor, 0, 0); 
  font = createFont("Arial", 24, true);
  uiFont = createFont("Arial", 18, true);
  resumeBtn = new Button("Resume", width/2 - 60, height/2 - 60, 120, 40);
  restartBtn = new Button("Restart", width/2 - 60, height/2 - 10, 120, 40);
  musicSlider = new Slider("Music Volume", width/2 - 60, height/2 + 50, 120, 0.5);
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
  audio = new AudioManager(musicVolume, sfxVolume);
  try {
    String coinPath = sketchPath("coin.wav");
    coinSample = new Sample(coinPath);
  } catch (Exception e) {
    println("Error loading coin.wav: " + e.getMessage());
    e.printStackTrace();
    exit();
  }
  
  try {
    jumpSample = new Sample(sketchPath("jump.wav"));
  } catch (Exception e) {
    println("Failed to load jump.wav: " + e.getMessage());
  }
  
  startTime = millis();

}

void draw() {
  background(255, 230, 200); 
  sky.display();
  lights();
  ambientLight(80, 80, 80); // soft global light
  directionalLight(255, 255, 255, -0.5, 2, -0.5); // key light
  //directionalLight(255, 255, 255, 0.5, 1, 0.5); // key light

  hint(DISABLE_DEPTH_TEST); // Overlay 2D HUD on top of 3D
  camera(); // reset 2D camera
  fill(0);
  textFont(font);
  textAlign(RIGHT, TOP);
  text("Coins: " + score + "/320", width - 20, 20);
  hint(ENABLE_DEPTH_TEST);
  // Smoothly interpolate camera angle
  camAngle = lerpAngle(camAngle, targetAngle, angleLerpSpeed);
  
  // Calculate remaining time
  int elapsed = (millis() - totalPausedTime) - startTime;
  int remaining = max(0, totalTime - elapsed);
  float barWidth = map(remaining, 0, totalTime, 0, width*2);
  
  // Time bar
  noStroke();
  fill(255, 100, 100);
  rect(0, 0, barWidth, 10);
  
  // Optional: show numeric countdown
  fill(0);
  textAlign(LEFT, TOP);
  textFont(font);
  text(nf(remaining / 1000 / 60, 2) + ":" + nf((remaining / 1000) % 60, 2), 10, 12);

  
  if (audio != null) { // Good practice to check if audio is initialized
      audio.adjustTempoAndKey(remaining);
  }
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
      audio.playSFX(coinSample);

      println("Coin collected!");
    }
  }
  
  if (remaining == 0 && !isGameOver) {
    isGameOver = true;
    isPaused = false; // Ensure pause doesn't overlap
  }
  
  
  if (isPaused || isGameOver || isWin) {
    audio.stopMusic();
  } else {
    audio.resumeMusic();
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
    audio.updateVolumes(musicVolume, sfxVolume);
    // audio.adjustTempoAndKey(remaining); // REMOVE FROM HERE

    hint(ENABLE_DEPTH_TEST);
    return; // Skip game updates
}


  if (isWin) {
    hint(DISABLE_DEPTH_TEST);
    camera();
    fill(0, 220);
    noStroke();
    rect(0, 0, width*2, height*2);
  
    textFont(uiFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text("You Win!", width/2, height/2 - 100);
  
    // Draw stars
    float starSize = 30;
    float startX = width/2 - starSize * 2;
    for (int i = 0; i < 3; i++) {
      if (i < starsEarned) {
        fill(255, 204, 0); // Yellow
      } else {
        fill(100); // Gray
      }
      drawStar(startX + i * starSize * 2, height/2 - 30, starSize);
    }
  
    restartBtn.display();
    hint(ENABLE_DEPTH_TEST);
    return;
  }

  if (isGameOver) {
    hint(DISABLE_DEPTH_TEST);
    camera();
    fill(0, 220);
    noStroke();
    rect(0, 0, width*2, height*2);
  
    textFont(uiFont);
    fill(255);
    textAlign(CENTER, CENTER);
    text("Game Over", width/2, height/2 - 80);
  
    restartBtn.display();
  
    hint(ENABLE_DEPTH_TEST);
    return;
  }

  if (score >= 320 && !isWin) { // Assuming 320 coins max * 10 points each
    isWin = true;
    isPaused = false;
    isGameOver = false;
    winTime = (millis() - totalPausedTime) - startTime;
  
    // Star calculation
    if (winTime <= 60000) {
      starsEarned = 3;
    } else if (winTime <= 120000) {
      starsEarned = 2;
    } else {
      starsEarned = 1;
    }
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
    key = 0;
    isPaused = !isPaused;
  
    if (isPaused) {
      pauseStartTime = millis(); // record when pause started
    } else {
      totalPausedTime += millis() - pauseStartTime; // accumulate pause duration
    }
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
      player.velocity.y = -10;
      if (jumpSample != null) audio.playSFX(jumpSample);
    }

  }
}

void mousePressed() {
  if (isPaused) {
    if (resumeBtn.isHovered()) isPaused = false;
    if (restartBtn.isHovered()) restartGame();
  } else if (isGameOver) {
    if (restartBtn.isHovered()) restartGame();
  }else if (isWin) {
  if (restartBtn.isHovered()) restartGame();
}

}


void drawStar(float x, float y, float radius) {
  float angle = TWO_PI / 5;
  float halfAngle = angle / 2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
    sx = x + cos(a + halfAngle) * radius / 2;
    sy = y + sin(a + halfAngle) * radius / 2;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void drawDisc(float r, float thickness) {
  int sides = 30;
  float angleStep = TWO_PI / sides;

  // Top face
  beginShape(TRIANGLE_FAN);
  vertex(0, -thickness/2, 0);
  for (int i = 0; i <= sides; i++) {
    float angle = i * angleStep;
    vertex(cos(angle) * r, -thickness/2, sin(angle) * r);
  }
  endShape();

  // Bottom face
  beginShape(TRIANGLE_FAN);
  vertex(0, thickness/2, 0);
  for (int i = 0; i <= sides; i++) {
    float angle = -i * angleStep;
    vertex(cos(angle) * r, thickness/2, sin(angle) * r);
  }
  endShape();

  // Side wall (optional, flat coin effect)
  beginShape(QUAD_STRIP);
  for (int i = 0; i <= sides; i++) {
    float angle = i * angleStep;
    float x = cos(angle) * r;
    float z = sin(angle) * r;
    vertex(x, -thickness/2, z);
    vertex(x, thickness/2, z);
  }
  endShape();
}



void keyReleased() {
  if (key == 'j' || key == 'J') moveLeft = false;
  if (key == 'l' || key == 'L') moveRight = false;
}


void restartGame() {
  score = 0;
  cube = new Cube(new PVector(0, 0, 0), 300);
  player = new Player(new PVector(0, groundLevelY, cube.size/2 + 10));
  startTime = millis(); // Reset timer
  isPaused = false;
  isGameOver = false;
  isWin=false;
}
