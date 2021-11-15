class Ring {
  float x, y;          // X-coordinate, y-coordinate
  float diameter;      // Diameter of the ring
  boolean on = false;  // Turns the display on and off

  float sWeight =0.5;


  void start(float xpos, float ypos) {
    x = xpos;
    y = ypos;

    diameter = random (1,50);
    on = true;
  }

  void grow() {
    if (on == true) {
      diameter += 1;
      sWeight += 0.01;

      if (diameter > 300) {
        on = false;
        diameter = 0.1;
      }
    }
  }

  void display() {
    if (on == true) {
      noFill();
      strokeWeight(sWeight);
      stroke(random(255), random(255), random(255), 80 );
      ellipse(x, y, diameter, diameter);
    }
  }
}
