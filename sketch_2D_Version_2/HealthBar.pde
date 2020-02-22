//class for intitalizing, updating and displaying the health bar
float health;
float MAX_HEALTH = 100;
float rectW = 50;
float rectH = 5;
PVector position;
class HealthBar{
  
  HealthBar(float hp, PVector pos, PVector size){
    position = new PVector(pos.x-size.x/4,pos.y-10);
    health = hp;
    
  }
  
  void display(){
   if(health<100){
     
      if (health < 25) fill(255, 0, 0);
        
      else if (health < 50) fill(255, 200, 0);
      
      else fill(0, 255, 0);
      
      // Draw bar
      noStroke();
      
      float drawWidth = (health / MAX_HEALTH) * rectW;
      rect(position.x, position.y, drawWidth, rectH);
      
      // Outline
      stroke(0);
      noFill();
      rect(position.x, position.y, rectW, rectH);
    }
  }
  
}