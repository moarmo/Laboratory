import SimpleOpenNI.*;

class User {

  PVector com2d;
  SimpleOpenNI context;
  public int userId;
  Starburst starburst;
  boolean isActive;

  User(SimpleOpenNI kinectLocal, int _userId, PVector _com2d) {
    PVector com = new PVector();                                   
    PVector com2d = new PVector();                                   

    userId = _userId;
    com2d = _com2d;
    // mystarburst = starray;
    context = kinectLocal;
//    userList = context.getUsers();
    isActive = false;
    starburst = new Starburst(new PVector(), 15);
  }

  // make "setter" method - can change or make this addition later (anything that's optional) 
  void setStarRay(Starburst _starburst) {
    starburst = _starburst;
  }

  void setCoM(SimpleOpenNI kinectLocal, int _userId, PVector _com2d) {
    userId = _userId;
    com2d = _com2d;
    starburst.position = com2d;
  }
}

