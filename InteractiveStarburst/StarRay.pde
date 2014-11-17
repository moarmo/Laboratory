class StarRay {

  PVector startPt;
  PVector endPt;
  PVector mouse;
  PVector rayOffset;
  PVector centerOfMass;
  int shuffleCount;

  StarRay(PVector _centerOfMass) {
    startPt = new PVector(width/2, height/2);
    centerOfMass = new PVector(_centerOfMass.x, _centerOfMass.y);
    mouse = new PVector(mouseX, mouseY);
    endPt = new PVector(random(width), random(height));
    rayOffset = new PVector(width/2, height/2);
    shuffleCount = 0;
  }

  void update(PVector currentCom2d) {
    centerOfMass.x = currentCom2d.x; 
    centerOfMass.y = currentCom2d.y;
    rayOffset = PVector.sub(endPt, centerOfMass);
    rayOffset.setMag(30);
    rayOffset.add(centerOfMass);
  }

  void shuffle() {
    endPt.x = random(0, width);
    endPt.y = random(0, height);
    shuffleCount+=1;
  }

  void display() {
    stroke(0, 50);
    strokeWeight(2);
    stroke(0, 90); //darker
    strokeWeight(2);
    line(rayOffset.x, rayOffset.y, endPt.x, endPt.y);
  }
}

