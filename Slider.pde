class Slider {
  String label;
  float x, y, w;
  float value; // 0.0 to 1.0

  Slider(String label, float x, float y, float w, float initialValue) {
    this.label = label;
    this.x = x-20;
    this.y = y+50;
    this.w = w;
    this.value = initialValue;
  }

  void display() {
    fill(255);
    textAlign(LEFT, CENTER);
    text(label + " " + int(value * 100) + "%", x, y - 10);

    stroke(0);
    line(x, y+10, x + w, y+10);
    float handleX = x + value * w;
    fill(100);
    ellipse(handleX, y+10, 20, 20);
  }

  boolean isDragging() {
    return mousePressed && mouseX >= x && mouseX <= x + w && abs(mouseY - y) < 20;
  }

  void update() {
    if (isDragging()) {
      value = constrain((mouseX - x) / w, 0, 1);
    }
  }
}
