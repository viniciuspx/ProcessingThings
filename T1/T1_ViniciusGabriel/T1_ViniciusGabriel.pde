int x = 5, y = 5, bg = 255;
boolean flag = false;

void setup(){
  size(500,500);
  background(bg);
}

void draw(){
  
  fill(0);
  rect(x,y,8,8);
  
  if(flag == true){
    background(bg);
    flag = false;
  }
}

void keyPressed(){
  if(key == 'w' || key == 'W' || key == '8' ){
    y--;
  }
  if(key == 'x' || key == 'X' || key == '2' ){
    y++;
  }
  if(key == 'a' || key == 'A' || key == '4' ){
    x--;
  }
  if(key == 'd' || key == 'D' || key == '6' ){
    x++;
  }
  if(key == 's' || key == 'S' || key == '5' ){
     flag = true;
  }
  if(key == ESC){
    exit();
  }
}
