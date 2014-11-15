import SimpleOpenNI.*;

class User {

  PVector com;
  PVector com2d;
  SimpleOpenNI context;
  int[] userList;
  public int userId;
  StarRay mystarburst;

  User(SimpleOpenNI kinectLocal, int _userId, PVector _com2d) {
    PVector com = new PVector();                                   
    PVector com2d = new PVector();                                   

    userId = _userId;
    com2d = _com2d;
    // mystarburst = starray;
    context = kinectLocal;
    userList = context.getUsers();
  }

  // make "setter" method - can change or make this addition later (anything that's optional) 
  void setStarRay(StarRay starray)
  {
    mystarburst = starray;
  }

  PVector findCoM(SimpleOpenNI kinectLocal, int _userId) {
    context = kinectLocal;
    if (context == null){
      PVector defaultV = new PVector(width/2,height/2);
      return defaultV;
    }
    userId = _userId;
    println("userId = " + userId);
    println("com = " + com);  // com is null

    if (context.getCoM(1, com)) {  // nullPointerException the second i move into frame
    println("com2d: " + com2d);
      context.convertRealWorldToProjective(com, com2d); // function is void, can't assign to variable...whatever =/      

    }
    return com2d;
  }
}

