//Parent class of moving objects enemy and character 
class Characters{
  
  float intialx,intialy; //initial coordinates 
  float rX, rY; //center point of the character
  
  PVector gravity; //gravity force
  
  boolean colliding =false;
  
  PVector friction,
          position,
          velocity,
          acceleration,
          size = new PVector(25, 25);
          
  float lift = -7.5, //determines jump amount
        mass = 1.5;
        
  HealthBar hpBar; 
  
  int hp;

  void respawn(){}

  // Newton's 2nd law: F = M * A
  void applyForce(PVector force) {
  }
  
  void update() {
  }
  
  void display() {
  }
  
  // Bounce off edges of window
  void checkEdges() {
  }
  
  //timer funtion that sets a boolean to true after a certain time
  //time :elapsed time
  //timer:time before boolean is true
  void timer(boolean b, float time, float timer){
    if(!b){
      if (millis() - time >= timer){
          b=true;
          time = millis();
      }
    }
    
  }
}