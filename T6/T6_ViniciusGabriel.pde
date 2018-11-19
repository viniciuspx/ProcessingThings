/* =============================================================================================================== */
/* =============================================================================================================== */

int maxy = 100;
int miny = -100;
int maxx = 100;
int minx = -100;
int maxz = 100;
int minz = -100;

int h = maxy - miny;
int w = maxx - minx;
int d = maxz - minz;

int lines = 8;
int columns = 4;
int llines = 12;

/* =============================================================================================================== */
/* =============================================================================================================== */

float[][] cube = {

  {-30, -30, -30, 1},
  {30, -30, -30, 1},
  {-30, 30, -30, 1},
  {30, 30, -30, 1},

  {-30, -30, 30, 1},
  {30, -30, 30, 1},
  {-30, 30, 30, 1},
  {30, 30, 30, 1}

};

int[][] L = {

  {0, 1},
  {0, 2},
  {2, 3},
  {1, 3},

  {4, 5},
  {4, 6},
  {6, 7},
  {7, 5},

  {2, 6},
  {0, 4},
  {1, 5},
  {3, 7}

};

/* =============================================================================================================== */
/* =============================================================================================================== */



void linDDA(float xi, float yi, float xf, float yf) {

  float dx = xf - xi, dy = yf - yi, steps;

  float incX, incY, x = xi, y = yi;

  int k;

  if (abs(dx) > abs(dy)) steps = abs(dx);
  else steps = abs(dy);

  incX = dx / (float) steps;
  incY = dy / (float) steps;

  point(x, y);

  for (k = 0; k < steps; k++) {

    x += incX;
    y += incY;

    point(x, y);
  }
}

float[][] multiplyMatrix(float[][] M, float[][]N, int m, int n, int s) {

  float R[][] = new float[m][s];

  for (int i=0; i<m; ++i) for (int j=0; j<n; ++j) for (int k=0; k<s; ++k) {
    R[i][j] += M[i][k] * N[k][j];
  }

  return R;
}

void debPrintM (float[][] M, int l, int c) {

  print(" ------------Matrix------------ \n");

  for (int i = 0; i < l; i ++) {
    for (int j = 0; j < c; j ++) {
      print(M[i][j] + " ");
    }
    print("\n");
  }
}

void renderP(float[][] M, int[][] L, int l) {
  for (int i = 0; i < l; i ++) {
    stroke(0);
    linDDA(M[L[i][0]][0], M[L[i][0]][1], M[L[i][1]][0], M[L[i][1]][1]);
  }
}

float[][] getMatrixT(float[][] L, int n, int m) {

  float R[][] = new float[n][m];

  for (int i = 0; i < n; i ++) R[i] = transformCoords(L[i][0], L[i][1], L[i][2]);

  return R;
}


/* =============================================================================================================== */
/* =============================================================================================================== */

float[] transformCoords(float x, float y, float z) {

  float[] coords = {0, 0, 0, 1};

  float x_l, y_l, z_l;
  float x_ll, y_ll, z_ll;

  x_l = x - minx;
  y_l = y - miny;
  z_l = z - minz;

  float m = min(width/w, height/h);

  x_ll = x_l;
  y_ll = h - y_l;
  z_ll = d - z_l;

  coords[0] = x_ll*m + (width - w*m)/2;
  coords[1] = y_ll*m + (height - h*m)/2;
  coords[2] = z_ll*m;

  return coords;
}

float[][] cavaleiraProj(float M[][], int n, int m) {

  float[][] C = {{1, 0, 0, 0}, {0, 1, 0, 0}, {sqrt(2)/2*0.5, -sqrt(2)/2*0.5, 1, 0}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, C, n, m, 4);

  return M;
}

float[][] cabinetProj(float M[][], int n, int m) {

  float[][] C = {{1, 0, 0, 0}, {0, 1, 0, 0}, {sqrt(2)/4*0.5, sqrt(2)/4*0.5, 1, 0}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, C, n, m, 4);

  return M;
}

float[][] isometricProj(float M[][], int n, int m) {

  float[][] I = {{sqrt(2)/2, 1/sqrt(6), 0, 0}, {0, 2/sqrt(6), 0, 0}, {sqrt(2)/2, -1/sqrt(6), 0, 0}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, I, n, m, 4);

  return M;
}

float[][] escapepointProj(float M[][], int n, int m, float fz) {

  float[][] EP = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, -1/fz}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, EP, n, m, 4);

  return M;
}

float[][] escapepoint2Proj(float M[][], int n, int m, float fx, float fz) {

  float[][] EP = {{1, 0, 0, -1/fx}, {0, 1, 0, 0}, {0, 0, 1, -1/fz}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, EP, n, m, 4);

  return M;
}

float[][] homogenize(float M[][], int n, int m) {

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      M[i][j] /= M[i][m-1];
    }
  }

  return M;
}

float[][] rotateM(float M[][], int n, int m, float rz, float rx, float ry) {

  float[][] R1 = {{cos(rz), sin(rz), 0, 0}, {-sin(rz), cos(rz), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
  float[][] R2 = {{1, 0, 0, 0}, {0, cos(rx), sin(rx), 0}, {0, -sin(rx), cos(rx), 0}, {0, 0, 0, 1}};
  float[][] R3 = {{cos(ry), 0, -sin(ry), 0}, {0, 1, 0, 0}, {sin(ry), 0, cos(ry), 0}, {0, 0, 0, 1}};

  M = multiplyMatrix(M, R1, n, m, 4);
  M = multiplyMatrix(M, R2, n, m, 4);
  M = multiplyMatrix(M, R3, n, m, 4);

  return M;
}

float[][] translateM(float M[][], int n, int m, float tz, float tx, float ty) {

  float[][] T = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {tx, ty, tz, 1}};

  M = multiplyMatrix(M, T, n, m, 4);

  return M;
}

float[][] scaleM(float M[][], int n, int m, float sz, float sx, float sy) {

  float[][] S = {{sx, 0, 0, 0}, {0, sy, 0, 0}, {0, 0, sz, 0}, {1, 1, 1, 1}};

  M = multiplyMatrix(M, S, n, m, 4);

  return M;
}

/* =============================================================================================================== */
/* =============================================================================================================== */

float rz = 0;
float rx = 0;
float ry = 0;

float tz = 0;
float tx = 0;
float ty = 0;

float sz = 1;
float sx = 1;
float sy = 1;

float fx = 120;
float fy = 120;
float fz = 120;

int p = 0;

PFont f;

String[] Projections = {
  "Cavaleira",
  "Cabinet",
  "Isometrica",
  "1 Pt de Fuga: Z",
  "2 Pts de Fuga: XZ"
};

String text;

void draw() {

  smooth();

  background(255);

  float M[][] = new float[lines][columns];

  M = rotateM(cube, lines, columns, rz, rx, ry);

  M = scaleM(M, lines, columns, sz, sx, sy);

  M = translateM(M, lines, columns, tz, tx, ty);

  debPrintM(M, lines, columns);

  switch(p) {
  case 0:
    M = cavaleiraProj(M, lines, columns);
    break;
  case 1:
    M = cabinetProj(M, lines, columns);
    break;
  case 2:
    M = isometricProj(M, lines, columns);
    break;
  case 3:
    M = escapepointProj(M, lines, columns, fz);
    M = homogenize(M, lines, columns);
    break;
  case 4:
    M = escapepoint2Proj(M, lines, columns, fx, fz);
    M = homogenize(M, lines, columns);
    break;
  }

  M = getMatrixT(M, lines, columns);

  renderP(M, L, llines);

  text = "Comandos \n WASDQE - Transladar \n TFGHRY - Rotacionar \n 1 a 8 - Escalonar \n O - Origem \n P - Troca Proj \n\n Proj: " + Projections[p] + ".";

  textAlign(TOP);
  textFont(f);
  text(text, 5, 45);
  fill(200, 0, 0);
}

void setup() {
  size(1200, 800);
  frameRate(60);
  background(255);
  f = createFont("Arial", 18, true);
}

void keyPressed() {
  if (key == 'q' || key == 'Q') {
    tz += 1;
  }
  if (key == 'e' || key == 'E') {
    tz -= 1;
  }
  if (key == 'd' || key == 'D') {
    tx += 1;
  }
  if (key == 'a' || key == 'A') {
    tx -= 1;
  }
  if (key == 'w' || key == 'W') {
    ty += 1;
  }
  if (key == 's' || key == 'S') {
    ty -= 1;
  }

  if (key == 'f' || key == 'F') {
    rz += 0.1;
  }
  if (key == 'h' || key == 'H') {
    rz -= 0.1;
  }
  if (key == 'g' || key == 'G') {
    rx += 0.1;
  }
  if (key == 't' || key == 'T') {
    rx -= 0.1;
  }
  if (key == 'y' || key == 'Y') {
    ry += 0.1;
  }
  if (key == 'r' || key == 'R') {
    ry -= 0.1;
  }

  if (key == '1') {
    sx += 0.1;
  }
  if (key == '3') {
    sy += 0.1;
  }
  if (key == '5') {
    sz += 0.1;
  }
  if (key == '7') {
    sx += 0.1;
    sy += 0.1;
    sz += 0.1;
  }

  if (key == '2') {
    sx -= 0.1;
  }
  if (key == '4') {
    sy -= 0.1;
  }
  if (key == '6') {
    sz -= 0.1;
  }
  if (key == '8') {
    sx -= 0.1;
    sy -= 0.1;
    sz -= 0.1;
  }

  if (key == 'o' || key == 'O' ) {
    rz = 0;
    rx = 0;
    ry = 0;

    tz = 0;
    tx = 0;
    ty = 0;

    sz = 1;
    sx = 1;
    sy = 1;
  }

  if (key == 'p') {
    p += 1;
    if (p == 5) p = 0;
  }
}
