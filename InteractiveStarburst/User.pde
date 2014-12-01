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
    context = kinectLocal;
    boolean isActive = false;
    starburst = new Starburst(new PVector(), 15);
  }

  void setCoM(SimpleOpenNI kinectLocal, int _userId, PVector _com2d) {
    userId = _userId;
    com2d = _com2d;
    starburst.position = com2d;
  }
  
  void search(SimpleOpenNI kinectLocal, PVector _com2d){
    com2d = _com2d;
  }
}

