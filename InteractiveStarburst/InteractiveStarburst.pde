/* --------------------------------------------------------------------------
 * SimpleOpenNI User Example
 * --------------------------------------------------------------------------
 * Combined with Anna's starBurst 
 * ----------------------------------------------------------------------------
 */

import SimpleOpenNI.*;
SimpleOpenNI kinectGlobal;

PFont font;

StarRay[] starRay = new StarRay[15];
Starburst[] starburst = new Starburst[5];
PImage heartImg;

User[] user = new User[3];

PVector com = new PVector();
PVector com2d = new PVector();        

int SHUFFLE_BUFFER = 25;

/* --------------------------------------------------------------------------
 */
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

  for (int mu = 0; mu < user.length; mu++) {   // initialize users
    int userId = mu + 1;
    user[mu] = new User(kinectGlobal, userId, com2d);
       println("The user[" + mu + "], and userId: " + userId + ", user: " + user[mu].userId);
  }

  /// initialize starBurst
  for (int i = 0; i < starburst.length; i++) {
    starburst[i] = new Starburst(new PVector(), 15);
  }
  heartImg = loadImage("heart.png");
  println("= project initialized =");

  //  font = loadFont("NasalizationRg-Regular.ttf");
  //  textFont(font, 32);
}

/* --------------------------------------------------------------------------
 */

void draw() {
  kinectGlobal.update();   // update the cam
  image(kinectGlobal.userImage(), 0, 0);   // draw depthImageMap
  background(20);

  int[] userList = kinectGlobal.getUsers();
  // NEED SOMETHING in here about shuffling with new users
  for (int i=0; i<userList.length; i++) {
    // find their CoM
    if (kinectGlobal.getCoM(userList[i], com)) {  
      kinectGlobal.convertRealWorldToProjective(com, com2d);  // com2d gets updated here, doesn't need to be assigned
      user[i].com2d = com2d;
 //     user[i].setCoM(kinectGlobal, userList[i] , com2d);
      
      // DEBUG:
      println("After user[i].setCoM....");
      println("userList[i]: " + i + ", User number: " + user[i].userId 
      + ", com2d" + com2d + ", user: " + user[i].userId);
    }
    // how do i check the user list to be sure it has new users? 

    /// Draw starBurst 
    for (int j = 0; j < userList.length; j++) {
      //j =+ 1;
      starburst[j].update(com2d);  
   //   starburst[j].display();
      // DEBUG:
      println("After user[j].starburst.update....");
      println("userList[i]: " + i + ", User number: " + user[i].userId + ", com2d" + com2d);
      if ( com2d.x < (SHUFFLE_BUFFER) || com2d.x > (width - SHUFFLE_BUFFER) ) {
      } else {
        starburst[j].display();
      }
    }
    /*
    /// Draw starBurst 
     for (int k = 0; k < userList.length; k++) {
     for (int j = 0; j < starBurst.length; j++) {   
     starBurst[j].update(com2d);
     if ( com2d.x < (SHUFFLE_BUFFER) || com2d.x > (width - SHUFFLE_BUFFER) ) {
     starBurst[j].shuffle();
     // println("I am shuffled, with a com2d.x value of " + com2d.x);
     } else {
     starBurst[j].display();
     }
     }
     */
  }
  /// Draw Heart
  image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
        // DEBUG:
//      println("After drawing heart....");
//      println("userList[i]: n/a," + " User number: n/a , com2d" + com2d);

}

/* --------------------------------------------------------------------------
 */

void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  ///////////////////////////////////////////// shuffle
  int star = userId -1;
  user[star].starburst.shuffleEndPts();
//  starburst.display();
  println("I got shuffled onNewUser");
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId) {
  //  println("onVisibleUser - userId: " + userId);
}

