//class for running the load screen 

ArrayList<Colliders> Colliders = new ArrayList<Colliders>();
ArrayList<Enemy> Enemies= new ArrayList<Enemy>();
character main;
Door exit;

class LoadScreen extends State{
  
  VScrollbar s1;
  JSONArray level;
  ArrayList<Button> Buttons = new ArrayList<Button>();
  
  void setup(){
    noCursor();
    Buttons.removeAll(Buttons);
    s1 = new VScrollbar(10, 0, 20, height, 10);
    String path = "\\data";
    File[] files = listFiles(path);
    for (int i =  files.length -1 ; i >= 0; i--) {
      File f = files[i];    
      Buttons.add(new Button(width/2-150,0,300,25,f.getName().substring(0, f.getName().length()-5)));
    } 
    
  }
  
  void draw(){
    image(gradientBackGround,0,0);
    fill(255);
    ellipse(mouseX,mouseY,5,5);
    for(int i=0;i<Buttons.size();i++){
      Buttons.get(i).y=(int)(-s1.getPos() +30*i);
      Buttons.get(i).display();
      Buttons.get(i).update();
    }
    s1.update();
    s1.display();
  }
  
  void mousePressed(){
    if(mouseButton==LEFT){
       for(int i=0;i<Buttons.size();i++){
         if(Buttons.get(i).checkOver()){
           level = loadJSONArray("data/"+Buttons.get(i).lable+".json");
           Game_background=loadImage("img_data/"+Buttons.get(i).lable+".png");
           Buttons.removeAll(Buttons);
           load();
         }
       } 
    }
  }
  
  void mouseWheel(MouseEvent event) {
      s1.scroll=true;
      s1.scrl=event.getCount();
      s1.update();
      s1.scroll=false;
  }
  
  void keyPressed(){
   if(key == 27){
      key=0;
      Colliders.removeAll(Colliders);
      changeState (new MainMenu());
   }
  }
  
  //loads image and collider array data from the data and img folder respectively
  void load(){
    
    Enemies.removeAll(Enemies);
    Colliders.removeAll(Colliders);
    
    JSONObject exit_door = level.getJSONObject(0);
    exit = new Door(exit_door.getFloat("x"), exit_door.getFloat("y"));
    
    JSONObject spawn = level.getJSONObject(1);
    main = new character(spawn.getFloat("x"), spawn.getFloat("y"));
    
    JSONObject colliders_size = level.getJSONObject(2);
    
     for (int i = 3; i <= colliders_size.getInt("Size")+2; i++) {
        JSONObject colliders = level.getJSONObject(i); 
        String type =colliders.getString("Type");  
        if(type.contains("spikes")){
          Colliders.add( new spikes(colliders.getFloat("x"), colliders.getFloat("y"), colliders.getFloat("w"), colliders.getFloat("h")) );
        }
        else if(type.contains("platform")){
          Colliders.add( new platform(colliders.getFloat("x"), colliders.getFloat("y"), colliders.getFloat("w"), colliders.getFloat("h")) );
        }
     }
     
   JSONObject enemies_boolean = level.getJSONObject(colliders_size.getInt("Size")+3);
   if(enemies_boolean.getBoolean("Empty")==false){
     
     for(int i = colliders_size.getInt("Size")+4; i< level.size(); i++){
       JSONObject enemies = level.getJSONObject(i);
       Enemies.add( new Enemy(enemies.getFloat("x"), enemies.getFloat("y")));
     }
     
   }
   changeState( new MainGame());   
  }
  
  // This function returns all the files in a directory as an array of Strings  
  String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      return null;
    }
  }

}



 