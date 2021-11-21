class Nodo
{
  int _id;  // Identification number
  PVector _pos;
  ArrayList<Nodo> _sucesores;
  Nodo _padre;
  color _color;
  float _costeG, _costeH;
  PVector _target;
  boolean _sucesoresGenerados;
  float _G;
  
  
  Nodo(PVector pos, PVector target)
  {
    _pos = pos;
    _target = target;
    _sucesoresGenerados = false;
    _G = 1;
  }

  
  void setSucesores(ArrayList<Nodo> sucesores)
  {
     _sucesores = sucesores;
     _sucesoresGenerados = true;
  }
  
  void printSucesores()
  {
     for(Nodo n:_sucesores)
       println(n._pos);
  }
  
  //obtenemos el coste real
  float getH()
  {
    _costeH = abs(PVector.sub(_target.copy(), _pos.copy()).mag());
    return _costeH;
  }
  
  float getG(Nodo nodoPadre)
  {
    if(this._pos != this._target)
      return _G + nodoPadre._costeG;
    else
      return 0f;
  }
  
  void incrementG()
  {
    this._G++;
  }
  
  float getF()
  {
    return getG(_padre) + getH();
  }
  
  void setPadre(Nodo n)
  {
      _padre = n;
  }


}
