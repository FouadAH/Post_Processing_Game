//Projectile class
class Projectile {
  color c;
  float speed = 3;
  boolean colliding;
  PVector position = new PVector( 0, 0),
          towards,
          velocity = new PVector( 0, 0),
          size = new PVector(5, 5);
          
  Projectile(PVector _position, PVector _towards, color _c){
    c = _c;
    position = _position;
    towards  = _towards;
    float angle = atan2( towards.y-position.y, towards.x-position.x);
    velocity.x=speed*cos(angle);
    velocity.y=speed*sin(angle);
  }
  
  void display(){
    fill(c);
    ellipse(position.x, position.y, size.x, size.y);
  }
  
  
  void update() {
    position.add(velocity);
  }
  
  //returns true if colliding with an object of type collider
  void collide(Colliders c){
     boolean Up = position.x + size.x>c.x&& 
                     position.x<c.x+ c.w && 
                     position.y + size.y +  velocity.y >c.y&& 
                     position.y  <c.y;
                   
      boolean RL =position.x + size.x + velocity.x >c.x&& 
                  position.x + velocity.x <c.x+ c.w && 
                  position.y + size.y > c.y+1 && 
                  position.y <c.y+ c.h;
            
      boolean D = position.x + size.x>c.x&& 
                  position.x<c.x+ c.w && 
                  position.y +  velocity.y <c.y+ c.h &&
                  position.y  >c.y+ c.h; 
                  
      if(Up || RL || D) colliding = true;
  }
  
  //check if projectile hits a character
  void check_hit(Characters c){
    if((position.x>= c.position.x && position.x<= c.position.x+ c.size.x) && (position.y >= c.position.y && position.y <= c.position.y+c.size.y)){
      c.hp-=10;
      colliding= true;
    }
  }
  
  void checkEdges() {
    if (position.y > height || position.x > width || position.y  < 0 || position.x  < 0) {
      colliding = true;
    }
  }
  
}