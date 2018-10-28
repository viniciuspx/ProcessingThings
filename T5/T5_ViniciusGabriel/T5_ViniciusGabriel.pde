/* =============================================================================================================== */ //<>//

int _width = 1000;
int _height = 1000;

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
  
  {0,-5,20},
  {0,0,20},
  {0,0,0},
  {20,0,0},
  {20,5,0},
  {0,5,0},
  {0,20,0},
  {0,15,0}
  
};


//int[][] cube_m = {

//  {-30, -30, -30}, 
//  {30, -30, -30}, 
//  {-30, 30, -30}, 
//  {30, 30, -30}, 

//  {-30, -30, 30}, 
//  {30, -30, 30}, 
//  {-30, 30, 30}, 
//  {30, 30, 30}

//};

//int[][] L = {

//  {0, 1}, 
//  {0, 2}, 
//  {2, 3}, 
//  {1, 3}, 

//  {4, 5}, 
//  {4, 6}, 
//  {6, 7}, 
//  {7, 5}, 

//  {2, 6}, 
//  {0, 4}, 
//  {1, 5}, 
//  {3, 7}

//};

int[][] L = {

  {0,1},
  {1,2},
  {2,3},
  {3,4},
  {4,5},
  {5,6},
  {6,7}

};

/* =============================================================================================================== */
/* =============================================================================================================== */

int[] transformCCav(int x, int y, int z) {

  int[] coords = {0, 0, 0, 1};
  float a = 0.5;

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;

  float m = min(_width/w, _height/h);

  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;

  coords[0] = int(x_ll + z_ll*(sqrt(2)/2)*a);
  coords[1] = int(y_ll - z_ll*(sqrt(2)/2)*a);
  coords[2] = int(z_ll);

  return coords;
}

int[] transformCCab(int x, int y, int z) {

  int[] coords = {0, 0, 0, 1};
  float a = 0.5;

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;

  float m = min(_width/w, _height/h);

  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;

  coords[0] = int(x_ll + z_ll*(sqrt(2)/4)*a);
  coords[1] = int(y_ll - z_ll*(sqrt(2)/4)*a);
  coords[2] = int(z_ll);

  return coords;
}

int[] transformCiso(int x, int y, int z) {

  int[] coords = {0, 0, 0, 1};

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;

  float m = min(_width/w, _height/h);

  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;

  coords[0] = int((x_ll - y_ll)*(sqrt(2)/2));
  coords[1] = int(sqrt(2/3)*z_ll - (1/sqrt(6))*(x_ll + y_ll));
  coords[2] = int(z_ll);

  return coords;
}

int[] transformCCavZ(int x, int y, int z) {

  int fx = 250;
  
  int[] coords = {0, 0, 0, 1};
  float a = 0.5;

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;

  float m = min(_width/w, _height/h);

  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;

  coords[0] = int(x_ll + z_ll*(sqrt(2)/2)*a);
  coords[1] = int(y_ll - z_ll*(sqrt(2)/2)*a);
  coords[2] = int(z_ll);
  
  for(int i = 0 ; i < 3 ; i++) coords[i] /= (-coords[0]/fx + 1);

  return coords;
}

int[] transformCCavXZ(int x, int y, int z) {

  int fx = 250;
  int fz = 150;
  
  int[] coords = {0, 0, 0, 1};
  float a = 0.5;

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = maxy - y;
  z_l = maxz - z;

  float m = min(_width/w, _height/h);

  x_ll = x_l*m + (_width - w*m)/2;
  y_ll = y_l*m + (_height - h*m)/2;
  z_ll = z_l*m;

  coords[0] = int(x_ll + z_ll*(sqrt(2)/2)*a);
  coords[1] = int(y_ll - z_ll*(sqrt(2)/2)*a);
  coords[2] = int(z_ll);
  
  for(int i = 0 ; i < 3 ; i++) coords[i] /= ((-coords[0]/fx + 1) + (-coords[2]/fz + 1));

  return coords;
}

int[][] getMatrixT(int[][] A) {

  int M[][] = new int[8][4];

  if(P == 'C') for (int i = 0; i < 8; i ++) M[i] = transformCCav(A[i][0], A[i][1], A[i][2]); 
  if(P == 'B') for (int i = 0; i < 8; i ++) M[i] = transformCCab(A[i][0], A[i][1], A[i][2]); 
  if(P == 'I') for (int i = 0; i < 8; i ++) M[i] = transformCiso(A[i][0], A[i][1], A[i][2]); 
  if(P == 'Z') for (int i = 0; i < 8; i ++) M[i] = transformCCavZ(A[i][0], A[i][1], A[i][2]);
  if(P == 'X') for (int i = 0; i < 8; i ++) M[i] = transformCCavXZ(A[i][0], A[i][1], A[i][2]);


  return M;
}

void debPrintM (int[][] M) {

  print(" ------------Matrix------------ \n");

  for (int i = 0; i < 8; i ++) {
    for (int j = 0; j < 4; j ++) {
      print(M[i][j] + " ");
    }
    print("\n");
  }
}

void renderM(int[][] M, int[][] L) {
  for (int i = 0; i < 7; i ++) {
    linDDA(M[L[i][0]][0], M[L[i][0]][1], M[L[i][1]][0], M[L[i][1]][1]);
  }
}

void translateM(int[][] M, int[] T) {

  for (int i = 0; i < 8; i ++) {
    for (int j = 0; j < 3; j ++) {
      M[i][j] = M[i][j] + T[j];
    }
  }
}

void scalateM(int[][] M, float[] S) {

  for (int i = 0; i < 8; i ++) {
    for (int j = 0; j < 3; j ++) {
      M[i][j] = int(M[i][j] * S[j] - (S[j] - 1)*M[0][j]);
    }
  }
}

int[][] rotateM(int[][] M, float R, char rM) {

  int W[][] = new int[8][4];
  int T[] = new int[3];  
  int xyzO[] = new int[3];

  float a = cos(R);
  float b = sin(R);

  if(P == 'C') xyzO = transformCCav(0, 0, 0);
  if(P == 'B') xyzO = transformCCab(0, 0, 0);
  if(P == 'I') xyzO = transformCiso(0, 0, 0);
  if(P == 'Z') xyzO = transformCCavZ(0, 0, 0);
  if(P == 'X') xyzO = transformCCavXZ(0, 0, 0);

  float[][] mRz = { 
    {a, b, 0, 0}, 
    {-b, a, 0, 0}, 
    {0, 0, 1, 0}, 
    {1, 1, 1, 1}
  };

  float[][] mRx = { 
    {1, 0, 0, 0}, 
    {0, a, b, 0}, 
    {0, -b, a, 0}, 
    {1, 1, 1, 1}
  }; 


  float[][] mRy = { 
    {a, 0, -b, 0}, 
    {0, 1, 0, 0}, 
    {b, 0, a, 0}, 
    {1, 1, 1, 1}
  }; 

  T[0] = -xyzO[0];
  T[1] = -xyzO[1];
  T[2] = -xyzO[2];

  translateM(M, T);

  if (rM == 'x') {
    for (int i=0; i<8; ++i) for (int j=0; j<4; ++j) for (int k=0; k<4; ++k) {
      W[i][j] += int(M[i][k] * mRx[k][j]);
    }
  }

  if (rM == 'y') {
    for (int i=0; i<8; ++i) for (int j=0; j<4; ++j) for (int k=0; k<4; ++k) {
      W[i][j] += int(M[i][k] * mRy[k][j]);
    }
  }

  if (rM == 'z') {
    for (int i=0; i<8; ++i) for (int j=0; j<4; ++j) for (int k=0; k<4; ++k) {
      W[i][j] += int(M[i][k] * mRz[k][j]);
    }
  }

  T[0] = xyzO[0];
  T[1] = xyzO[1];
  T[2] = xyzO[2];

  translateM(W, T);

  return W;
}

/* =============================================================================================================== */
/* =============================================================================================================== */

void linDDA(int xi, int yi, int xf, int yf) {

  int dx = xf - xi, dy = yf - yi, steps, k;

  float incX, incY, x = xi, y = yi;

  if (abs(dx) > abs(dy)) steps = abs(dx);
  else steps = abs(dy);

  incX = dx / (float) steps;
  incY = dy / (float) steps;

  point((int)x, (int)y);

  for (k = 0; k < steps; k++) {

    x += incX;
    y += incY;  

    point((int)x, (int)y);
  }
}

String getName(String[] Projections, char C){
  
  String out = new String();
  
  if(C == 'C') out = Projections[0]; 
  if(C == 'B') out = Projections[1];  
  if(C == 'I') out = Projections[2];  
  if(C == 'Z') out = Projections[3];  
  if(C == 'X') out = Projections[4];
  
  return out;
  
}


/* =============================================================================================================== */
/* =============================================================================================================== */

int[] T = new int[4];
float[] S = {1, 1, 1};
float R = 0;
char rM = 'x';
char P = 'C';
PFont f;

String text;
String cmd;

String[] Projections = {
  "Cavaleira",
  "Cabinet",
  "Isometrica",
  "1 Pt de Fuga: Z",
  "2 Pts de Fuga: XZ"
};

/* =============================================================================================================== */
/* =============================================================================================================== */

void clear() {
  background(255);
  stroke(128, 255, 128);
}


void setup() {
  size(800, 800);
  
  int To[] = new int[4];
   
  f = createFont("Arial",22,true); 
  
  clear();
  
  if(P == 'C') To = transformCCav(-maxx,maxy,0);
  if(P == 'B') To = transformCCab(-maxx,maxy,0);
  if(P == 'I') To = transformCiso(0,-maxy,0);
  if(P == 'Z') To = transformCCavZ(50,maxy,0);
  if(P == 'X') To = transformCCavXZ(50,maxy,0);
  
  for(int i = 0 ; i < 3 ; i++){
    T[i] = -1 * To[i];
  }

}

void draw() {

  stroke(0);
  
  int M[][] = getMatrixT(cube_m);
  int N[][] = getMatrixT(cube_m);
  
  translateM(N, T);

  scalateM(M, S);

  N = rotateM(M, R, rM);

  translateM(N, T);

  renderM(N, L);

  debPrintM(N);
  
  text = "Rotação em Torno do eixo: " + rM + "\n" + "Escala do objeto: x = " + S[0] + " y = " + S[1] + " z = " + S[1] + "\nProjeção: " + getName(Projections,P);
  
  cmd = "WSAD - Translação \n Q - Aumenta Escala \n E - Diminui Escala \n R - Rotaciona 1º H \n F - Rotaciona 1º AH \n P - Troca Projeção \n M - Troca eixo de Rotação \n ESC - Sair";
  
  textAlign(TOP);
  textFont(f);
  text(text,5,45); 
  fill(200, 0, 0);
  text(cmd,500,500); 
  fill(0, 0, 200);
}

void keyPressed() {

  if (key == 'd' || key == 'D') {
    clear();
    T[0] = T[0] + 5;
  }

  if (key == 'a' || key == 'A') {
    clear();
    T[0] = T[0] - 5;
  }

  if (key == 's' || key == 'S') {
    clear();
    T[1] = T[1] + 5;
  }

  if (key == 'w' || key == 'W') {
    clear();
    T[1] = T[1] - 5;
  }

  if (key == 'q' || key == 'Q') {
    clear();
    S[0] = S[0] + 0.05;
    S[1] = S[1] + 0.05;
    S[2] = S[2] + 0.05;
  }

  if (key == 'e' || key == 'E') {
    clear();
    S[0] = S[0] - 0.05;
    S[1] = S[1] - 0.05;
    S[2] = S[2] - 0.05;
  }

  if (key == 'r' || key == 'R') {
    clear();
    R = R + 0.07;
  }

  if (key == 'f' || key == 'F') {
    clear();
    R = R - 0.07;
  }

  if(key == 'M' || key == 'm'){
  
    switch(rM){
      case 'x':
        clear();
        rM = 'y';
        break;
      case 'y':
        clear();
        rM = 'z';
        break;
      case 'z':
        clear();
        rM = 'x';
        break;
    }
  
  }
  
  if(key == 'P' || key == 'p'){
   
   switch(P){
     case 'C':
       clear();
       P = 'B';
       setup();
       break;
     case 'B':
       clear();
       P = 'I';
       setup();
       break;
     case 'I':
       clear();
       P = 'Z';
       setup();
       break;
     case 'Z':
       clear();
       P = 'X';
       setup();
       break;
     case 'X':
       clear();
       P = 'C';
       setup();
       break;
   }
  }

  if (key == ESC) {
    exit();
  }
}
