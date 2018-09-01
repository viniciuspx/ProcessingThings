boolean who = false;

void setup(){
  size(1200,800);
  background(0);
}

void draw(){
  if(guess(who)){
    stroke(colorRNG(),colorRNG(),colorRNG());
    fill(colorRNG(),colorRNG(),colorRNG());
    rect(5,5,100,100);
  }
  else{
  background(0);
  }
}

void keyPressed(){
  if (key == ESC){
    exit();
  }
}

boolean guess(boolean who){
  float t = random(0,1);
  who = (t > 0.5) ? true : false;
  return who;
}

int colorRNG(){
  int value = (int)random(0,255);
  return value;
}
