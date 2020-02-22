//Verticle scroll bar class
class VScrollbar
{
  int swidth, sheight;          // width and height of bar
  int xpos, ypos;               // x and y position of bar
  float spos, newspos, scrl;    // x position of slider
  int sposMin, sposMax;         // max and min of slider
  int loose;                    
  boolean over;                 
  boolean locked;
  boolean scroll;
  float ratio;

  VScrollbar (int xp, int yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int heighttowidth = sh - sw;
    ratio = (float)sh / (float)heighttowidth;
    xpos = xp-swidth/2;
    ypos = yp;
    spos = ypos  - swidth/2;
    newspos = spos;
    sposMin = ypos;
    sposMax = ypos + sheight - swidth;
    loose = l;
  }

  void update() {
    if(over()) {
      over = true;
    } else {
      over = false;
    }
    if(mousePressed && over) {
      locked = true;
    }
    if(!mousePressed) {
      locked = false;
    }
    if(locked ) {
      newspos = constrain(mouseY-swidth/2, sposMin, sposMax);
    }
    if(scroll) {
      newspos = constrain((int)(spos + (scrl*1000)/loose), sposMin, sposMax);
    }
    if(abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  int constrain(int val, int minv, int maxv) {
    return min(max(val, minv), maxv);
  }

  boolean over() {
    if(mouseX > xpos && mouseX < xpos+swidth &&
    mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    fill(0,0,0,100);
    rect(xpos, ypos, swidth, sheight);
    if(over || locked) {
      fill(0, 0, 128);
    } else {
      fill(255);
    }
    rect(xpos, spos, swidth, swidth);
  }

  float getPos() {
    return spos * ratio;
  }
}