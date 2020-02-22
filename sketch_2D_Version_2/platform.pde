//platform class
class platform extends Colliders{
  
  color c2 = color(0,0,0,150),
        c1 = color(100,0,200,150);
        
  int axis;
  
  platform(float x_, float y_, float w_, float h_) {
    super.x = x_;
    super.y = y_;
    super.w = w_;
    super.h = h_;
    super.gradient_collider = setGradient(0, 0, w, h, c1, c2);
  }
 
   void collition(Characters m) {
      boolean Up = m.position.x + m.size.x> x && 
                   m.position.x< x + w && 
                   m.position.y + m.size.y +  m.velocity.y > y && 
                   m.position.y  < y ;
                   
      boolean RL =m.position.x + m.size.x + m.velocity.x > x && 
                  m.position.x + m.velocity.x < x + w && 
                  m.position.y + m.size.y > y+1 && 
                  m.position.y < y + h;
            
      boolean D = m.position.x + m.size.x> x && 
                  m.position.x< x + w && 
                  m.position.y +  m.velocity.y < y + h &&
                  m.position.y  > y + h;  
                  
      if(Up || RL || D) m.colliding = true;
      else m.colliding = false;
      
      if (Up){ 
            m.velocity.y *= 0;  
            m.position.y = y - m.size.y ;
      }
      
      if (RL){
             if( m.velocity.x>0)m.position.x = x - m.size.x ;
             else if( m.velocity.x<0)m.position.x = x + w  ;
             m.velocity.x *= -1;
      }
      
      if (D){
             m.velocity.y *= -1;
      }
  }
    
  
  void display(){
    stroke(128);
    image(gradient_collider,x,y);
    
  }
}
    