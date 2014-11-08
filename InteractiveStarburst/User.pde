import SimpleOpenNI.*;

class User {

  PVector com2d;
  SimpleOpenNI context;
  int[] userList;
  int userId;

  User(SimpleOpenNI kinectLocal, int _userId, PVector _com2d) {
    //    _userId = userId;
    //    _com2d = com2d;
    kinectLocal = context;
    userList = context.getUsers();  // i'm in a feedback loop
    /// do I want the class to determine user # or new object to get created 
    /// with every new user?
  }

  void findCoM(SimpleOpenNI kinectLocal, int _userId) {
    kinectLocal = context;
    context.getCoM(_userId, com);
    context.convertRealWorldToProjective(com, com2d);
    _userId = userId;
  }
}

