int n = (int)random(3,12);
int m = (int)random(3,15);

int[][] P = new int[n][2];
int[][] L = new int[m][2];

void setup(){
  size(800,800);
  background(0);
}

void draw(){
  color cor_linha = color(intRNG(), intRNG(), intRNG());
  delay(500);
  desenhaPoligono(P,L,cor_linha,true,color(intRNG(), intRNG(), intRNG()));
}

int colorRNG(){
  int value = (int)random(1,255);
  return value;
}

int intRNG(){
  int value = (int)random(1,800);
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


void desenhaPoligono(int[][] P, int[][] L, color cor_linha, boolean preenche, color cor_preenchimento){
  
  int[] fill = new int[800];
  int k = 0;
  int io = 0;
  
  for(int i = 0 ; i < n; i++){
    for(int j = 0 ; j < 2 ; j++){
      P[i][j] = intRNG();  
    }
  }
  
   for(int i = 0 ; i < m; i++){
    for(int j = 0 ; j < 2 ; j++){
       L[i][j] = (int)random(1, n);  
    }
  }
 
 
  for(int i = 0 ; i < m ; i++){
    stroke(cor_linha);
    linDDA(P[L[i][0]][0], P[L[i][0]][1], P[L[i][1]][0], P[L[i][1]][1]);
  
   if(i == (m - 1)){
      stroke(cor_linha);
      linDDA(P[L[0][0]][0], P[L[0][0]][1], P[L[m-1][1]][0], P[L[m-1][1]][1]);
   }
  }
  
  for(int i = 0 ; i < 800 ; i++){
    
    for(int j = 0 ; j < 800 ; j++){
      
      if(get(i,j) != color(0)){
        fill[k] = i;
        k++;
      }   
        
    }
    
    
    for(int l = 0 ; l < 800 ; l++){ 
        stroke(cor_linha);
        if(io == 0) {
          linDDA(fill[l],0,fill[l+1],i); 
          io = 1;
        }
        else io = 0;
        if(fill[l+1] == 0) break;
    }
    
    for(int l = 0 ; l < 800 ; l++) fill[l] = 0;
    
    k = 0;
    
   }

}
