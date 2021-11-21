class Camino
{
  
    ArrayList<Nodo> _Lab, _Lcer, _sucesores, CAMINO;
    Grid _grid;
    Nodo _actual, _inicial, _actualAux, _final;
    boolean _encontrado, _modSucesores, _finbusqueda, _continuabusqueda;
    int _iteraciones ;
    int _limiteRadix = 5;
    
    
    Camino(Grid grid, PVector inicial, PVector fin, ArrayList<Nodo>  Lab) 
    {
      _Lcer = new ArrayList<Nodo>();
      _Lab = new ArrayList<Nodo>();
      _grid = grid;
      _inicial = new Nodo(inicial, fin);
      _actual = new Nodo(inicial, fin);
      CAMINO = new ArrayList<Nodo>();
      
      _actualAux = new Nodo(new PVector(), new PVector());
      _actualAux.setPadre(new Nodo(new PVector(), new PVector()));
      _actual.setPadre(new Nodo(new PVector(), new PVector()));
      _actual._padre._costeG = 0;
      _final = new Nodo(fin, fin);
      _Lab = Lab;
      _iteraciones = 0;
      _modSucesores = false;
      _finbusqueda = false;
      addLab(_actual);
      _encontrado = false;
    }
    
    ArrayList<Nodo> busqueda()
    {
      
      _continuabusqueda = (_Lab.size() > 0 && _iteraciones < _Lab.size() && !_encontrado);
      
      if(!_continuabusqueda)
        _finbusqueda = true;
      
      while(_continuabusqueda)
      {
          
          
          _actual = _Lab.get(_iteraciones);
          

          while(/*_actual._pos.equals(_actualAux._padre._pos)*/Contiene(_Lcer, _actual))
          {
            //_actualAux.incrementG();
            _iteraciones++;
            if(_iteraciones < _Lab.size())
              _actual = _Lab.get(_iteraciones);
            else
            {
              return _Lab;
            }
              

            _modSucesores = true;
          }
           
          if(Contiene(_Lab, _actual))
            Borrar(_Lab, _actual);
           
           
          if(!Contiene(_Lcer,_actual))
            addLcer(_actual);
            

          
                         
          if((_actual._pos.x == _final._pos.x) && (_actual._pos.y == _final._pos.y))
          {
              _encontrado = true;
              //devolver CAMINO
          }
          else
          {
              //vemos si se han creado sucesores
              if(!_actual._sucesoresGenerados)
              {
                  _sucesores = generarSucesores(_actual);//se crean nuevos nodos, por eso entra siempre en el primer condicional
                  _actual.setSucesores(_sucesores);
              }
              
              else//en el caso de que esten creados le asociamos los que ya tenia
              {
                _sucesores = _actual._sucesores;
                println("sucesores YA generados");                
              }
                  
                
              if(_modSucesores)
              {
                //println(_actualAux._pos);
                //println(Borrar(_sucesores,_actualAux));
                _modSucesores = false;
              }
               
                
              for(Nodo v:_sucesores)
              {                
                   if(Contiene(_Lab, v) == false && Contiene(_Lcer,v) == false) 
                   {                      
                      addLab(v);
                   }
                   
                   if(Contiene(_Lab, v))
                   {
                       //si el coste en llegar al padre actual es mayor que el del nodo actual
                       //el nodo actual es ahora el padre
                        if(v.getG(v._padre) >= v.getG(_actual))
                        {
                            v._padre = _actual;
                            _iteraciones = -1;
                        }                     
                          else
                          {
                            Borrar(_Lab,v);
                          }

                     }
                     
                     else if(Contiene(_Lcer,v))
                     {
                         if(v.getG(v._padre) >= v.getG(_actual))
                          {
                              v._padre = _actual;
                              addLab(v);
                          }                                      
                     }                    
              } 
             
          }
          _iteraciones++;
          
          _actualAux = _actual;

          return _Lab;
      }//END WHILE
      
      return getCamino();
    }
    
    //esta funcion devuelve True si el Nodo nodo se encuentra en la Lista
    boolean Contiene(ArrayList<Nodo> Lista, Nodo nodo)
    {
      boolean existe = false;
      for(Nodo n:Lista)        
        if(nodo._pos.x == n._pos.x && nodo._pos.y == n._pos.y)        
          existe = true;
          
       return existe; 
    }
    
    boolean Borrar(ArrayList<Nodo> Lista, Nodo nodo)
    {
      boolean borrado = false;
      
      for(int i = 0; i < Lista.size(); i++)
      {
        if(nodo._pos.x == Lista.get(i)._pos.x && nodo._pos.y == Lista.get(i)._pos.y)
        {
          Lista.remove(Lista.get(i));
          borrado = true;
        } 
      }
        
          
       return borrado; 
    }
    
    
    
    ArrayList<Nodo> generarSucesores(Nodo n)
    {
       ArrayList<Nodo> sucesoresList = new ArrayList<Nodo>(4);
       ArrayList<PVector> vecinos = new ArrayList<PVector>();
       vecinos = _grid.getVecinos(n._pos);
       
       for(PVector v:vecinos)
       {
         Nodo x = new Nodo(v, _final._pos);
         sucesoresList.add(x);
         x.setPadre(n);         
       }         
       return sucesoresList;
    }
    
    void addLcer(Nodo n)
    {
         _Lcer.add(n);
    }
    
    void dibujarLcer()
    {
       PVector pos = new PVector();
       for(Nodo n:_Lcer)
       {
          pos = n._pos.copy().mult(tamcelda);
          fill(0,255,0);
          beginShape();
            vertex(pos.x, pos.y);
            vertex(pos.x + tamcelda, pos.y);
            vertex(pos.x + tamcelda, pos.y + tamcelda);
            vertex(pos.x, pos.y + tamcelda);
          endShape(CLOSE);
       }
       
    }
    
    void dibujarLab()
    {
       PVector pos = new PVector();
       for(Nodo n:_Lab)
       {
          pos = n._pos.copy().mult(tamcelda);
          fill(0,0,255);
          beginShape();
            vertex(pos.x, pos.y);
            vertex(pos.x + tamcelda, pos.y);
            vertex(pos.x + tamcelda, pos.y + tamcelda);
            vertex(pos.x, pos.y + tamcelda);
          endShape(CLOSE);
       }
    }
    void addLab (Nodo n)
    {
      _Lab.add(0,n);
      //SORTING//
      _Lab = LSDRadixSort(_Lab);

    }
    
    ArrayList<Nodo> LSDRadixSort(ArrayList<Nodo> List)
    {
     
      ArrayList<ArrayList<Nodo>> buckets = new ArrayList<ArrayList<Nodo>>(10);

      
      if(buckets.size() == 0)
        for(int i = 0; i <= 9; i++)
          buckets.add(new ArrayList<Nodo>());
      
      //_limiteRadix marca cuantos digitos queremos evaluar
      for(int i = 0; i <= _limiteRadix; i++)
      {
          int pos = 0;
          
          for(int j = 0; j < 10; j++)
          {
             buckets.get(j).clear();
          }
          
          
          //println(List.size());
          for(int j = 0; j < List.size() ; j++)
          {
            
             int d = digit(i, List.get(j).getF());
            
             buckets.get(d).add(List.get(j));
          }
          
          
          for(int b = 0; b < buckets.size(); b++)
          {
             for(int e = 0; e < buckets.get(b).size(); e++)
             {  
                 
                 List.remove(buckets.get(b).get(e));
                 List.add(pos, buckets.get(b).get(e));
                 pos++;
             }
             
          }
      }
     
      return List;
    }
    
    //funcion complementaria del radixsort
    //obtiene el digito en la posición i del numero num
    int digit(int i, float num)
    {
        num*=1000;
        int nx = (int)num;//los nums seran decimales de una unidad por lo general. cogemos 4 decimales
        
        int[] digits = new int[i+1];
        int iter = 0;

        do {
            digits[iter] = nx%10;
            nx /= 10;
            iter++;
            
        }while (iter <= i);
        
        int d = digits[i];
        
        
        return d;
    }
    
    
    
      //devuelve el nodo
    PVector getNodo(PVector v)
    {
      v = _grid.getCelda(v);

      
      //devolvemos de forma inversa pues la matriz esta construida segun lógica del metodo matematico
      return _grid._grid[(int)v.x][(int)v.y];
    }
    
    void printInfo()
    {
        println("Iteraciones:  " + _iteraciones); 
        println("Pos actual:  " + _actual._pos);
        println("tamaño de Lab:  " + _Lab.size());
    }
    
    ArrayList<Nodo> getCamino()
    {
      //ArrayList<Nodo> camino = new ArrayList<Nodo>();
      if(!_encontrado)
        return CAMINO;
      
      Nodo caminante = _actual;
      CAMINO.add(_actual);
      //println(caminante._padre._pos);
      while(caminante._padre._pos != _inicial._pos)
      {        
          CAMINO.add(caminante._padre);
          caminante = caminante._padre;
      }
      
      //println("tamaño del camino: " + CAMINO.size());
      
       _finbusqueda = true;
      return CAMINO;
      
    }
  
  
}
