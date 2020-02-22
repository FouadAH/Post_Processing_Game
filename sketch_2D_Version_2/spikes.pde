//spikes class

class spikes extends Colliders{

 color c1 = color(0, 0, 0),
       c2 = color(255, 0, 0,100);
        
  
  spikes(float x_, float y_, float w_, float h_) {
    super.x = x_;
    super.y = y_;
    super.w = w_;
    super.h = h_;
    super.gradient_collider = setGradient(0, 0, w, h, c2, c1);
    
  }

  void collition(Characters m) {
    if (m.position.x + m.size.x> x && 
        m.position.x< x + w && 
        m.position.y + m.size.y +  m.velocity.y > y && 
        m.position.y  < y ){ 
          m.hp=0;
    }
    
    if (m.position.x + m.size.x + m.velocity.x > x && 
        m.position.x + m.velocity.x < x + w && 
        m.position.y + m.size.y > y && 
        m.position.y < y + h){
          m.hp=0;
    }
    
    if (m.position.x + m.size.x> x && 
        m.position.x< x + w && 
        m.position.y +  m.velocity.y < y + h &&
        m.position.y  > y + h){
          m.hp=0;
    }
    
  }
  
  void display() {
    image(gradient_collider,x,y);
  }
}