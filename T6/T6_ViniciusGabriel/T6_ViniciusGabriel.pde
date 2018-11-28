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

void renderP(float[][] M, float[][] L, int l, boolean c) {
  for (int i = 0; i < l; i ++) {
    
    if(c == true) stroke(255,255,255); 
    else stroke(255,119,0);
    
    linDDA(M[int(L[i][0]) - 1][0], M[int(L[i][0]) - 1][1], M[int(L[i][1]) - 1][0], M[int(L[i][1]) - 1][1]);
  }
}


/* =============================================================================================================== */
/* =============================================================================================================== */

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

/* =============================================================================================================== */
/* =============================================================================================================== */

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
  public float[] rXYZ;
  public float[] sXYZ;
  public float[] tXYZ;

  public float[][] oldPoints;
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
    this.oldPoints = points;
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
  
  
  float[][] dot(float[][] M, float[][]N, int m, int n, int s) {

    float R[][] = new float[m][s];
  
    for (int i=0; i<m; ++i) for (int j=0; j<n; ++j) for (int k=0; k<s; ++k) {
      R[i][j] += M[i][k] * N[k][j];
    }
  
    return R;
  }
  
  void translate() {

    float[][] T = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {this.tXYZ[0], this.tXYZ[1], this.tXYZ[2], 1}};
  
    this.points = dot(this.points, T, this.vertices, columns, 4);

  }
  
  void rotate() {

    float[][] R1 = {{cos(this.rXYZ[2]), sin(this.rXYZ[2]), 0, 0}, {-sin(this.rXYZ[2]), cos(this.rXYZ[2]), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    float[][] R2 = {{1, 0, 0, 0}, {0, cos(this.rXYZ[0]), sin(this.rXYZ[0]), 0}, {0, -sin(this.rXYZ[0]), cos(this.rXYZ[0]), 0}, {0, 0, 0, 1}};
    float[][] R3 = {{cos(this.rXYZ[1]), 0, -sin(this.rXYZ[1]), 0}, {0, 1, 0, 0}, {sin(this.rXYZ[1]), 0, cos(this.rXYZ[1]), 0}, {0, 0, 0, 1}};
  
    this.points = dot(this.oldPoints, R1, this.vertices, columns, 4);
    this.points = dot(this.points, R2, this.vertices, columns, 4);
    this.points = dot(this.points, R3, this.vertices, columns, 4);
    
  }
  
  void scale() {

    float[][] S = {{this.sXYZ[0], 0, 0, 0}, {0, this.sXYZ[1], 0, 0}, {0, 0, this.sXYZ[2], 0}, {1, 1, 1, 1}};
  
    this.points = dot(this.points, S, this.vertices, columns, 4);

  }
  
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
  
  void transform() {
  
    for (int i = 0; i < this.vertices; i ++) 
      this.points[i] = transformCoords(this.points[i][0], this.points[i][1], this.points[i][2]);
 
  }
  
  void projection(int p){
    
    switch(p) {
      case 0:
        this.points = cavaleiraProj(this.points,this.vertices,columns);
        break;
      case 1:
        this.points = cabinetProj(this.points,this.vertices,columns);
        break;
      case 2:
        this.points = isometricProj(this.points,this.vertices,columns);
        break;
      case 3:
        this.points = escapepointProj(this.points,this.vertices,columns,fz);
        this.points = homogenize(this.points,this.vertices,columns);
        break;
      case 4:
        this.points = escapepoint2Proj(this.points,this.vertices,columns,fx,fz);
        this.points = homogenize(this.points,this.vertices,columns);
        break;
    }
  
  
  }
  
  void listen(){
    
   if(keyPressed == true){
    
      float[] aux = {0,0,0};
      float[] raux = {0,0,0};
      
      if(key == 'w'){
        this.tXYZ[1] += 1.0;
      }
      
      if(key == 's'){
        this.tXYZ[1] -= 1.0;
      }
      
      if(key == 'a'){
        this.tXYZ[0] -= 1.0;
      }
      
      if(key == 'd'){
        this.tXYZ[0] += 1.0;
      }
      
      if(key == 'e'){
        this.tXYZ[2] += 1.0;
      }
      
      if(key == 'q'){
        this.tXYZ[2] -= 1.0;
      }
      
       if(key == 't'){
        this.rXYZ[0] += 0.03;
      }
      
      if(key == 'g'){
        this.rXYZ[0] -= 0.03;
      }
      
      if(key == 'h'){
        this.rXYZ[1] += 0.03;
      }
      
      if(key == 'f'){
        this.rXYZ[1] -= 0.03;
      }
      
      if(key == 'y'){
        this.rXYZ[2] += 0.03;
      }
      
      if(key == 'r'){
        this.rXYZ[2] -= 0.03;
      }
      
      if(key == '1'){
        this.sXYZ[0] += 0.1;
      }
      
      if(key == '2'){
        this.sXYZ[0] -= 0.1;
      }
      
      if(key == '3'){
        this.sXYZ[1] += 0.1;
      }
      
      if(key == '4'){
        this.sXYZ[1] -= 0.1;
      }
      
      if(key == '5'){
        this.sXYZ[2] += 0.1;
      }
      
      if(key == '6'){
        this.sXYZ[2] -= 0.1;
      }
      
      if(key == '+'){
        this.sXYZ[0] += 0.1;
        this.sXYZ[1] += 0.1;
        this.sXYZ[2] += 0.1;
      }
      
      if(key == '-'){
        this.sXYZ[0] -= 0.1;
        this.sXYZ[1] -= 0.1;
        this.sXYZ[2] -= 0.1;
      }
      
      if (key == 'o' || key == 'O' ) {
        this.tXYZ = aux;
        this.rXYZ = raux;
      }
   
   }
    
  }
  

}

/* =============================================================================================================== */
/* =============================================================================================================== */

Object[] Objs;

float fx = 80;
float fy = 80;
float fz = 80;

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

void setup() {
  size(1200, 800);
  frameRate(60);
  background(255);
  f = createFont("Arial", 16, true);
  Objs = readFile(); 
  for (int i = 0 ; i < Objs.length ; i++){
    Objs[i].rotate();
    Objs[i].scale();
    Objs[i].translate();
    Objs[i].projection(p);
    Objs[i].transform();
  }
}

void draw() {

  background(95,95,105);

  Objs[id].listen();
  Objs[id].rotate();
  Objs[id].scale();
  Objs[id].translate();
    
  debPrintM(Objs[id].getPoints(),Objs[id].getVertices(),columns);
 
  Objs[id].projection(p);
  Objs[id].transform();  
  
  for (int i = 0 ; i < Objs.length ; i++) {
    renderP(Objs[i].getPoints(),Objs[i].getLines(),Objs[i].edges,false);
    if(i != id) renderP(Objs[i].getPoints(),Objs[i].getLines(),Objs[i].edges,true);
  }
  
  text = "Comandos \n WASDQE - Transladar \n TFGHRY - Rotacionar \n 1 a 8 - Escalonar \n ( + e - ) - Escalona XYZ \n O - Origem \n P - Troca Proj \n TAB - Troca Obj \n Proj: " + Projections[p] + ".";
  textAlign(TOP);
  textFont(f);
  text(text, 5, 45);
  fill(0, 0, 255);
}

void keyPressed() {
  if (key == 'p') {
    p += 1;
    if (p == 5) p = 0;
  }
  if (key == TAB) {
    id += 1;
    if (id == Objs.length) id = 0;
  }
  if (key == SHIFT && key == TAB) {
    id -= 1;
    if (id == 0) id = Objs.length;
  }
  if (key == ESC) exit();
}
