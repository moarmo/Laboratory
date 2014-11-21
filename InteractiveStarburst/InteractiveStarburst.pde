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

User[] user = new User[3];

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
  /*
  for (int mu = 0; mu < user.length; mu++) {   // initialize users
   int userId = mu + 1;
   user[mu] = new User(kinectGlobal, userId, com2d);
   println("The user[" + mu + "], and userId: " + userId + ", user: " + user[mu].userId);
   }
   
   */

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
    user[i] = new User(kinectGlobal, userId, com2d);

    // find their CoM (if true)
    if (kinectGlobal.getCoM(userId, position)) {  

      kinectGlobal.convertRealWorldToProjective(position, com2d);  // com2d gets updated here, doesn't need to be assigned
      user[i].com2d = com2d;
    } else {
      user[i].com2d = new PVector(width/2, height/2);
    }

    user[i].starburst = new Starburst(new PVector(), 10);
    user[i].starburst.position = com2d;
    println(userId + " Starburst's com2d: " + user[i].starburst.position );


    // show User number at CoM point  
    textSize(40);
    fill(255, 0, 0);
    text(userId, com2d.x, com2d.y);

    println("userList size: " + userList.size() + " User Id Number: " + userId);

    /*
      // If our user was previously inactive, we'll give it a new starburst
     if (user[i].isActive == false) {
     user[i].isActive = true;
     user[i].starburst = new Starburst(new PVector(), 15);
     }
     */

    // Turn all the users that weren't active off
    //  We're looping through the user list, starting at where the previous loop left off
    //   for (i = userList.length; i < user.length; i++){
    //     user[i].isActive = false;
    //   }
    /// Draw starBurst 
    //    for (i = 0; i < user.length; i++) {
    //    if (user[i].isActive == true){
    //      println("Drawing starburst for user " + i );

    user[i].starburst.update();
    if ( com2d.x < (SHUFFLE_BUFFER) || com2d.x > (width - SHUFFLE_BUFFER) ) {
      onLostUser(kinectGlobal, userId);
      //        starburst[i].shuffleEndPts();
    } else {
      user[i].starburst.display();
      /// Draw Heart
      //        image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
    }
    //}
  }
}

/* --------------------------------------------------------------------------
 */

void onNewUser(SimpleOpenNI curContext, int userId) {
  println("onNewUser - userId: " + userId);
  ///////////////////////////////////////////// shuffle
  int star = userId - 1;
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

