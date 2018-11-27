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

int columns = 4;

/* =============================================================================================================== */
/* =============================================================================================================== */


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

float[][] L = {

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

void renderP(float[][] M, float[][] L, int l) {
  for (int i = 0; i < l; i ++) {
    stroke(0);
    linDDA(M[int(L[i][0]) - 1][0], M[int(L[i][0]) - 1][1], M[int(L[i][1]) - 1][0], M[int(L[i][1]) - 1][1]);
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

Object[] readFile(){

  int n;

  String maxs[];

  String cmps[];

  String[] lines = loadStrings("figure.dat");

  maxs = split(lines[1],' ');

  minx = int(maxs[0]);
  maxx = int(maxs[1]);
  miny = int(maxs[2]);
  maxy = int(maxs[3]);

  n = int(lines[2]);

  Object[] Objects = new Object[n];

  for( int i=0; i<n; i++ )
    Objects[i] = new Object();

  int i = 4, id = 0;

  while (id < n){

      cmps = split(lines[i],' ');

      Objects[id].init(int(cmps[0]),int(cmps[1]),int(cmps[2]));
      
      i++;
      
      float[][] mAux1 = new float[Objects[id].getVertices()][4];

      int j = 0;

      if (cmps.length == 3){
        while( j < Objects[id].getVertices()){
          cmps = split(lines[i],' ');
          mAux1[j][0] = float(cmps[0]);
          mAux1[j][1] = float(cmps[1]);
          mAux1[j][2] = float(cmps[2]);
          mAux1[j][3] = 1;
          j++;
          i++;
        }
        Objects[id].setPoints(mAux1);
      }

      cmps = split(lines[i],' ');

      float[][] mAux2 = new float[Objects[id].getEdges()][2];

      j = 0;

      if(cmps.length == 2){
        while( j < Objects[id].getEdges() ){
          cmps = split(lines[i],' ');
          mAux2[j][0] = float(cmps[0]);
          mAux2[j][1] = float(cmps[1]);
          j++;
          i++;
        }
        Objects[id].setLines(mAux2);
      }
      
      cmps = split(lines[i],' ');

      float[][] mAux3 = new float[Objects[id].getxFaces()][Objects[id].getVertices()+5];

      j = 0;

      if(cmps.length > 3){
        while( j < Objects[id].getxFaces()){
          cmps = split(lines[i],' ');
          for(int it = 0 ; it < cmps.length ; it++ ) mAux3[j][it] = float(cmps[it]);
          j++;
          i++;
        }
        Objects[id].setFaces(mAux3);
      }
      
      cmps = split(lines[i],' ');
      
      Objects[id].setrXYZ(float(cmps));
      
      i++;
      
      cmps = split(lines[i],' ');
      
      Objects[id].setsXYZ(float(cmps));
      
      i++;
      
      cmps = split(lines[i],' ');
      
      Objects[id].settXYZ(float(cmps));
      
      i++;
      
      id++;
      
      i++;
      
  }

  return Objects;
}

/* =============================================================================================================== */
/* =============================================================================================================== */

class Object {

  public int vertices, edges, faces;
  public float[] rXYZ = {0,0,0};
  public float[] sXYZ = {1,1,1};
  public float[] tXYZ = {0,0,0};

  public float[][] points;
  public float[][] lines;
  public float[][] cFaces;

  public void init(int vertices, int edges, int faces){
    this.vertices = vertices;
    this.edges = edges;
    this.faces = faces;
  }

  public void create(float[][] points, float[][] lines, float[][] cFaces){
    this.points = points;
    this.lines = lines;
    this.cFaces = cFaces;
  }

  public void setPoints(float[][] points){
    this.points = points;
  }
  public float[][] getPoints(){
    return this.points;
  }

  public void setLines(float[][] lines){
    this.lines = lines;
  }
  public float[][] getLines(){
    return this.lines;
  }

  public void setFaces(float[][] cFaces){
    this.cFaces = cFaces;
  }
  public float[][] getFaces(){
    return this.cFaces;
  }

  public void setrXYZ(float[] rXYZ){
    this.rXYZ = rXYZ;
  }

  public float[] getrXYZ(){
    return this.rXYZ;
  }

  public void setsXYZ(float[] sXYZ){
    this.sXYZ = sXYZ;
  }

  public float[] getsXYZ(){
    return this.sXYZ;
  }

  public void settXYZ(float[] tXYZ){
    this.tXYZ = tXYZ;
  }

  public float[] gettXYZ(){
    return this.tXYZ;
  }

  public int getVertices(){
    return this.vertices;
  }

  public int getEdges(){
    return this.edges;
  }

  public int getxFaces(){
    return this.faces;
  }

}

/* =============================================================================================================== */
/* =============================================================================================================== */

float[] rXYZ = {0,0,0};
float[] sXYZ = {1,1,1};
float[] tXYZ = {0,0,0};

float fx = 120;
float fy = 120;
float fz = 120;

int p = 0;

int id = 0;

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

  Object[] Objs = new Object[10];

  Objs = readFile();

  //Objs[0].init(vertices,edges,faces);

  //Objs[0].create(cube, L, cFaces);

  Objs[id].setPoints(rotateM(Objs[id].points, Objs[id].vertices, columns, Objs[id].rXYZ[0], Objs[id].rXYZ[1], Objs[id].rXYZ[2]));
  Objs[id].setrXYZ(rXYZ);
  Objs[id].setPoints(scaleM(Objs[id].points, Objs[id].vertices, columns, Objs[id].sXYZ[0], Objs[id].sXYZ[1], Objs[id].sXYZ[2]));
  Objs[id].setsXYZ(sXYZ);
  Objs[id].setPoints(translateM(Objs[id].points, Objs[id].vertices, columns, Objs[id].tXYZ[0], Objs[id].tXYZ[1], Objs[id].tXYZ[2]));
  Objs[id].settXYZ(tXYZ);
  
  debPrintM(Objs[id].getPoints(),Objs[id].getVertices(),columns);

  switch(p) {
  case 0:
    Objs[id].setPoints(cavaleiraProj(Objs[id].getPoints(),Objs[id].getVertices(),columns));
    break;
  case 1:
    Objs[id].setPoints(cabinetProj(Objs[id].getPoints(),Objs[id].getVertices(),columns));
    break;
  case 2:
    Objs[id].setPoints(isometricProj(Objs[id].getPoints(),Objs[id].getVertices(),columns));
    break;
  case 3:
    Objs[id].setPoints(escapepointProj(Objs[id].getPoints(),Objs[id].getVertices(),columns,fz));
    Objs[id].setPoints(homogenize(Objs[id].getPoints(),Objs[id].getVertices(),columns));
    break;
  case 4:
    Objs[id].setPoints(escapepoint2Proj(Objs[id].getPoints(),Objs[id].getVertices(),columns,fx,fz));
    Objs[id].setPoints(homogenize(Objs[id].getPoints(),Objs[id].getVertices(),columns));
    break;
  }

  Objs[id].setPoints(getMatrixT(Objs[id].getPoints(),Objs[id].getVertices(),columns));

  renderP(Objs[id].getPoints(),Objs[id].getLines(),Objs[id].edges);

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
    tXYZ[2] += 1;
  }
  if (key == 'e' || key == 'E') {
    tXYZ[2] -= 1;
  }
  if (key == 'd' || key == 'D') {
    tXYZ[0] += 1;
  }
  if (key == 'a' || key == 'A') {
    tXYZ[0] -= 1;
  }
  if (key == 'w' || key == 'W') {
    tXYZ[1] += 1;
  }
  if (key == 's' || key == 'S') {
    tXYZ[1] -= 1;
  }

  if (key == 'f' || key == 'F') {
    rXYZ[1] += 0.1;
  }
  if (key == 'h' || key == 'H') {
    rXYZ[1] -= 0.1;
  }
  if (key == 'g' || key == 'G') {
    rXYZ[2] += 0.1;
  }
  if (key == 't' || key == 'T') {
    rXYZ[2] -= 0.1;
  }
  if (key == 'y' || key == 'Y') {
    rXYZ[0] += 0.1;
  }
  if (key == 'r' || key == 'R') {
    rXYZ[0] -= 0.1;
  }

  if (key == '1') {
    sXYZ[0] += 0.1;
  }
  if (key == '3') {
    sXYZ[1] += 0.1;
  }
  if (key == '5') {
    sXYZ[2] += 0.1;;
  }
  if (key == '7') {
    sXYZ[0] += 0.1;
    sXYZ[1] += 0.1;
    sXYZ[2] += 0.1;
  }

  if (key == '2') {
    sXYZ[0] -= 0.1;
  }
  if (key == '4') {
    sXYZ[1] -= 0.1;
  }
  if (key == '6') {
    sXYZ[2] -= 0.1;;
  }
  if (key == '8') {
    sXYZ[0] -= 0.1;
    sXYZ[1] -= 0.1;
    sXYZ[2] -= 0.1;
  }

  if (key == 'o' || key == 'O' ) {

    rXYZ[0] = 0;
    rXYZ[1] = 0;
    rXYZ[2] = 0;

    tXYZ[0] = 0;
    tXYZ[1] = 0;
    tXYZ[2] = 0;

    sXYZ[0] = 1;
    sXYZ[1] = 1;
    sXYZ[2] = 1;
  }

  if (key == 'p') {
    p += 1;
    if (p == 5) p = 0;
  }
  
  if (key == TAB) {
    id++;
    if (id == 2) id = 1 ;
  }
  
}
