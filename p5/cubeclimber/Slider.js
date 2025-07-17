class Slider {
  constructor(label, x, y, w, initialValue) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.value = initialValue; // 0.0 to 1.0
  }

  display(hud) {
    hud.push();
    hud.textAlign(LEFT, CENTER);
    hud.fill(255);
    hud.stroke(0);
    hud.strokeWeight(1);
    hud.text(this.label + " " + int(this.value * 100) + "%", this.x, this.y - 15);

    hud.strokeWeight(2);
    hud.line(this.x, this.y, this.x + this.w, this.y);
    
    let handleX = this.x + this.value * this.w;
    hud.fill(100);
    hud.stroke(255);
    hud.ellipse(handleX, this.y, 20, 20);
    hud.pop();
  }

  isDragging() {
    return mouseIsPressed && mouseX >= this.x && mouseX <= this.x + this.w && abs(mouseY - this.y) < 20;
  }

  update() {
    if (this.isDragging()) {
      this.value = constrain((mouseX - this.x) / this.w, 0, 1);
    }
  }
}
