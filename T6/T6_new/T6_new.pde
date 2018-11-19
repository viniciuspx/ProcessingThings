class Universe {

  public int maxy;
  public int miny;
  public int maxx;
  public int minx;
  public int maxz;
  public int minz;

  public int h;
  public int w;
  public int d;

  public void create(int maxy, int miny, int maxx, int minx, int maxz, int minz){
    this.maxy = maxy;
    this.miny = miny;
    this.maxx = maxx;
    this.minx = minx;
    this.maxz = maxz;
    this.minz = minz;

    this.h = maxy - miny;
    this.w = maxx - minx;
    this.d = maxz - minz;
  }

}

class Object {

  public int vertices, edges;

  public float[][] object = new float[vertices][4];
  public float[][] lines  = new float[2][edges];

  public void create(float object[][], float lines[][]){
    this.object = object;
    this.lines = lines;
  }

}

class Utils {

  public float rx = 0;
  public float rz = 0;
  public float ry = 0;

  public float tz = 0;
  public float tx = 0;
  public float ty = 0;

  public float sz = 1;
  public float sx = 1;
  public float sy = 1;

  public float fx = 120;
  public float fy = 120;
  public float fz = 120;

  public int p = 0;

  public PFont f;

  public String[] Projections = {
    "Cavaleira",
    "Cabinet",
    "Isometrica",
    "1 Pt de Fuga: Z",
    "2 Pts de Fuga: XZ"
  };

  public String text;

  public void linDDA(float xi, float yi, float xf, float yf) {

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

  public float[][] multiplyMatrix(float[][] M, float[][]N, int m, int n, int s) {

    float R[][] = new float[m][s];

    for (int i=0; i<m; ++i) for (int j=0; j<n; ++j) for (int k=0; k<s; ++k) {
      R[i][j] += M[i][k] * N[k][j];
    }

    return R;
  }

  public void debPrintM (float[][] M, int l, int c) {

    print(" ------------Matrix------------ \n");

    for (int i = 0; i < l; i ++) {
      for (int j = 0; j < c; j ++) {
        print(M[i][j] + " ");
      }
      print("\n");
    }
  }

  public void renderP(float[][] M, int[][] L, int l) {
    for (int i = 0; i < l; i ++) {
      stroke(0);
      linDDA(M[L[i][0]][0], M[L[i][0]][1], M[L[i][1]][0], M[L[i][1]][1]);
    }
  }

  public float[][] getMatrixT(float[][] L, int n, int m, Universe universe) {

    float R[][] = new float[n][m];

    for (int i = 0; i < n; i ++) R[i] = transformCoords(L[i][0], L[i][1], L[i][2], universe);

    return R;
  }

  public float[] transformCoords(float x, float y, float z, Universe universe) {

    float[] coords = {0, 0, 0, 1};

    float x_l, y_l, z_l;
    float x_ll, y_ll, z_ll;

    x_l = x - universe.minx;
    y_l = y - universe.miny;
    z_l = z - universe.minz;

    float m = min(width/universe.w, height/universe.h);

    x_ll = x_l;
    y_ll = universe.h - y_l;
    z_ll = universe.d - z_l;

    coords[0] = x_ll*m + (width - universe.w*m)/2;
    coords[1] = y_ll*m + (height - universe.h*m)/2;
    coords[2] = z_ll*m;

    return coords;
  }

  public float[][] cavaleiraProj(float M[][], int n, int m) {

    float[][] C = {{1, 0, 0, 0}, {0, 1, 0, 0}, {sqrt(2)/2*0.5, -sqrt(2)/2*0.5, 1, 0}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, C, n, m, 4);

    return M;
  }

  public float[][] cabinetProj(float M[][], int n, int m) {

    float[][] C = {{1, 0, 0, 0}, {0, 1, 0, 0}, {sqrt(2)/4*0.5, sqrt(2)/4*0.5, 1, 0}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, C, n, m, 4);

    return M;
  }

  public float[][] isometricProj(float M[][], int n, int m) {

    float[][] I = {{sqrt(2)/2, 1/sqrt(6), 0, 0}, {0, 2/sqrt(6), 0, 0}, {sqrt(2)/2, -1/sqrt(6), 0, 0}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, I, n, m, 4);

    return M;
  }

  public float[][] escapepointProj(float M[][], int n, int m, float fz) {

    float[][] EP = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, -1/fz}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, EP, n, m, 4);

    return M;
  }

  public float[][] escapepoint2Proj(float M[][], int n, int m, float fx, float fz) {

    float[][] EP = {{1, 0, 0, -1/fx}, {0, 1, 0, 0}, {0, 0, 1, -1/fz}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, EP, n, m, 4);

    return M;
  }

  public float[][] homogenize(float M[][], int n, int m) {

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
        M[i][j] /= M[i][m-1];
      }
    }

    return M;
  }

  public float[][] rotateM(float M[][], int n, int m, float rz, float rx, float ry) {

    float[][] R1 = {{cos(rz), sin(rz), 0, 0}, {-sin(rz), cos(rz), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    float[][] R2 = {{1, 0, 0, 0}, {0, cos(rx), sin(rx), 0}, {0, -sin(rx), cos(rx), 0}, {0, 0, 0, 1}};
    float[][] R3 = {{cos(ry), 0, -sin(ry), 0}, {0, 1, 0, 0}, {sin(ry), 0, cos(ry), 0}, {0, 0, 0, 1}};

    M = multiplyMatrix(M, R1, n, m, 4);
    M = multiplyMatrix(M, R2, n, m, 4);
    M = multiplyMatrix(M, R3, n, m, 4);

    return M;
  }

  public float[][] translateM(float M[][], int n, int m, float tz, float tx, float ty) {

    float[][] T = {{1, 0, 0, 0}, {0, 1, 0, 0}, {0, 0, 1, 0}, {tx, ty, tz, 1}};

    M = multiplyMatrix(M, T, n, m, 4);

    return M;
  }

  public float[][] scaleM(float M[][], int n, int m, float sz, float sx, float sy) {

    float[][] S = {{sx, 0, 0, 0}, {0, sy, 0, 0}, {0, 0, sz, 0}, {1, 1, 1, 1}};

    M = multiplyMatrix(M, S, n, m, 4);

    return M;
  }

}


/* =============================================================================================================== */
/* =============================================================================================================== */

void setup() {
  Universe universe = new Universe();
  Utils utils = new Utils();

  universe.create(100,-100,100,-100,100,-100);

  size(1200, 800);
  frameRate(60);
  background(255);
  utils.f = createFont("Arial", 18, true);

}

void draw() {

  utils.text = "Comandos \n WASDQE - Transladar \n TFGHRY - Rotacionar \n 1 a 8 - Escalonar \n O - Origem \n P - Troca Proj \n\n Proj: " + Projections[p] + ".";

  textAlign(TOP);
  textFont(f);
  text(text, 5, 45);
  fill(200, 0, 0);

}

void keyPressed(){


}
