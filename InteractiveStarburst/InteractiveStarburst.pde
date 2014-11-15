/* --------------------------------------------------------------------------
 * SimpleOpenNI User Example
 * --------------------------------------------------------------------------
 * Combined with Anna's Starburst 
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
SimpleOpenNI kinectGlobal;

StarRay[] starburst = new StarRay[10];
PImage heartImg;

// make array of User objects 
User[] user = new User[3];

PVector com = new PVector();                                   
PVector com2d = new PVector(width/2, height/2);                                   

void setup() {
  size(640, 480);

  kinectGlobal = new SimpleOpenNI(this);
  if (kinectGlobal.isInit() == false) {         // check for plugged in Kinect
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  kinectGlobal.enableDepth();
  kinectGlobal.enableUser();

  for (int mu = 0; mu < user.length; mu++) { 
    int nu = mu +1;
    user[mu] = new User(kinectGlobal, nu, com2d);
  }

  /// initialize starBurst
  for (int i = 0; i < starburst.length; i++) {
    starburst[i] = new StarRay(com2d);
  }
  heartImg = loadImage("heart.png");
  println("= project initialized =");
}

void draw() {
  kinectGlobal.update();   // update the cam
  image(kinectGlobal.userImage(), 0, 0);   // draw depthImageMap
  background(255);

  int[] userList = kinectGlobal.getUsers();
  // NEED SOMETHING in here about shuffling with new users
  for (int i=0; i<userList.length; i++) {
    // find their CoM
    if (kinectGlobal.getCoM(userList[i], com)) {  
      kinectGlobal.convertRealWorldToProjective(com, com2d);
    }

    /// Draw Starburst 
    for (int k = 0; k < userList.length; k++) {
      for (int j = 0; j < starburst.length; j++) {   
        starburst[j].update(com2d);
        starburst[j].display();
      }
//      starburst.shuffle();
    }
    /// Draw Heart
    image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
  }

  /*
  // make a vector of ints to store the list of users
   IntVector userList = new IntVector();
   // write the list of detected users
   // into our vector
   kinect.getUsers(userList);
   if (userList.size() > 0) {    // if we found any users
   int userId = userList.get(0);   // get the first user
   */
}    
/*     ------------------------------------------     */

void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  ///////////////////////////////////////////// shuffle
  for (int i = 0; i < starburst.length; i++) {      
    starburst[i].shuffle();
    starburst[i].display();
  }
  println("I got shuffled onNewUser");
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId) {
  println("onVisibleUser - userId: " + userId);
}

