class Button {
  // constructor to set label and position/dimensions
  constructor(label, x, y, w, h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  // draw the button on a given graphics buffer (hud)
  display(hud) {
    hud.push(); // Use push/pop to isolate drawing styles
    hud.fill(255, 240);    // light fill
    hud.stroke(0);        // black outline
    hud.rect(this.x, this.y, this.w, this.h, 8); // rounded rectangle
    hud.fill(0);          // text color
    hud.textAlign(CENTER, CENTER);
    hud.textSize(18);
    // Draw text in the center of the button
    hud.text(this.label, this.x + this.w / 2, this.y + this.h / 2);
    hud.pop();
  }

  // check if mouse is over the button
  isHovered() {
    // Note: mouseX and mouseY are relative to the main canvas (800x800)
    return mouseX > this.x && mouseX < this.x + this.w && 
           mouseY > this.y && mouseY < this.y + this.h;
  }
}
