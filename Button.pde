class Button {
  String label;
  float x, y, w, h;
  
  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x+50;
    this.y = y+50;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(255, 240);
    stroke(0);
    rect(x, y, w, h, 8);
    fill(0);
    textAlign(CENTER, CENTER);
    text(label, x , y);
  }

  boolean isHovered() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
