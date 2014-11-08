/* --------------------------------------------------------------------------
 * SimpleOpenNI User Example
 * --------------------------------------------------------------------------
 * Combined with Anna's Starburst 
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
SimpleOpenNI kinectGlobal;

User user1;
User user2;
User user3;


PVector com = new PVector();                                   
PVector com2d = new PVector();                                   


void setup() {
  size(640, 480);

  kinectGlobal = new SimpleOpenNI(this);
  if (kinectGlobal.isInit() == false) {         // check for plugged in Kinect
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }
  PVector com2d = new PVector(0, 0);

  // enable depthMap generation 
  kinectGlobal.enableDepth();

  // enable skeleton generation for all joints
  kinectGlobal.enableUser();

  // get user list
}

void draw() {
  // update the cam
  kinectGlobal.update();

  // draw depthImageMap
  //image(kinectGlobal.depthImage(),0,0);
  image(kinectGlobal.userImage(), 0, 0);

  user1.findCoM(kinectGlobal, 1);
  user2.findCoM(kinectGlobal, 2);
  user3.findCoM(kinectGlobal, 3);
  
}    

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  println("onVisibleUser - userId: " + userId);
}


