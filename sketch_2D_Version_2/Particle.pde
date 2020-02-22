//Particle class

class Particle {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  Particle(PVector l) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    position = l.copy();
    lifespan = 200.0;
  }

  void run() {
    update();
    display();
  }

  //update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 10.0;
  }

  //display
  void display() {
    stroke(0, lifespan);
    fill(0, lifespan);
    ellipse(position.x, position.y, 2, 2);
  }

  // check if particle is still in use
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}