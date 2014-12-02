class Starfield {

  float perlinStepX = 0;
  float perlinStepY = 5000;
  float perlinStepZ = 1300;
  //float randomSeed, float density

  int moveX;
  int moveY;
  int moveZ;

  Starfield(int _moveX, int _moveY, int _moveZ) {
    //    moveX = width/2;
    //    moveY = height/2;
    //    moveZ = tan(PI*30.0 / 180.0);
    moveX = _moveX;
    moveY = _moveY;
    moveZ = _moveZ;
  }

  void globularCluster(int x_, int y_, int z_, int angle) {
    pushMatrix();
    translate(x_, y_, z_);
    rotate(angle); 
    float perlinStepX = 0;
    float perlinStepY = 5000;      
    float perlinStepZ = 1300;
    for (int i=0; i<80; i++) {
      float x = map(noise(perlinStepX), 0, 1, 0, 50);
      float y = map(noise(perlinStepY), 0, 1, 0, 50);
      float z = map(noise(perlinStepZ), 0, 1, 0, 50);

      stroke(255);
      point(x, y, z);

      perlinStepX += 1;
      perlinStepY += 1;
      perlinStepZ += 1;
    }
    popMatrix();
  }

  void galaxy(int x_, int y_, int z_, int angle) {
    pushMatrix();
    translate(x_, y_, z_);
    rotate(angle); 
    float perlinStepX = 0;
    float perlinStepY = 5000;      
    float perlinStepZ = 1300;

    for (int i=0; i<150; i++) {
      float x = map(noise(perlinStepX), 0, 1, 0, 30);
      float y = map(noise(perlinStepY), 0, 1, 0, 70);
      float z = map(noise(perlinStepZ), 0, 1, 0, 70);

      stroke(255);
      point(x, y, z);

      perlinStepX += 1;
      perlinStepY += 1;
      perlinStepZ += 1;
    }
    popMatrix();
  }

  void display(int _moveX, int _moveY, int _moveZ) {
    float perlinStepX = 0;
    float perlinStepY = 875;      
    float perlinStepZ = 1300;    
    //    lights();
    //    translate(width, 0, -100);
    //    sphere(10);
    //int dColor = 15;  

    pushMatrix();
    translate(_moveX, _moveY, _moveZ);

    starfield.galaxy(50, 30, -50, 25);

    // add perlin noise to scatter star distribution
    for (int i=0; i<350; i++) {
      float x = map(noise(perlinStepX), 0, 1, -240, width+200 );
      float y = map(noise(perlinStepY), 0, 1, -240, height+140);
      float z = map(noise(perlinStepZ), 0, 1, -490, 150);

      stroke(255);
      point(x, y, z);
      //            noStroke();
      //            ambient(dColor, 26, 0); // color of sphere
      //            translate(x, y, z);
      //            sphere(4);

      perlinStepX += .5;
      perlinStepY += .5;
      perlinStepZ += .1;
      //      dColor = dColor % 255;
      //      dColor += 25;
    }
    popMatrix();
  }
}
