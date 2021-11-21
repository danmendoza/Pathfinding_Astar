
// Seek_Arrive

// The "Vehicle" class

class Vehicle {
  
  PVector position, velocity, acceleration;
  PVector target, positionFuture, normalPoint;
  PVector[]path;
  int pointToGo;
  boolean inside;
  float xangle, yangle;
  float r;
  float radius, radius_path;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  float dt;
  
  float prediction;
  
  
  Vehicle(PVector inicio, PVector[]points_path, float r_path) {
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    position = inicio.copy();
    positionFuture = position.copy().add(velocity.copy().normalize().mult(prediction));
    r = 3;
    
    //a cuanta distancia detecta el target
    radius = 6;
    
    radius_path = r_path;
    maxspeed = 5;
    maxforce = 2.6;
    dt = 0.2;
    
    prediction = 30;
    path = points_path;
    pointToGo = 0;//iterador del array de puntos
  }
  
  void run(ArrayList<Vehicle> vehicles) {
    
    flock(vehicles); 
    seek();
    update();   
    display();
  }
  
  void flock(ArrayList<Vehicle> vehicles) {
    PVector sep = separate(vehicles);   // Separation
    
    // Arbitrarily weight these forces
    sep.mult(1.5);
    // Add the force vectors to acceleration
    applyForce(sep);

  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(PVector.mult(acceleration, dt));
    // Limit speed
    velocity.limit(maxspeed);
    
    positionFuture = position.copy().add(velocity.copy().normalize().mult(prediction));
    position.add(PVector.mult(velocity, dt));
    
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // A method that calculates a steering force towards a target
  void seek() {
    
    PVector desired = new PVector();
    PVector normalPoint = getNormalPoint();  
    
    float distanceFromPath = abs(PVector.sub(positionFuture.copy(), normalPoint.copy()).mag());
    
    
    if(distanceFromPath > radius_path && pointToGo != 0)
      target = getNormalPoint();
    else 
      target = path[pointToGo].copy();
        
    desired = PVector.sub(target.copy(),position.copy());  // A vector pointing from the position to the target    
    
    float distance = abs(PVector.sub(target,position.copy()).mag());
    
    //arrive
    if(distance < radius)    
    {      
        
        float m = map(distance,0,radius,0,maxspeed);
        desired.setMag(m);
        
        //si no estaba dentro del punto objetivo actual
        if(inside != true)
        {
          if(pointToGo < path.length-1) 
          {
            pointToGo++; 
            inside = true;
          }
          else 
          {
            path = reversePath(path);
            pointToGo = 0; 
            desired.setMag(0);
            inside = false;
          }
        }          
    }
    else //estaba dentro del radio del punto objetivo actual
    {
        desired.setMag(maxspeed);
        inside = false;
    }
    
    PVector steer = PVector.sub(desired,velocity);
    
    steer.limit(maxforce);  // Limit to maximum steering force
        
    applyForce(steer);    
  }
  
    // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Vehicle> vehicles) {
    float desiredseparation = 15.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Vehicle other : vehicles) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) 
    {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }



  PVector getNormalPoint()
  {
    PVector a = new PVector();
    PVector b = new PVector();
    PVector normalPoint = new PVector();
    PVector aux = new PVector();
    PVector start, end;
    
    if(pointToGo > 0 && pointToGo < path.length)
    {
       start = path[pointToGo-1].copy();  
    }
    else
    {
       start = path[path.length-1].copy();
    }
    end = path[pointToGo].copy();
    
    a = PVector.sub(positionFuture.copy(), start.copy());
    
    b = PVector.sub(end.copy(), start.copy());
    b.normalize();
    b.mult(a.dot(b));
    
    aux = start.copy().add(b);
    
    if(abs(PVector.sub(end, aux.copy()).mag()) < abs(PVector.sub(end, start).mag()))
      normalPoint = aux;
    else
      normalPoint = end;
    
    return normalPoint;
  }
    
  void display() {
    
    //dibujamos el radio en cada target del path    
    
    /*
    for(int i = 0; i < path.length; i++)
      ellipse(path[i].x, path[i].y, radius*2, radius*2);
     */
     
    strokeWeight(1);
    fill(255);
    
    
    /*dibujamos el target actual en rojo y la prediccion en verde
    fill(255, 0, 0);
    ellipse(target.x, target.y, 5, 5);
    fill(0, 255, 0);
    ellipse(positionFuture.copy().x, positionFuture.copy().y, 5, 5);
    */
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;
    fill(127);
    stroke(0,100);
    strokeWeight(1);
    pushMatrix();
    translate(position.x,position.y);
    rotate(theta);
    beginShape();
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
    popMatrix();      
  }
  
  //para recorrer el camino inverso, le damos la vueta a la lista de puntos 
  //que conformaban el path inicial
  PVector[] reversePath(PVector[] camino)
  {
     PVector[] aux = new PVector[camino.length];
     for(int i = 0; i < camino.length ; i++)
       aux[i] = camino[(camino.length -1) - i];
    return aux;
  }
}
