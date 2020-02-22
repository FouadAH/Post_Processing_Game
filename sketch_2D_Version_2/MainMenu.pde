//class for diplaying the main menu
class MainMenu extends State{
  
  Button level   = new Button(width/2-spacing*2, height/2-spacing*2, spacing*4, spacing*2, "START GAME");
  Button creator = new Button(width/2-spacing*2, height/2+spacing*2, spacing*4, spacing*2, "CREATE");
  
  void setup(){
      noCursor();
      background(0);    
  }
  void draw(){
     image(gradientBackGround,0,0);  
     
     smooth();
     //controles
     fill(255);
     text("WASD To Move",                    width/2-250, height/2-spacing*5,500,25);
     text("Shift + A/D/S To Dash",           width/2-250, height/2-spacing*6,500,25);
     text("Spacebar To Jump",                width/2-250, height/2-spacing*7,500,25);
     text("Mousewheel Up to toogle shoot",   width/2-250, height/2-spacing*8,500,25);
     text("Mousewheel Down to toogle attack",width/2-250, height/2-spacing*9,500,25);
     text("Left Mouse to attack/shoot",      width/2-250, height/2-spacing*10,500,25);
     
     fill(255);
     ellipse(mouseX,mouseY,5,5);
     
     level.update();
     creator.update();
     
     level.display();
     creator.display();
  }
  void mousePressed(){
    if(level.checkOver()){
      changeState( new LoadScreen());     
    }
    else if(creator.checkOver()){
     changeState (new LevelCreator());
    }
  }
  
}