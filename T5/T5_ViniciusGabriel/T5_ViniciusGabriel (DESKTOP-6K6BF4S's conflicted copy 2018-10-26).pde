
/* =============================================================================================================== */

int _width = 800;
int _height = 800;

int maxy = 400;
int miny = -400;
int maxx = 400;
int minx = -400;
int maxz = 400;
int minz = -400;

int h = maxy - miny;
int w = maxx - minx;
int p = maxz - minz;

/* =============================================================================================================== */

int[][] cube_m = {

  {1,-50,-50,-50},
  {1,50,-50,-50},
  {1,-50,50,-50},
  {1,50,50,-50},
  
  {1,-50,-50,50},
  {1,50,-50,50},
  {1,-50,50,50},
  {1,50,50,50}

};

//int[][] cube_m = {

//  {1,0,0,0},
//  {1,100,0,0},
//  {1,0,100,0},
//  {1,100,100,0},
  
//  {1,0,0,100},
//  {1,100,0,100},
//  {1,0,100,100},
//  {1,100,100,100}

//};

/* =============================================================================================================== */

int[][] getM(int c1[],int c2[],int c3[],int c4[],int c5[],int c6[],int c7[],int c8[]){
  
  int[][] M = new int[8][3];
  
  for(int i=0;i<3;i++){
    M[0][i] = c1[i];
    M[1][i] = c2[i];
    M[2][i] = c3[i];
    M[3][i] = c4[i];
    M[4][i] = c5[i];
    M[5][i] = c6[i];
    M[6][i] = c7[i];
    M[7][i] = c8[i];
  }
  
  return M;

}


/* =============================================================================================================== */


int[] transform_coord(int x, int y, int z){

  int[] coords = {0,0,0};
  float a = 0.5;
  
  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;
  
  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;
  
  float m = min(_width/w,_height/h);
  
  //print("M = " + m + "\n");
  
  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;
  
  coords[0] = int(x_ll + z_ll*(sqrt(2)/2)*a);
  coords[1] = int(y_ll - z_ll*(sqrt(2)/2)*a);
  coords[2] = int(z_ll);
  
  //print("x' :" + coords[0] + " x: " + x + " y' :" + coords[1] + " y: " + y + " z: " + z +"\n");

  return coords;
  
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


void renderCube(int[] T, int[] S, int R){
  
/* =============================================================================================================== */

  int[] new_c1, new_c2, new_c3, new_c4, new_c5, new_c6, new_c7, new_c8;
  int[] old_c1, old_c2, old_c3, old_c4, old_c5, old_c6, old_c7, old_c8;
  
/* =============================================================================================================== */
  
  old_c1 = new_c1 = transform_coord(cube_m[0][1],cube_m[0][2],cube_m[0][3]);
  old_c2 = new_c2 = transform_coord(cube_m[1][1],cube_m[1][2],cube_m[1][3]);
  old_c3 = new_c3 = transform_coord(cube_m[2][1],cube_m[2][2],cube_m[2][3]);
  old_c4 = new_c4 = transform_coord(cube_m[3][1],cube_m[3][2],cube_m[3][3]);
  old_c5 = new_c5 = transform_coord(cube_m[4][1],cube_m[4][2],cube_m[4][3]);
  old_c6 = new_c6 = transform_coord(cube_m[5][1],cube_m[5][2],cube_m[5][3]);
  old_c7 = new_c7 = transform_coord(cube_m[6][1],cube_m[6][2],cube_m[6][3]);
  old_c8 = new_c8 = transform_coord(cube_m[7][1],cube_m[7][2],cube_m[7][3]);
   
/* =============================================================================================================== */

  if(S[0] > 1){
    for(int i=0 ; i < 3 ; i++){ //<>//
      //new_c1[i] = abs(old_c1[i] * S[i]) - old_c1[i];
      print(new_c1[0]+"\n");
      new_c2[i] = abs(old_c2[i] * S[i]) - (S[i]-1)*new_c1[i];
      new_c3[i] = abs(old_c3[i] * S[i]) - (S[i]-1)*new_c1[i];
      new_c4[i] = abs(old_c4[i] * S[i]) - (S[i]-1)*new_c1[i];
      new_c5[i] = abs(old_c5[i] * S[i]) - (S[i]-1)*new_c1[i];  //<>//
      new_c6[i] = abs(old_c6[i] * S[i]) - (S[i]-1)*new_c1[i];
      new_c7[i] = abs(old_c7[i] * S[i]) - (S[i]-1)*new_c1[i];
      new_c8[i] = abs(old_c8[i] * S[i]) - (S[i]-1)*new_c1[i]; 
    }
  }
  
 for(int i=0 ; i < 3 ; i++){
    new_c1[i] = new_c1[i] + T[i]; 
    new_c2[i] = new_c2[i] + T[i]; 
    new_c3[i] = new_c3[i] + T[i];
    new_c4[i] = new_c4[i] + T[i]; 
    new_c5[i] = new_c5[i] + T[i];   
    new_c6[i] = new_c6[i] + T[i];
    new_c7[i] = new_c7[i] + T[i];
    new_c8[i] = new_c8[i] + T[i]; 
  }
 
/* =============================================================================================================== */
 
 
 int M[][] = getM(new_c1, new_c2, new_c3, new_c4, new_c5, new_c6, new_c7, new_c8);
   
   
   
/* =============================================================================================================== */

/* =============================================================================================================== */

/* =============================================================================================================== */

  linDDA(new_c1[0],new_c1[1],new_c2[0],new_c2[1]);
  linDDA(new_c1[0],new_c1[1],new_c3[0],new_c3[1]);
  linDDA(new_c1[0],new_c1[1],new_c5[0],new_c5[1]);
  
  linDDA(new_c2[0],new_c2[1],new_c6[0],new_c6[1]);
  linDDA(new_c2[0],new_c2[1],new_c4[0],new_c4[1]);
  
  linDDA(new_c5[0],new_c5[1],new_c6[0],new_c6[1]);
  linDDA(new_c5[0],new_c5[1],new_c7[0],new_c7[1]);
  
  linDDA(new_c6[0],new_c6[1],new_c8[0],new_c8[1]);
  
  linDDA(new_c3[0],new_c3[1],new_c4[0],new_c4[1]);
  linDDA(new_c3[0],new_c3[1],new_c7[0],new_c7[1]);
  
  linDDA(new_c4[0],new_c4[1],new_c8[0],new_c8[1]);
  
  linDDA(new_c7[0],new_c7[1],new_c8[0],new_c8[1]);
  
}



/* =============================================================================================================== */
/* =============================================================================================================== */

int[] T = {0,0,0};
int[] S = {1,1,1};
int R = 0;

void clear(){
  background(255);
  stroke(128,255,128);
  linDDA(0,440,800,440);
  linDDA(360,0,360,800);
  linDDA(0,800,800,0);
}


void setup(){
  size(810,810);
  clear();
}

void draw(){
  stroke(0);
  renderCube(T,S,R);
}

void keyPressed(){
 
  if(key == 'd' || key == 'D'){
    clear();
    T[0] = T[0] + 5;
  }
  
  if(key == 'a' || key == 'A'){
    clear();
    T[0] = T[0] - 5;
  }
  
  if(key == 's' || key == 'S'){
    clear();
    T[1] = T[1] + 5;
  }
  
  if(key == 'w' || key == 'W'){
    clear();
    T[1] = T[1] - 5;
  }
  
  if(key == 'q' || key == 'Q'){
    clear();
    S[0] = S[0] + 1;
    S[1] = S[1] + 1;
    S[2] = S[2] + 1;
  }
  
  if(key == 'e' || key == 'E'){
    clear();
    S[0] = S[0] - 1;
    S[1] = S[1] - 1;
    S[2] = S[2] - 1;
  }
  
  if(key == 'r' || key == 'R'){
    clear();
    R++;
  }
  
  if(key == 'f' || key == 'F'){
    clear();
    R--;
  }
  
}
