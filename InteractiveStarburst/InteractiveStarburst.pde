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
Starfield starfield;
User[] user = new User[6];

PImage heartImg;

PVector farScreen = new PVector(1410, 1055); // at z = -500
PVector com2d = new PVector();        

int SHUFFLE_BUFFER = 25;

int circleRadius = 200;
//float zOffset = -500;  // z translation of "portHole" from origin
float initCamDist = tan((PI*30)/180);
//float scaleRatio = abs((initCamDist + zOffset)/initCamDist);
//float scaleRatio = 2;
//float portHoleRadius;

int BG_COLOR = 20;

PVector searchPos = new PVector();

float stepx, stepy;  
float tx, ty;


/* --------------------------------------------------------------------------
 */
void setup() {
  size(640, 480, P3D);
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

  starfield = new Starfield(0, 0, 0);
}

/* -------------------------------------------------------------------------- */

void draw() {
  kinectGlobal.update();   // update the cam
  image(kinectGlobal.userImage(), 0, 0);   // draw depthImageMap
  background(BG_COLOR);
  camera();

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
      user[i].starburst.update();
      println("First Loop: CoM found, isActive TRUE; Found User " + userId);
      println("Ray start 'offset' point: " + user[i].starburst.rays[0].rayOffset);
      println("Ray End point: " + user[i].starburst.rays[0].endPt);
      fill(255);
      noStroke();
      textAlign(CENTER);
//      text("where is your heart?", width/2, height - 40);


      // tests case where there is a new user
    } else if (kinectGlobal.getCoM(userId, position)) {
      kinectGlobal.convertRealWorldToProjective(position, com2d);
      user[i].starburst = new Starburst(com2d, 23);
      user[i].isActive = true;
      user[i].starburst.update();      
      user[i].starburst.display();
      println("STARBURST MADE - Second Loop: CoM found, isActive was FALSE; Found User " + userId);

      // tests for last case: no updated CoM means user & CoM is not detected
    } else {
      user[i].isActive = false;
      println("Third Loop: NO CoM found, isActive is FALSE; User in this loop: " + userId);
    }

    // test when CoM is at the edge, display if not at edge
    if ( com2d.x < (SHUFFLE_BUFFER) || com2d.x > (width - SHUFFLE_BUFFER) ) {
      user[i].starburst.shuffleEndPts();
    } else {
      user[i].starburst.display();
      /// Draw black hole same color as background
      noStroke();
      fill(BG_COLOR);
      int rayRadius = user[i].starburst.rays[0].RAY_SIZE;
      //     portHoleRadius = (circleRadius / initCamDist) * (initCamDist + abs(zOffset));
      pushMatrix();
        translate(0, 0, .5);
        ellipse(com2d.x, com2d.y, rayRadius*2, rayRadius*2);  
  
        /// Draw Heart
        image(heartImg, com2d.x-heartImg.width/2, com2d.y-heartImg.height/2);
      popMatrix();
    }
  }

  // ------- Scenario when NO USERS PRESENT - Installation Idle
  if (userList.size() < 1) {
    background(255);
    // Circle "searches" using Perlin Noise
    stepx = map(noise(tx), 0, 1, -10, 10);
    stepy = map(noise(ty), 0, 1, -10, 10);

    searchPos.add(stepx, stepy, 0);

    tx += 0.01; // want it to move more horizontally than vertically
    ty += 0.008; 

    // Moves the Ellipse behind the stars!
    pushMatrix();
    translate(-385, -288, -500);  // offset of back plane that "telescope" circle is on
    noStroke();
    fill(BG_COLOR);
    ellipse(searchPos.x, searchPos.y, circleRadius*2, circleRadius*2);
    popMatrix();

    //// When Ellipse moves out of center of screen 
    int offset = circleRadius;
    if (searchPos.x > farScreen.x + offset) {
      // assign search pos to opposite side
      searchPos.x = 0 - offset;
    } else if (searchPos.x < 0 - offset) {
      searchPos.x = farScreen.x + offset;
    } 
    if (searchPos.y > farScreen.y + offset) {
      searchPos.y = 0 - farScreen.y;
    } else if (searchPos.y < 0 - offset) {
      searchPos.y = farScreen.y + offset;
    }

    //  display starField & globular clusters
    starfield.display(int(searchPos.x/3), int(searchPos.y/3), 0);    ////  ?
    starfield.globularCluster(100, 30, 10, 45);
    starfield.globularCluster(width/2, height/2, 20, 60);
    starfield.globularCluster(600, 200, -10, -90);
    starfield.galaxy(650, 300, 10, 125);
    starfield.globularCluster(305, 424, -100, 65);
    starfield.galaxy(250, 370, 10, 125);
    /*
    pushMatrix();
     translate(-385, -288, -500);  // FINALLY found offset
     noFill();  
     stroke(0, 200, 0);
     rect(0, 0, 1410, 1055);  // actual size of plane at z: -500
     popMatrix();
     */
  }
}

/* -------------------------------------------------------------------------- */

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

