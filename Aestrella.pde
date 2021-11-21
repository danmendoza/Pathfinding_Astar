// Display values:
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 800;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {230, 250, 240};

// Grid values:
int nrows, ncols, tamcelda;
PVector pos_celda, inicio, fin;
Grid grid;
Camino camino;
int celda;
color a, b;
ArrayList<Nodo> Lab = new ArrayList<Nodo>();
Flock flock = new Flock();
float porcentajeObstaculos;
PrintWriter output;
float antes, despues, tiempo;
int repeticiones, numVehiclesCamino;

PVector[] puntos;
float r_path = tamcelda;

void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
  
}

void setup()
{
  frameRate(DRAW_FREQ);
  porcentajeObstaculos = 30;
  tamcelda = 15;
  nrows = DISPLAY_SIZE_Y/tamcelda;
  ncols = DISPLAY_SIZE_X/tamcelda;
  pos_celda = new PVector();
  a =  color(255,0,0);
  b =  color(255,255,255);
  inicio = new PVector(14, 5);
  fin = new PVector(40, 50);
  
  numVehiclesCamino = 5;
     
  grid = new Grid(nrows, ncols, tamcelda, porcentajeObstaculos, inicio, fin);
  camino = new Camino(grid, inicio, fin, Lab);
  repeticiones = 2;
  println("filas: " + nrows + "  columnas: " + ncols);
  //output = createWriter("tiempoBusqueda.txt");
  antes = millis();
}

void draw(){
  background(100);
  frameRate(50);
  
  //grid.display();  
  
  /*
  dibujarObstaculos();
  dibujarLab();
  dibujarLcer();
  Lab = camino.busqueda();
  grid.dibujarCelda(grid._F.copy(), a);
  grid.dibujarCelda(grid._I.copy(), b);
  dibujarCAMINO();
  */
  dibujarObstaculos();
  dibujarCAMINO();
  
  if(camino._finbusqueda)
  {
     if(repeticiones > 0)
     {
       
       camino._Lab.clear();
       camino._Lcer.clear();
       camino.CAMINO.clear();
       
       grid = new Grid(nrows, ncols, tamcelda, porcentajeObstaculos, inicio, fin);
       camino = new Camino(grid, inicio, fin, Lab);
       
       //iniciarBoids();
       repeticiones--;
     }
     else
     {
       if(repeticiones == 0)
       {
         iniciarBoids();
         repeticiones--;
       }
        else
         flock.run();
         
         
     }
     
  }else
  {    
    dibujarLab();
    dibujarLcer();
    Lab = camino.busqueda();
    grid.dibujarCelda(grid._F.copy(), a);
    grid.dibujarCelda(grid._I.copy(), b);    
  }
    
  
  //println("tamaño de obstaculos: " + grid._obstaculos.size());
}

void reset()
{
  
}

void mouseClicked()
{
  //Lab = camino.busqueda();    
}

void dibujarLab()
{
   PVector pos = new PVector();
   for(Nodo n:Lab)
   {
      pos = n._pos.copy().mult(tamcelda);
      fill(0,0,255);
      rect(pos.x, pos.y, tamcelda, tamcelda);
   }
}
void dibujarLcer()
{
  PVector pos = new PVector();
   for(Nodo n:camino._Lcer)
   {
      pos = n._pos.copy().mult(tamcelda);
      fill(0,110,255);
      rect(pos.x, pos.y, tamcelda, tamcelda);
   }
}

void dibujarCAMINO()
{
  PVector pos = new PVector();
  //println();
  
   for(Nodo n:camino.CAMINO)
   {
      pos = n._pos.copy().mult(tamcelda);
      fill(255,255,255);
      rect(pos.x, pos.y, tamcelda, tamcelda);
   }
}

void dibujarObstaculos()
  {
     //noStroke();
     fill(color(0,255,0));
     for(PVector v:grid._obstaculos)
       rect(v.x*tamcelda, v.y*tamcelda, tamcelda, tamcelda);
  }
  
  void iniciarBoids()
  {
    PVector pos = new PVector();
    //vehicle = new Vehicle[serieCaminos.size()*numVehiclesCamino];
    int auxPos = 0;
      
        for(int i = 0; i < camino.CAMINO.size(); i++)
         {
             if(i == 0)
               puntos = new PVector[camino.CAMINO.size()];
               
              pos = camino.CAMINO.get(i)._pos.copy().mult(tamcelda);
              puntos[(camino.CAMINO.size()-1)-i] = new PVector(pos.x + (int)(tamcelda/2), pos.y+(int)(tamcelda/2));
         }
         PVector nodoInicio = puntos[0].copy();
         for(int m = 0; m < numVehiclesCamino; m++)
         {
           //r_path no parece usarse
           Vehicle v = new Vehicle(nodoInicio, puntos, r_path);
           flock.addVehicle(v);
         }
    
     
  }
