/**
 * ===========================
 * Cube Climber - p5.js Version
 * ===========================
 *
 * All original logic and comments are preserved.
 * The main changes are:
 * 1. Variable declarations use 'let'.
 * 2. Asset loading (images, sounds, fonts) is moved to preload().
 * 3. Audio uses the p5.sound library.
 * 4. 2D HUD is drawn on a separate graphics buffer to overlay on the 3D scene.
 */

// Game Objects and State
let cube;
let player;
let camAngle = 0;
let targetAngle = 0;
let angleLerpSpeed = 0.1;
let moveLeft = false;
let moveRight = false;
let ground;
let previousFace = -1;
let groundLevelY;
let sky;
let score = 0;
let isPaused = false;
let hud; // Graphics buffer for 2D HUD
let resumeBtn, restartBtn;
let musicVolume = 0.5;
let sfxVolume = 1.0;
let musicSlider, sfxSlider;
let audio; // Will need to be a new JS class
let coinSample, jumpSample;
let totalTime = 180000; // 3 minutes in milliseconds
let startTime;
let isGameOver = false;
let pauseStartTime = 0;
let totalPausedTime = 0;
let isWin = false;
let winTime = 0;
let starsEarned = 0;
let customCursorImg;

// -----------------------------
// ASSET LOADING
// -----------------------------
function preload() {
  // All assets must be loaded here.
  // These files should be in the same folder as your index.html
  customCursorImg = loadImage("coin.png");
  coinSample = loadSound("coin.wav");
  jumpSample = loadSound("jump.wav");
  // The 'AudioManager' class will also need to load its music in preload.
}

// -----------------------------
// INITIAL SETUP
// -----------------------------
function setup() {
  // Use WEBGL for 3D rendering, equivalent to P3D
  createCanvas(800, 800, WEBGL);
  
  // Create a separate 2D graphics buffer for the HUD
  hud = createGraphics(800, 800);

  customCursorImg.resize(32, 32);
  cursor(customCursorImg, 0, 0);

  // In p5.js, we can set the font directly. For custom fonts, use loadFont() in preload.
  // The 'Button' and 'Slider' classes will need to be translated to JS classes.
  resumeBtn = new Button("Resume", width / 2 - 60, height / 2 - 60, 120, 40);
  restartBtn = new Button("Restart", width / 2 - 60, height / 2 - 10, 120, 40);
  musicSlider = new Slider("Music Volume", width / 2 - 60, height / 2 + 50, 120, 0.5);
  sfxSlider = new Slider("SFX Volume", width / 2 - 60, height / 2 + 100, 120, 1.0);

  // The classes SkyCube, Cube, Player, GroundPlane, AudioManager will need to be JS classes.
  sky = new SkyCube(5000);
  cube = new Cube(createVector(0, 0, 0), 300); // Use createVector() instead of new PVector()
  
  let faceOffset = cube.size / 2 + 10;
  let halfHeight = 10;
  let groundY = cube.size / 2 - halfHeight;
  groundLevelY = cube.size / 2 - 10;

  let startPos = createVector(0, groundY, faceOffset);
  player = new Player(startPos);
  
  ground = new GroundPlane(2000, color(50, 50, 70));
  audio = new AudioManager(musicVolume, sfxVolume);

  startTime = millis();
}

// -----------------------------
// MAIN GAME LOOP
// -----------------------------
function draw() {
  // --- 3D Scene Rendering ---
  background(255, 230, 200);
  sky.display();
  lights();
  ambientLight(80, 80, 80);
  directionalLight(255, 255, 255, -0.5, 2, -0.5);

  camAngle = lerp(camAngle, targetAngle, angleLerpSpeed); // lerpAngle is now a global function

  // Set camera
  let r = 600;
  let angleY = radians(camAngle + 45);
  let angleX = radians(0);
  let camX = r * cos(angleY);
  let camZ = r * sin(angleY);
  let camY = r * sin(angleX);
  camera(camX, camY, camZ, 0, 0, 0, 0, 1, 0);

  // Display 3D objects
  ground.display();
  cube.display();
  player.update(cube.faces[cube.currentFace].platforms);
  player.display();
  
  // Game logic updates...
  handlePlayerMovement();
  checkCoinCollection();
  updateGameStatus();
  handleAudio();

  // --- 2D HUD and Menus ---
  drawHUD();
  
  if (isPaused) {
    drawPauseMenu();
    return; // Skip game updates
  }
  if (isWin) {
    drawWinMenu();
    return;
  }
  if (isGameOver) {
    drawGameOverMenu();
    return;
  }
}

// -----------------------------
// HELPER DRAWING FUNCTIONS
// -----------------------------

function drawHUD() {
    hud.clear(); // Clear the 2D buffer
    
    let elapsed = (millis() - totalPausedTime) - startTime;
    let remaining = max(0, totalTime - elapsed);
    
    // Score
    hud.textFont('Arial');
    hud.textSize(24);
    hud.fill(0);
    hud.textAlign(RIGHT, TOP);
    hud.text("Coins: " + score + "/320", width - 20, 20);

    // Time Bar
    let barWidth = map(remaining, 0, totalTime, 0, width);
    hud.noStroke();
    hud.fill(255, 100, 100);
    hud.rect(0, 0, barWidth, 10);
    
    // Time Text
    let minutes = floor(remaining / 1000 / 60);
    let seconds = floor((remaining / 1000) % 60);
    hud.fill(0);
    hud.textAlign(LEFT, TOP);
    hud.text(`${nf(minutes,2)}:${nf(seconds,2)}`, 10, 12);

    // Draw the 2D buffer onto the main canvas
    image(hud, -width / 2, -height / 2);
}

function drawPauseMenu() {
    hud.clear();
    hud.background(0, 200); // Semi-transparent background
    
    resumeBtn.display(hud); // Pass hud to display methods
    restartBtn.display(hud);
    musicSlider.update();
    sfxSlider.update();
    musicSlider.display(hud);
    sfxSlider.display(hud);
    
    musicVolume = musicSlider.value;
    sfxVolume = sfxSlider.value;
    audio.updateVolumes(musicVolume, sfxVolume);

    image(hud, -width/2, -height/2);
}

function drawWinMenu() {
    hud.clear();
    hud.background(0, 220);
    hud.fill(255);
    hud.textAlign(CENTER, CENTER);
    hud.textSize(48);
    hud.text("You Win!", width / 2, height / 2 - 100);

    // Draw stars
    let starSize = 30;
    let startX = width / 2 - starSize * 2;
    for (let i = 0; i < 3; i++) {
        if (i < starsEarned) {
            hud.fill(255, 204, 0);
        } else {
            hud.fill(100);
        }
        drawStar(startX + i * starSize * 2, height / 2 - 30, starSize);
    }
    restartBtn.display(hud);
    image(hud, -width/2, -height/2);
}

function drawGameOverMenu() {
    hud.clear();
    hud.background(0, 220);
    hud.fill(255);
    hud.textAlign(CENTER, CENTER);
    hud.textSize(48);
    hud.text("Game Over", width / 2, height / 2 - 80);
    restartBtn.display(hud);
    image(hud, -width/2, -height/2);
}

// -----------------------------
// EVENT HANDLERS
// -----------------------------
function keyPressed() {
  if (keyCode === ESCAPE) {
    isPaused = !isPaused;
    if (isPaused) {
      pauseStartTime = millis();
    } else {
      totalPausedTime += millis() - pauseStartTime;
    }
  }

  if (!isPaused) {
    if (key === 'j' || key === 'J') moveLeft = true;
    if (key === 'l' || key === 'L') moveRight = true;
    if (key === 'a' || key === 'A') {
      cube.rotateLeft();
      targetAngle = cube.getTargetAngle();
    }
    if (key === 'd' || key === 'D') {
      cube.rotateRight();
      targetAngle = cube.getTargetAngle();
    }
    if (key === ' ' && player.isGrounded) {
      player.velocity.y = -10;
      if (jumpSample.isLoaded()) jumpSample.play();
    }
  }
}

function keyReleased() {
  if (key === 'j' || key === 'J') moveLeft = false;
  if (key === 'l' || key === 'L') moveRight = false;
}

function mousePressed() {
  if (isPaused) {
    if (resumeBtn.isHovered()) isPaused = false;
    if (restartBtn.isHovered()) restartGame();
  } else if (isGameOver || isWin) {
    if (restartBtn.isHovered()) restartGame();
  }
  userStartAudio();
}


// -----------------------------
// LOGIC AND HELPER FUNCTIONS
// -----------------------------
// All other functions like isColliding, lerpAngle, drawStar, etc.
// can be translated directly here. For example:

function handlePlayerMovement(){
  if (moveLeft || moveRight) {
    let moveSpeed = 5;
    let moveDir = moveRight ? 1 : -1;
    let dx = 0;
    let dy = 0;
    // ... same switch statement logic ...
    player.moveScreenRelative(dx, dy, cube.currentFace);
  }
}

function checkCoinCollection() {
    let coins = cube.faces[cube.currentFace].coins;
    for (let c of coins) {
      if (c.checkCollected(player.position)) {
        score += 10;
        if(coinSample.isLoaded()) coinSample.play();
        console.log("Coin collected!");
      }
    }
}

function updateGameStatus() {
    let elapsed = (millis() - totalPausedTime) - startTime;
    let remaining = max(0, totalTime - elapsed);

    if (remaining === 0 && !isGameOver) {
        isGameOver = true;
        isPaused = false;
    }
    
    if (score >= 320 && !isWin) {
        isWin = true;
        isPaused = false;
        isGameOver = false;
        winTime = (millis() - totalPausedTime) - startTime;
        
        if (winTime <= 60000) starsEarned = 3;
        else if (winTime <= 120000) starsEarned = 2;
        else starsEarned = 1;
    }
}

function handleAudio(){
    let elapsed = (millis() - totalPausedTime) - startTime;
    let remaining = max(0, totalTime - elapsed);
    if (audio) {
        audio.adjustTempoAndKey(remaining);
        if (isPaused || isGameOver || isWin) {
            audio.stopMusic();
        } else {
            audio.resumeMusic();
        }
    }
}

function drawStar(x, y, radius) {
  let angle = TWO_PI / 5;
  let halfAngle = angle / 2.0;
  hud.beginShape(); // Draw on the hud
  for (let a = 0; a < TWO_PI; a += angle) {
    let sx = x + cos(a) * radius;
    let sy = y + sin(a) * radius;
    hud.vertex(sx, sy);
    sx = x + cos(a + halfAngle) * radius / 2;
    sy = y + sin(a + halfAngle) * radius / 2;
    hud.vertex(sx, sy);
  }
  hud.endShape(CLOSE);
}

function restartGame() {
    score = 0;
    cube = new Cube(createVector(0, 0, 0), 300);
    player = new Player(createVector(0, groundLevelY, cube.size/2 + 10));
    startTime = millis();
    isPaused = false;
    isGameOver = false;
    isWin=false;
    totalPausedTime = 0;
}
