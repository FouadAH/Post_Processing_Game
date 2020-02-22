//class for running the level creator state use for creating and saving levels
  
  class LevelCreator extends State{
  
  ArrayList<Colliders> Colliders = new ArrayList<Colliders>();
  ArrayList<Enemy> Enemies= new ArrayList<Enemy>();
 
  character main = new character(0,0);
  Door exit = new Door(width-100, height-200);
  
  JSONArray value;
  
  float dx = constrain(0,0,width),
        dy = constrain(0,0,height),
        dw = constrain(0,0,width),
        dh = constrain(0,0,height);
        
  boolean revx = false,
          revy = false;
      
  boolean mouseVisible=true,
          saving=false,
          gridPlat[][] = new boolean [ceil(rows)+1][ceil(cols)+1], 
          gridSpik[][] = new boolean [ceil(rows)+1][ceil(cols)+1];
          
  boolean right = false,
          dragging=false,
          allowed =false;
  
  Button door      = new Button(spacing, spacing*12,  spacing*3, spacing, "Door"),
         chr      = new Button(spacing, spacing*10,  spacing*3, spacing, "Spawn"),
         enemy    = new Button(spacing, spacing*8,  spacing*3, spacing, "Enemy"),
         spikes   = new Button(spacing, spacing*6,  spacing*3, spacing, "Spikes"),
         platform = new Button(spacing, spacing*4,  spacing*3, spacing, "Platform");
  
  void setup(){
    
    door.visible=true;
    chr.visible =true;
    enemy.visible =true;
    spikes.visible=true;
    platform.visible=true;
    mouseVisible=true;  
    
    door.locked=true;
    chr.locked =true;
    platform.locked = false;
    spikes.locked = true;
    enemy.locked = true;
    
    noCursor();
    background(0);
     for(int i =0; i<rows;i++){
          for(int j =0; j<cols;j++){
            gridPlat[i][j]=false;
            gridSpik[i][j]=false;
          }
          
     } 
  }
  void draw(){
    
    image(gradientBackGround,0,0);
    
    if(dragging) {
      noStroke();
      fill(0,0,255,100);
      rect(dx, dy, dw, dh);
    }
    
    dragger(platform.locked, gridPlat);
    dragger(spikes.locked, gridSpik);
    
    if(chr.visible)main.display();
    exit.display();
    display_Enemies();
    displayGrid(gridSpik,"spikes");
    displayGrid(gridPlat,"platform");
    
    stroke(128);
    spikes.display();
    platform.display();
    chr.display();
    enemy.display();
    door.display();
    
    fill(255);
    if(mouseVisible)ellipse(mouseX,mouseY,5,5);
    
    if(saving){
      saving =false;
      save();
      door.visible=true;
      chr.visible=true;
      mouseVisible=true;
      enemy.visible =true;
      spikes.visible=true;
      platform.visible=true;
    }
  }
 
  void mousePressed(){
    if(!spikes.checkOver() && !platform.checkOver() && !enemy.checkOver() && !chr.checkOver() && !door.checkOver()){
       allowed=true;
       if(mouseButton==LEFT){
         dx=mouseX - mouseX%spacing;
         dy=mouseY - mouseY%spacing;
       }
       if(mouseButton==RIGHT) right = true;
    }
    
    else{
      allowed = false;
      dragging=false;
    }
    
    if(spikes.checkOver()){
      chr.locked =true;
      spikes.locked = false;
      enemy.locked = true;
      platform.locked = true;
      door.locked=true;
    }
    
    else if(platform.checkOver()){
      chr.locked =true;
      platform.locked = false;
      spikes.locked = true;
      enemy.locked = true;
      door.locked=true;

    }
    else if(enemy.checkOver()){
      chr.locked =true;
      platform.locked = true;
      spikes.locked = true;
      enemy.locked = false;
      door.locked=true;
    }
    
    else if(chr.checkOver()){
      chr.locked =false;
      platform.locked = true;
      spikes.locked = true;
      enemy.locked = true;
      door.locked=true;
    }
    
    else if(door.checkOver()){
      door.locked=false;
      chr.locked =true;
      platform.locked = true;
      spikes.locked = true;
      enemy.locked = true;
    }

    
    
  }
  
  void mouseReleased(){
    
    dragging=false;
    
    if(mouseButton==LEFT){
      if(allowed && (!spikes.locked || !platform.locked))  createBox();
      if(allowed && !enemy.locked)  create_enemy();
      if(allowed && !chr.locked)  create_chr();
      if(allowed && !door.locked)  create_exit();
      
    }
    
    if(mouseButton==RIGHT ){
      right = false;
    }
    
    dh=spacing;
    dw=spacing;
    
  }
  
  void keyPressed(){
     if(key=='S'){
       door.visible=false;
       chr.visible = false;
       enemy.visible =false;
       mouseVisible=false;
       spikes.visible=false;
       platform.visible=false;
       saving=true;
     }
     if(key == 27){
        key=0;
        changeState (new MainMenu());
     }
  }
  void create_chr(){
    main = new character(dx, dy);
  }
  
  void create_exit(){
    exit = new Door(dx, dy);
  }
  
  void create_enemy(){
    Enemies.add(new Enemy(dx, dy));
  }
  
  void display_Enemies(){
   for(int i = 0; i< Enemies.size(); i++){
      if(enemy.visible)Enemies.get(i).display();
      if(right && check_delete_enemy(Enemies.get(i))){
        Enemies.remove(Enemies.get(i));
      }
    } 
  }
  
  boolean check_delete_enemy(Enemy e){
    if((mouseX >= e.position.x && mouseX <= e.position.x+e.size.x && mouseY >= e.position.y && mouseY <= e.position.y + e.size.y)){
      return true;
    }
    return false;
  }
  
  // save the level 
  void save(){
    println("Saving...");
    value = new JSONArray();
    
    JSONObject exit_door = new JSONObject();
    exit_door.setFloat("x", exit.x);
    exit_door.setFloat("y", exit.y);
    value.setJSONObject(0, exit_door);
    
    JSONObject spawn = new JSONObject();
    spawn.setFloat("x", main.position.x);
    spawn.setFloat("y", main.position.y);
    value.setJSONObject(1, spawn);
    
    JSONObject collider_size = new JSONObject();
    collider_size.setInt("Size", Colliders.size());
    value.setJSONObject(2, collider_size);
    
    for (int i = 0; i < Colliders.size(); i++) {

      JSONObject colliders = new JSONObject();
      //colliders.setString("Tile", Colliders.get(i).tileType);
      colliders.setString("Type", Colliders.get(i).getClass().getName());
      colliders.setFloat("x", Colliders.get(i).x);
      colliders.setFloat("y", Colliders.get(i).y);
      colliders.setFloat("w", Colliders.get(i).w);
      colliders.setFloat("h", Colliders.get(i).h);
  
      value.setJSONObject(i+3, colliders);
    }
    
    JSONObject enemies_boolean = new JSONObject();
    enemies_boolean.setBoolean("Empty", Enemies.isEmpty());
    value.setJSONObject(Colliders.size()+3, enemies_boolean);  
    
    for (int i = 0; i < Enemies.size(); i++) {
      JSONObject enemies = new JSONObject();
      enemies.setFloat("x", Enemies.get(i).position.x);
      enemies.setFloat("y", Enemies.get(i).position.y);
      value.setJSONObject(Colliders.size()+4+i, enemies);
    } 
    
    String path = "\\data";
    File[] files = listFiles(path);
    saveFrame("img_data/Custom_Level_"+files.length+".png"); // takes a screenshot of the current frame and saves it as a png found in the img folder
    saveJSONArray(value, "data/Custom_Level_"+files.length+".json"); // saves the collider arraylist data as a json file found in the data folder
    println("Saved Custom_Level_"+files.length);
    
  }
  
  // This function returns all the files in a directory as an array of Strings  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
  
  void mouseDragged(){
    if(mouseButton==LEFT ){
      if(allowed && (!spikes.locked || !platform.locked)){
         dragging=true;
         if (dx<=mouseX) {
           revx=false;
           dw = mouseX -dx -mouseX%spacing + spacing;
         }
         if (dy<=mouseY){
           revy=false;
           dh = mouseY -dy -mouseY%spacing + spacing;
         }
         if (dx>mouseX) {
           revx=true;
           dw = mouseX -dx -mouseX%spacing;
         }
         if (dy>mouseY){
           revy=true;
           dh = mouseY -dy -mouseY%spacing;
         }
      }
    }
    
  }
  
  
  void createBox(){
    
    if(revx==true) {
      dw = abs(mouseX -dx -mouseX%spacing);
      dx=dx-dw;
    }
    if(revy==true) {
      dh = abs(mouseY -dy -mouseY%spacing);
      dy=dy-dh;
    }
    
    int maxi = (int)constrain(dx/spacing+dw/spacing, 0, width/spacing);
    int maxj = (int)constrain(dy/spacing+dh/spacing, 0, height/spacing);
    
    if(!platform.locked){
      
      Colliders.add( new platform(dx, dy, dw, dh));
      
      for(int i = (int)constrain(dx/spacing, 0, width/spacing); i < maxi; i++){
        for(int j = (int)constrain(dy/spacing, 0, height/spacing); j < maxj; j++){
          gridPlat[i][j]=true;
        }
      }
    }
    else if(!spikes.locked){
      
      Colliders.add( new spikes(dx, dy, dw, dh));
      
      for(int i = (int)constrain(dx/spacing, 0, width/spacing); i < maxi; i++){
        for(int j = (int)constrain(dy/spacing, 0, height/spacing); j < maxj; j++){
          gridSpik[i][j]=true;
        }
      }
    }
    revx=false;
    revy=false;
  }
  
  
  
  boolean checkDelete(Colliders c){
    if((mouseX >= c.x && mouseX <= c.x+c.w && mouseY >= c.y && mouseY <= c.y + c.h)){
      return true;
    }
    return false;
  }
  
  void displayGrid(boolean[][]grid, String type){
    for(int i = 0; i < Colliders.size(); i++){
        if(Colliders.get(i).getClass().getName().contains(type)){
          
            Colliders.get(i).display();
            
            if (checkDelete(Colliders.get(i)) && right ){
              
              int maxr = (int)constrain(Colliders.get(i).x/spacing+ Colliders.get(i).w/spacing, 0, width/spacing);
              int maxc = (int)constrain(Colliders.get(i).y/spacing+ Colliders.get(i).h/spacing, 0, height/spacing );
              
              for(int r = (int)constrain(Colliders.get(i).x/spacing, 0, width/spacing); r < maxr; r++){
                for(int c = (int)constrain(Colliders.get(i).y/spacing, 0, height/spacing); c < maxc; c++){
                    grid[r][c]=false;
                }
              }
              
              Colliders.remove(i);
            }
        }
    }
  }
  
  void dragger(boolean btn, boolean [][] grid){
   if(dragging && !btn){
      noStroke();
      fill(0,0,255,100);
      for(int i =0; i<rows;i++){
          for(int j =0; j<cols;j++){
            if(grid[i][j]==true) rect(i*spacing, j*spacing, spacing, spacing);
          }
       }
    } 
    
  }
}
  