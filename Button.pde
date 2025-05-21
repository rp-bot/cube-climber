class Button {
  String label;
  float x, y, w, h;

  // constructor to set label and position/dimensions, with offset on x and y
  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x + 50; // offset for placement
    this.y = y + 50;
    this.w = w;
    this.h = h;
  }

  // draw the button
  void display() {
    fill(255, 240);       // light fill
    stroke(0);            // black outline
    rect(x, y, w, h, 8);  // rounded rectangle
    fill(0);              // text color
    textAlign(CENTER, CENTER);
    text(label, x , y);   // draw label (may need adjustment to center text in box)
  }

  // check if mouse is over the button
  boolean isHovered() {
    return mouseX + 100 > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
