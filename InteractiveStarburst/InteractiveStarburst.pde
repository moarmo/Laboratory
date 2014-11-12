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
    user[mu] = new User(kinectGlobal, nu, com2d);    // nullPointerException
    println("Ima mu number: " + mu);
    println("nu number: " + nu);
  }

  ///////////////////////////////////////////// initialize starBurst
  for (int i = 0; i < starburst.length; i++) {
    starburst[i] = new StarRay(com2d);
  }
  heartImg = loadImage("heart.png");
  println("project initialized");
}

void draw() {
  kinectGlobal.update();   // update the cam
  image(kinectGlobal.userImage(), 0, 0);   // draw depthImageMap
  //  background(100);

  int[] userList = kinectGlobal.getUsers();
  for (int i=0; i<userList.length; i++) {
    // find their CoM
    int usrId = i+1;
    println("user number: " + user[i] + " userId: " + usrId);
    com2d = user[i].findCoM(kinectGlobal, usrId);
    println(com2d + " from inside draw loop, userlist for loop");

    /// Draw Starburst 
    for (int j = 0; j < starburst.length; j++) {   
      starburst[j].update(com2d);
      starburst[j].display();
    }
    /// Draw Heart
    image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
  }
}    
/*     ------------------------------------------     */

void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");

  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId) {
  println("onVisibleUser - userId: " + userId);
}

// deep copy
// working on an instance
// 

