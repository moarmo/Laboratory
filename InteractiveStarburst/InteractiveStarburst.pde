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

PImage heartImg;

User[] user = new User[6];

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
    //   println("The user[" + mu + "], and userId: " + userId + ", user: " + user[mu].userId);
  }

  heartImg = loadImage("heart.png");
  println("= project initialized =");

  //  font = loadFont("NasalizationRg-Regular-60.vlw");
  font = loadFont("HelveticaNeue-Thin-60.vlw");
  textFont(font, 30);
}

/* -------------------------------------------------------------------------- */

void draw() {
  kinectGlobal.update();   // update the cam
  image(kinectGlobal.userImage(), 0, 0);   // draw depthImageMap
  //  background(15);
  fill(0, 102, 153);
  text("want to see my spaceship?", 2/width, 40);

  IntVector userList = new IntVector();
  kinectGlobal.getUsers(userList);

  // Get a list of all the users the camera currently sees
  for (int i=0; i < userList.size () && i < user.length; i++) {
    int userId = userList.get(i);
    PVector position = new PVector(); 

    // find their CoM (if true)
    // tests if starburst was in last frame, update, otherwise continue on 
    if (kinectGlobal.getCoM(userId, position) && user[i].isActive == true) {    
      kinectGlobal.convertRealWorldToProjective(position, com2d);  // com2d gets updated here, doesn't need to be assigned
      user[i].com2d = com2d;
      user[i].starburst.position = com2d;
      user[i].isActive = true;  // redundant?
      user[i].starburst.update();
      println("First Loop: CoM found, isActive TRUE; Found User " + userId);

      // tests case where there is a new user
    } else if (kinectGlobal.getCoM(userId, position)) {
      kinectGlobal.convertRealWorldToProjective(position, com2d);
      user[i].starburst = new Starburst(com2d, 10);
      user[i].isActive = true;
      user[i].starburst.update();      
      user[i].starburst.display();
      println("STARBURST MADE");
      println("Second Loop: CoM found, isActive was FALSE; Found User " + userId);

      // tests for last case: no updated CoM means user & CoM is not detected
    } else {
      user[i].isActive = false;
      println("Third Loop: NO CoM found, isActive is FALSE; User in this loop: " + userId);
    }

    // show User number at CoM point  
    textSize(40);
    fill(255, 0, 0);
    text(userId, com2d.x, com2d.y);
    println("userList size: " + userList.size() + " User Id Number: " + userId);

    // test when CoM is at the edge, display if not at edge
    if ( com2d.x < (SHUFFLE_BUFFER) || com2d.x > (width - SHUFFLE_BUFFER) ) {
      //  onLostUser(kinectGlobal, userId);
      user[i].starburst.shuffleEndPts();
    } else {
      user[i].starburst.display();
      /// Draw Heart
      image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
    }
  }
}

/* --------------------------------------------------------------------------
 */

void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  int star = userId - 1;
  /// shuffle
  user[star].starburst.shuffleEndPts();
  text("found you", width/2, 20);
  println("I got shuffled onNewUser");
}

void onLostUser(SimpleOpenNI curContext, int userId) {
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId) {
  //  println("onVisibleUser - userId: " + userId);
}

