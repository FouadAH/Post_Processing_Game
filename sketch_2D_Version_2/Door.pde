//Door class, determines if the player reached the end of the level
class Door extends Colliders{

  color c1 = color(0, 0, 0, 100),
        c2 = color(0, 255, 0, 100);
        
  boolean colliding = false; //true if player is touching the collider    
  
  Door(float x_, float y_) {
    x = x_;
    y = y_;
    w = 30;
    h = 60;
    gradient_collider = setGradient(0, 0, w, h, c2, c1);
  }

  
  //determines if player is touching the door
  void collition(Characters m) {
      if((m.position.x>= x && m.position.x<= x + w) && ( m.position.y >= y && m.position.y <= y+h)){
        colliding= true;
      }
      else colliding= false;
  }
  
 
  void display() {
    image(gradient_collider,x,y);
  }
  
}