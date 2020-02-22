//Button class 

class Button{
  
  int x, y, w, h;            //button coordinates and dimentions
  
  color c = color(0,0,0,100);//button color
  color l = color(255);      //button label color
  
  boolean locked,            //true if button is pressed
          over,              //true if the mouse is over the button
          visible = true;    //true if the button is visible
          
  String lable;  //lable text
  
  Button(int xrect,int yrect,int wd,int he, String lbl){
    x = xrect;
    y = yrect;
    w =wd;
    h= he;
    lable= lbl;
  }
 
  void update() {
    if(checkOver()) {
      over = true;
    } else {
      over = false;
    }
  }
  
  void display(){
    if(over || locked) fill(red(c), blue(c), green(c), 50);
    else fill(c);
    
    if(visible){
      rect(x,y,w,h);
      fill(l);
      textSize(14);
      textAlign(CENTER,CENTER);
      text(lable,x,y,w,h);
    }
  }
  
  //check if the mouse is over the button
  boolean checkOver(){
    if((mouseX>= x && mouseX<= x+w) && (mouseY >= y && mouseY <= y+h)) return true; 
    else return false;
  }

}