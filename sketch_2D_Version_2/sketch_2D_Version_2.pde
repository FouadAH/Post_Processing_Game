//Main sketch file that takes the current state of the game, it's functions and runs that state

public static int deathCount = 0;
MouseEvent event;   //mouse wheel event
int spacing= 30;    //grid spacing
int customLevelNum; //number of levels in the data file

int rows, cols;     //number of rows and collums
      
color b1 = color(0,200,200), //starting color for background gradient
      b2 = color(50,50,200); //ending color for background gradient
      
PImage gradientBackGround; //background gradient
PImage Game_background;    //game background gradient

State current; //current state of the the sketch

void setup(){
  fullScreen(P2D); // run game in full screen using the P2D renderer
  rows = width/spacing;
  cols = height/spacing;
  gradientBackGround = setGradient(0, 0, width, height, b2, b1);
  
  //starting state is the main menu state
  changeState(new MainMenu());
}
void draw(){
  current.draw();
}

void keyPressed(){
  current.keyPressed(); 
}

void keyReleased(){
  current.keyReleased(); 
}

void mousePressed(){
  current.mousePressed(); 
}

void mouseReleased(){
  current.mouseReleased(); 
}

void mouseClicked() {
  current.mouseClicked();
}

void mouseDragged() {
  current.mouseDragged();
}

void mouseWheel(MouseEvent event) {
  current.mouseWheel(event);
}

//function to change the state of the game
void changeState(State next){
 current = next;
 current.setup();
}

//function to create a gradient
  PImage setGradient(int x, int y, float w, float h, color c1, color c2 ) {
    PGraphics gradient = createGraphics((int)w, (int)h);
    gradient.beginDraw();
    noFill();
    for (int i = y; i <= y+h; i++) {
      color c;
      float inter = map(i, y, y+h, 0, 1);
      
      for(int j=x; j<x+w; j++){
        if(j%spacing==0 || i%spacing==0) {
          c = color(128);
         }
        else {
          c = lerpColor(c1, c2, inter);
        }
        gradient.set(j, i, c);
      }
      
    }
    gradient.endDraw();
    return gradient;
  }