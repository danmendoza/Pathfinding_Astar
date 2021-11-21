// The Flock (a list of Vehicle objects)

class Flock {
  ArrayList<Vehicle> vehicles; // An ArrayList for all the Vehicles

  Flock() {
    vehicles = new ArrayList<Vehicle>(); // Initialize the ArrayList
  }

  void run() {
    for (Vehicle b : vehicles) {
      b.run(vehicles);  // Passing the entire list of Vehicles to each Vehicle individually
      //b.max
    }
  }

  void addVehicle(Vehicle b) {
    vehicles.add(b);
  }
}
