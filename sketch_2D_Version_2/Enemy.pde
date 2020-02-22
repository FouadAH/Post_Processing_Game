//Enemy class 
class Enemy extends Characters{  
  
  ArrayList<Projectile> Projectiles= new ArrayList<Projectile>(); //array list of projectiles
  
  float radius = 150, //determines the radius in which the player will be spotted
        speed = 0.2;  //speed of the enemy
  
  PVector movementF = new PVector(speed, 0);  //move right
  PVector movementB = new PVector(-speed, 0); //move left
  
  boolean sight; //true if spotted the player
  
  float time_1; //time since last fired a projectile
  boolean firing =false; // true if fired a projectile
      
  Enemy(float x, float y) {
    super.hp=100;
    super.intialx = x;
    super.intialy = y;
    super.position = new PVector(x, y);
    super.velocity = new PVector(0, 0);
    super.acceleration = new PVector(0, 0);
    super.gravity = new PVector(0,0.15*mass);
    super.size = new PVector(25, 25);
    super.hpBar = new HealthBar(hp,position,size); 
  }
  

  
  void respawn(){
    hp=100;
    position = new PVector(intialx, intialy);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    
  }

  // Newton's 2nd law: F = M * A
  // or A = F / M
  void applyForce(PVector force) {
    // Divide by mass 
    PVector f = PVector.div(force, mass);
    // Accumulate all forces in acceleration
    acceleration.add(f);
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
  
  void update() {
    
    //fire every second
    timer(firing, time_1, 1000);
    
    //friction force
    friction = new PVector(velocity.x*(-1)*0.1, 0);
    
    applyForce(gravity);
    
    applyForce(friction);
    
    // Velocity changes according to acceleration
    velocity.add(acceleration);
    
    // position changes by velocity
    position.add(velocity);
    
    // We clear acceleration each frame
    acceleration.mult(0);
    
    hpBar = new HealthBar(hp,position,size);
  }
  
  void display() {
    fill(150,0,0);
    rect(position.x, position.y, size.x, size.y);
    hpBar.display();
  }
  
  //determines if the enemy should move right or left
  boolean movingB =true, movingF= false;
  void Movement(boolean grid[][]){
    
    int i =(int)(position.x + size.x/4)/spacing;
    int j = (int)(position.y)/spacing;
    
    //check collition with the edges of the window
    checkEdges();
    
    //move left
    if(i+1 > rows || (grid[i+1][j]==true  || grid[i+1][j+1]==false) && movingF && j+1 != cols){
      velocity.x*=-1;
      movingB=true;
      movingF=false; 
    }
    //move right
    else if(i -1< 0 || (grid[i-1][j]==true || grid[i][j+1]==false)  && movingB && j+1 != cols){
      movingB=false;
      movingF=true; 
    }
    //apply movement
    if(movingF && !sight){
      applyForce(movementF);
    }
    else if(movingB && !sight){
      applyForce(movementB);
    }
  }
  
  //check if the player is within the radius
  void checkSight(Characters c) {
       sight=sq(c.position.x - position.x) + sq(c.position.y - position.y) <= radius*radius;
       if(sight){
         Fire(c);
       }
  }
  
  //fire at the player
  void Fire(Characters c){
      if(firing){
        firing =false;
        rX = position.x + size.x/2;
        rY = position.y + size.y/2;
        Projectiles.add(new Projectile(new PVector(rX, rY), new PVector(c.position.x + c.size.x/2, c.position.y + c.size.y/2), color(100,0,0)));
      }
  }

  //check collition with the edges of the window
  void checkEdges() {
    if (position.y + size.y > height ) {
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