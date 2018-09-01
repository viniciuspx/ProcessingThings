boolean who;
int xi, xf, yi, yf;
int xc, yc, r;

void setup(){
  size(800,800);
  background(0);
}

void draw(){
  
  xi = intRNG();
  yi = intRNG();
  xf = intRNG();
  yf = intRNG();
  xc = intRNG();
  yc = intRNG();
  r = (int)random(180);
  
  
  if(guess(who)){
    stroke(colorRNG(),colorRNG(),colorRNG());
    linDDA(xi,yi,xf,yf);
  }
  else{
    stroke(colorRNG(),colorRNG(),colorRNG());
    circBrasenham(xc, yc, r);
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

int intRNG(){
  int value = (int)random(0,800);
  return value;
}

void linDDA(int xi, int yi, int xf, int yf){
  
    int dx = xf - xi, dy = yf - yi, steps, k;
    
    float incX, incY, x = xi, y = yi;
    
    if (abs(dx) > abs(dy)) steps = abs(dx);
    else steps = abs(dy);
    
    incX = dx / (float) steps;
    incY = dy / (float) steps;
  
    point((int)x,(int)y);
    
    for(k = 0 ; k < steps ; k++){
    
        x += incX;
        y += incY;  
    
        point((int)x,(int)y);
    
    }

}


void circBrasenham (int xc, int yc, int r){
    
    int x = 0, y = r, d = 3 - 2*r;
  
    while(y >= x)
    {
        circle(xc, yc, x, y);
        x++;
 
        if (d > 0){
            y--; 
            d = d + 4 * (x - y) + 10;
        }
        
        else{
            d = d + 4 * x + 6;
        }   
        
        circle(xc, yc, x, y); 
    }
}

void circle(int xc, int yc, int x, int y){
    point(xc+x, yc+y);
    point(xc-x, yc+y);
    point(xc+x, yc-y);
    point(xc-x, yc-y);
    point(xc+y, yc+x);
    point(xc-y, yc+x);
    point(xc+y, yc-x);
    point(xc-y, yc-x);
}
