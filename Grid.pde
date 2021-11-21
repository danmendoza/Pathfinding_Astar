class Grid 
{
  
  int _nRows, _nCols, _numCells; 
  float _tamcelda;
  color c;
  int _celda;
  PVector[][] _grid;
  ArrayList<PVector> _obstaculos;
 
  //ArrayList<Nodo> _nodos;
  int vecinoUp,vecinoDown, vecinoLeft , vecinoRight;
  PVector _I, _F;
  
  Grid(int nRows, int nCols, float cellSize, float porcentajeObs, PVector inicio, PVector fin)
  {
     _nRows = nRows;
     _nCols = nCols;
     _tamcelda = cellSize;
     _numCells = _nCols*_nRows;
     _grid = new PVector[_nCols][_nRows];
     _obstaculos = new ArrayList<PVector>();
     
     _I = inicio;
     _F = fin;
     crearIndices();
     crearObstaculos(porcentajeObs);
     
  }


  
  void crearIndices()
  {  
    for(int i = 0; i < _nCols ; i++)
    {
      for(int j=0; j < _nRows ; j++)
      {
         PVector poscelda = new PVector(i, j);
         _grid[i][j] = poscelda;
         //_nodos.add(new Nodo(_indices.indexOf(poscelda), poscelda, _F));
      }   
     }     
  }
  
  void crearObstaculos(float porcentaje)
  {
      
      int numObs =(int)((_nCols*_nRows)*(porcentaje/100));
      //println("numero de obs: " + numObs);
      
      for(int i = 0; i < numObs; i++)
      {
        PVector posObs; 
        do
        {
           posObs = new PVector((int)random(0,_nCols), (int)random(0, _nRows));
        }while(posObs.equals(_I) || Contiene(_obstaculos, posObs) || posObs.equals(_F));
        
        _obstaculos.add(posObs);        
      }
        
     
  }
  
  //función para conocer si la posicion a evaluar, pos, se encuentra dentro del ArrayList de posiciones
  boolean Contiene(ArrayList<PVector> posiciones, PVector pos)
    {
      for(PVector n:posiciones)        
        if(pos.x == n.x && pos.y == n.y)        
          return true;
          
       return false; 
    }
  
  
  //devuelve la celda en coordenadas del grid
  PVector getCelda(PVector v)
  {
    int fila = (int)(v.y/_tamcelda);
    int columna = (int)(v.x/_tamcelda);
    
    
    return _grid[columna][fila];
  }
  
  //obtenemos las celdas vecinas horizontales y verticales.
  //comprobamos en cada caso que no asignamos como vecino a un obstáculo
  ArrayList<PVector> getVecinos(PVector v)
  {
     //v = getCelda(v);
     ArrayList<PVector> vecinos = new ArrayList<PVector>();
     
     if(v.y > 0)
     {
       PVector vNew = new PVector(v.copy().x , v.copy().y-1) ;
       if(!Contiene(_obstaculos, vNew))
         vecinos.add(vNew);
     }
       
            
     if(v.x < (ncols-1))
     {
       PVector vNew = new PVector(v.copy().x+1 , v.copy().y);
       if(!Contiene(_obstaculos, vNew))
         vecinos.add(vNew);
     }
       
     
     if(v.y < (nrows-1))
     {
       PVector vNew = new PVector(v.copy().x , v.copy().y+1) ;
       if(!Contiene(_obstaculos, vNew))
         vecinos.add(vNew);
     }
       
     
     if(v.x > 0)
     {
       PVector vNew = new PVector(v.copy().x-1 , v.copy().y) ;      
       if(!Contiene(_obstaculos, vNew))
         vecinos.add(vNew);
     }
       
     
     return vecinos;
  }
  

  
  void display()
  {
    stroke(0);
    fill(100);
    
     for(int i = 0; i <= _nCols ; i ++)
       line(i*_tamcelda , 0, i*_tamcelda, DISPLAY_SIZE_Y);       
     for(int j = 0; j <= _nRows ; j++)
        line(0 , j*_tamcelda, DISPLAY_SIZE_X, j*_tamcelda);
     
  }
  
  
  
  void dibujarCelda(PVector T, color c)
  {    
    T.mult(tamcelda);
    fill(c);
    beginShape();
      vertex(T.x, T.y);
      vertex(T.x + tamcelda, T.y);
      vertex(T.x + tamcelda, T.y + tamcelda);
      vertex(T.x, T.y + tamcelda);
    endShape(CLOSE);
  }
  
  void dibujarObstaculos()
  {
     for(PVector v:_obstaculos)
       dibujarCelda(v, color(0,255,0));
  }
  

}
