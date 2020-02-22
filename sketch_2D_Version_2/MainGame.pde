//class for running the game
class MainGame extends State{
  
  boolean Up,Dash,Left,Right,Down;
  
  boolean grid[][] = new boolean [ceil(rows)+1][ceil(cols)+1];
  
  ParticleSystem ps= new ParticleSystem(new PVector(width/2, 50));
  
  
  void setup(){
    clear();
    noCursor();
    for(int i =0; i<rows;i++){
        for(int j =0; j<cols;j++){
          grid[i][j]=false;
        }
    } 
    
    for(int c = 0; c < Colliders.size(); c++){
      
      int maxi = (int)constrain(Colliders.get(c).x/spacing+Colliders.get(c).w/spacing, 0, width/spacing);
      int maxj = (int)constrain(Colliders.get(c).y/spacing+Colliders.get(c).h/spacing, 0, height/spacing);
      
      for(int i = (int)constrain(Colliders.get(c).x/spacing, 0, width/spacing); i < maxi  ; i++){
         for(int j = (int)constrain(Colliders.get(c).y/spacing, 0, height/spacing); j < maxj; j++){
           grid[i][j]=true;
         }
      }
   }
   main.respawn();
   
  }
  
  
  void draw(){
      
      image(Game_background,0,0);
      
      smooth();
      //diplay the frame rate
      if((int)frameRate>50){
        fill(0,255,0);
      }
      else if((int)frameRate<=50 && (int)frameRate>=30 ){
        fill(255,255,0);
      }
      else fill(255,0,0);
      
      text(""+(int)frameRate,5,0,25,25);
      
      //display the death count
      fill(0);
      text("Deaths: "+deathCount,25,0,150,30);
      
      fill(255);
      ellipse(mouseX,mouseY,5,5);
      
      // Check for colliton 
      for(int i = 0; i < Colliders.size(); i++){
        
          //check player collition
          Colliders.get(i).collition(main);
          
          //check enemy collition
          if(!Enemies.isEmpty()){
            
            for(int j = 0; j < Enemies.size(); j++){
              Colliders.get(i).collition(Enemies.get(j));
              
              if(!Enemies.get(j).Projectiles.isEmpty()){
                
                //check enemy projectiles collition
                for(int g = 0; g < Enemies.get(j).Projectiles.size(); g++){
                  Enemies.get(j).Projectiles.get(g).collide(Colliders.get(i));
                  
                  if(Enemies.get(j).Projectiles.get(g).colliding){
                    ps.addParticle(new PVector(Enemies.get(j).Projectiles.get(g).position.x, Enemies.get(j).Projectiles.get(g).position.y));
                    Enemies.get(j).Projectiles.remove(Enemies.get(j).Projectiles.get(g));
                  }
                }
              }
            }
          }
          
          //check player projectile collition
          if(!main.Projectiles.isEmpty()){
            
            for(int j = 0; j < main.Projectiles.size(); j++){
              main.Projectiles.get(j).collide(Colliders.get(i));
              
              if(main.Projectiles.get(j).colliding){
                ps.addParticle(new PVector(main.Projectiles.get(j).position.x, main.Projectiles.get(j).position.y));
                main.Projectiles.remove(main.Projectiles.get(j));
              }
            }
          }
      }
      
      main.checkJump();
      main.checkDash();
      
      //check if enemy projectiles hit the player
      if(!Enemies.isEmpty()){
        for(int j = 0; j < Enemies.size(); j++){
          if(!Enemies.get(j).Projectiles.isEmpty()){
            for(int g = 0; g < Enemies.get(j).Projectiles.size(); g++){
              Enemies.get(j).Projectiles.get(g).check_hit(main);
            }
          }
        }
      }
      
      //check if player projectiles hit the enemies
      if(!Enemies.isEmpty() && !main.Projectiles.isEmpty()){  
        for(int i = 0; i < main.Projectiles.size(); i++){
          for(int j = 0; j < Enemies.size(); j++){
            main.Projectiles.get(i).check_hit(Enemies.get(j));
          }
        }
      }
      
      //diplay and update the enemies and their projectiles
      for(int j = 0; j < Enemies.size(); j++){
        Enemies.get(j).Movement(grid);
        Enemies.get(j).checkSight(main);
        if(!Enemies.get(j).Projectiles.isEmpty()){
          for(int i = 0; i < Enemies.get(j).Projectiles.size(); i++){
            Enemies.get(j).Projectiles.get(i).update();
            Enemies.get(j).Projectiles.get(i).display();
            Enemies.get(j).Projectiles.get(i).checkEdges();
          }
        }
        Enemies.get(j).update();
        Enemies.get(j).display();
        if(Enemies.get(j).hp<=0){
          Enemies.remove(Enemies.get(j));
        }
      }
        
      // Update and display the player projectiles
      for(int j = 0; j < main.Projectiles.size(); j++){
        main.Projectiles.get(j).update();
        main.Projectiles.get(j).display();
        main.Projectiles.get(j).checkEdges();
      }
      
      main.update();
      main.display();
      main.checkEdges();
      
      ps.run();
      
      fill(255);
  }
  
  void Dash(){
    if(Dash && main.letDash){
      
      if(Down || Right || Left){
        main.letDash=false;
        main.time_2 = millis()+100;
      }
      
      if(Down)  main.applyForce(new PVector(0, 10));
      
      if(Right) main.applyForce(new PVector(10, 0));
      
      if(Left)  main.applyForce(new PVector(-10, 0));
      
    }
    
  }
  
  void keyPressed(){
    setDash(keyCode, true);
    setMove(key, true);
    
    Dash();
    
    if(Right||Left)main.moving =true;
    
    if(Right) if(main.speed <=0) main.speed*=-1;
    
    
    if(Left)  if(main.speed >=0) main.speed*=-1;
    
    if(key==' '){
      if(!main.jumping){
       main.jumping=true;
       main.applyForce(new PVector(0, main.lift));
      }
    }
    
    if(key=='r' || key =='R'){
      main.respawn();
    }
    
    if(key=='e' || key =='E'){
      exit.collition(main);
      if(exit.colliding) changeState (new MainMenu());
    }
    
    if(key == 27){
      key=0;
      changeState (new MainMenu());
    }
  }
  
  void keyReleased(){
    setDash(keyCode, false);
    setMove(key, false);
    
    if(key=='d' || key=='D'){
      main.moving=false;
    }
    
    if(key=='a' || key=='A'){
      main.moving=false;
    }
  }
  
  boolean setDash(int k, boolean b) {
    switch (k) {
    case SHIFT:
      return Dash = b;
    default:
      return b;
    }
  }
  
  boolean setMove(char k, boolean b) {
    switch (k) {
    case 'W':
      return Up = b;
    case 'S':
      return Down = b;
    case 'D':
      return Right = b;
    case 'A':
      return Left = b;
    case 'd':
      return Right = b;
    case 'a':
      return Left = b;
    case 'w':
      return Up = b;
    case 's':
      return Down = b;
    default:
      return b;
    }
  }
  
  //Determines attack type bassed on mouse wheel 
  void set_attack(int k) {
    switch (k) {
    case -1:
      main.let_attack= false;
      main.let_fire = true;
      break;
    case  1:
      main.let_attack= true;
      main.let_fire = false;
      break;
    default:
      main.let_attack = false;
      main.let_fire = true;
      break;
    }
  }
  
  void mouseWheel(MouseEvent event){
    int e = event.getCount();
    set_attack(e);
  }
  
  void mousePressed(){
    if(mouseButton==LEFT){
        //if left mouse button fire a projectile
        if(main.let_fire)main.fire();
        
        //if left mouse button pressed check if the player hits the enemy
        if(main.let_attack){
          if(!Enemies.isEmpty()){  
            for(int j = 0; j < Enemies.size(); j++){
              main.attack(Enemies.get(j));
            }
          }
        }
    }
  }
  
}