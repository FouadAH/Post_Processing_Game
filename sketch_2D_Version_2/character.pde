//player character class
class character extends Characters{
  ArrayList<Projectile> Projectiles= new ArrayList<Projectile>() ; 
  PVector movement;
  
  boolean counter = true,
          attacking=false,
          firing =false,
          jumping = true,    //true if jumping
          moving = false;    //true if moving
          
  boolean hit;
  
  boolean letDash, 
          let_fire=true,
          let_attack;
          
  float radius=50;
  float speed = 0.5;
  
   
  float time_1,
        time_2,
        time_4, //fire time
        time_5, //attack time
        time_3; //dash time
    
  character(float x, float y) {
    super.hp =100;
    super.intialx = x;
    super.intialy = y;
    super.position = new PVector(x, y);
    super.velocity = new PVector(0, 0);
    super.acceleration = new PVector(0, 0);
    super.gravity = new PVector(0,0.15*mass);
    super.hpBar = new HealthBar(hp,position,size); 
  }
  
  void timer_fire(){
    if(!firing){
      if (millis() - time_4 >= 250){
        firing=true;
        time_4 = millis();
      }
    }
  }
  
  void timer_attack(){
    if(!attacking){
      if (millis() - time_5 >= 500){
        attacking=true;
        time_5 = millis();
      }
    }
  }
   
  void checkDash(){
    if(!letDash){
      if (millis() - time_3 >= 2000){
          letDash=true;
          time_3 = millis();
      }
    }
  }
  
  void fire(){
    if(firing){
      firing =false;
      rX = position.x + size.x/2;
      rY = position.y + size.y/2;
      Projectiles.add(new Projectile(new PVector(rX, rY), new PVector(mouseX, mouseY), color(0)));
    }
  }
  
  void checkJump(){
   if( velocity.y == 0) jumping = false; 
   else jumping = true;
  }
  
  void respawn(){
    position = new PVector(intialx, intialy);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void death(){
    if(hp<=0) {
      hp=100;
      deathCount++;
      println("You Died. Death Count: "+deathCount );
      respawn();
    }
  }

  // Newton's 2nd law: F = M * A
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
  }
  
  void update() {
    
    timer_fire();
    timer_attack();
    
    if(moving)movement = new PVector(speed, 0);
    
    friction = new PVector(velocity.x*(-1)*0.1, 0);
    
    applyForce(gravity);
    
    if(moving)applyForce(movement);
    
    applyForce(friction);
    
    //Velocity changes according to acceleration
    velocity.add(acceleration);
    
    //position changes by velocity
    position.add(velocity);
    
    //clear acceleration each frame
    acceleration.mult(0);
    
    hpBar = new HealthBar(hp,new PVector(50,height-10),size);
    death();
    hpBar.display();
  }
  
  void display_dash(){
    fill(255);
    rect(position.x, position.y+size.y/8, size.x, size.y*0.75);
  }
  
  void display() {
    fill(255);
    
    time_1 = millis();
    
    if(time_1<time_2){
     display_dash(); 
    }
    
    else rect(position.x, position.y, size.x, size.y);
    
    noFill(); 
    strokeWeight(5);
    
    rX = position.x + size.x/2;
    rY = position.y + size.y/2;
    float angle = atan2( mouseY-rY, mouseX-rX);
    
    if(let_fire){
      stroke(0,0,128,100);
      arc(rX, rY, size.x*2, size.y*2, angle-QUARTER_PI, angle+QUARTER_PI);
    }
    if(let_attack){
      if(attacking)stroke(128,0,0,100);
      else stroke(0,128,0,100);
      arc(rX, rY, size.x*2, size.y*2, angle-PI, angle+TWO_PI);
    }
    
    strokeWeight(1);
  }
  
  void attack(Characters c) {
      if(sq(c.position.x - position.x) + sq(c.position.y - position.y) <= radius*radius  && attacking){
        attacking=false;
        if(c.position.x>position.x)c.velocity.x +=  2;
        if(c.position.x<position.x)c.velocity.x += -2;
        c.hp-=10;
      }
  }

  // Bounce off edges of window
  void checkEdges() {
    if (position.y + size.y > height ) {
      jumping=false;
      velocity.y *= -0.1;  
      position.y = height - size.y;
    }
    if (position.x + size.x > width) {
      velocity.x *= -0.1;  
      position.x = width - size.x;
    }
    if (position.y  < 0) {
      velocity.y *= -0.1;  
      position.y = 0;
    }
    if (position.x  < 0) {
      velocity.x *= -0.1;  
      position.x = 0;
    }
  }
    
}