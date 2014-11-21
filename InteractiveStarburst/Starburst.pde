class Starburst {

  PVector position;  // same as com2d
  StarRay[] rays;

  Starburst(PVector com2d, int rayNum) {  // so you pass in: CoM, Ray object, # of rays?, 
    //constructor
    position = com2d;
    rays  = new StarRay[rayNum];
    for (int i = 0; i< rays.length; i++) {
      rays[i] = new StarRay(position);
    }
  }

  void update() {
    //loop for making multiple rays
    for (int j = 0; j < rays.length; j++) {   
      rays[j].update(position);
    }
  }

  void display() {
    for (int j = 0; j < rays.length; j++) {   
      rays[j].display();
    }
  }
  void shuffleEndPts() {
    for (int i=0; i< rays.length; i++) {
      rays[i].shuffle();
    }
  }
}

