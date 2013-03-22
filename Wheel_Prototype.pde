int width = 640;
int height = 360;
int fps = 60;
//--
float posX = width/2;
float posY = height/2;
float startX=posX;
float startY=posY;
float endX=posX;
float endY=posY;
float circleSize = width/2;
//--
float rotOffset = 135;
float rotDeg = rotOffset;
float rotStartPoint = rotDeg;
float rotDeltaMin = 0;
float rotDelta = rotDeltaMin;
float rotDeltaMax = 50;
float frictionMin = 0.01;
float frictionMax = 0.02;
float friction = random(frictionMin,frictionMax);
boolean clicked = false;
boolean spinLeft = false;
//--
int alphaNum = 150;
float stopMoving = 0.05;
float distNum = 0;
float distThreshold=stopMoving;
int distCounter = 0;
color dotColorOn = color(255,0,0);
color dotColorOff = color(0);
color dotColor = dotColorOff;
int numLines = 10;
boolean nowSpinning = false;
boolean singleSpin = false;
float toggleBoxX = width-35;
float toggleBoxY = height-35;
float toggleBoxSize = 30;
float fontSize = 14;
PFont font;
int winNum = 5;
//--
boolean hitCircle = true; //if true, circle only goes when you hit it
boolean twoWay = true; //if true, you can spin circle either way

//-----------------

void setup() {
  size(width,height);
  frameRate(fps);
  smooth();
  font = createFont("Arial",fontSize);
  textFont(font,fontSize);
}

void draw() {
  background(200);
  drawWheel();
  spinWheel();
  toggleBox(toggleBoxX,toggleBoxY,toggleBoxSize);
  winner(10,20);
  println("mouseX: " + mouseX + "   mouseY: " + mouseY + "   rotDeg: " + rotDeg + "   rotDelta: " + rotDelta +"   dist: " + distNum + "   game spin: " + nowSpinning);
}

//------------------

void mousePressed() {
  if((!nowSpinning&&!hitCircle)||(!nowSpinning&&hitCircle&&hitDetect(mouseX,mouseY,5,5,posX,posY,circleSize,circleSize))) {
    clicked=true;
    startX = mouseX;
    startY = mouseY;
    friction = random(frictionMin,frictionMax);
  }
}

void mouseReleased() {
  clicked=false;
  endX = mouseX;
  endY = mouseY;
  distCounter=0;
  if(hitDetect(mouseX,mouseY,5,5,toggleBoxX,toggleBoxY,toggleBoxSize,toggleBoxSize)) {
    if(singleSpin) {
      singleSpin=false;
    } 
    else if(!singleSpin) {
      singleSpin=true;
      rotDeg = rotStartPoint;
      rotDelta = 0;
    }
  }
}


void drawWheel() {
  pushMatrix();
  translate(posX,posY);
  rotate(radians(rotDeg));
  strokeWeight(2);
  stroke(0);
  fill(255);
  ellipseMode(CENTER);
  ellipse(0,0,circleSize,circleSize);
  drawLabels();
  fill(dotColor,100);
  ellipse(-93,92,circleSize/8,circleSize/8);
  popMatrix();
  stroke(200,0,0);
  line(posX,6,posX,33);
}

void spinWheel() {
  if(clicked) {
    dotColor = dotColorOn;
    distNum = dist(startX,startY,mouseX,mouseY);
    if(distNum>distThreshold) {
      if(singleSpin==true) {
        nowSpinning=true;
      }
      distCounter++;
      rotDelta = distNum/distCounter;
    }
    spinRules();
    if(!singleSpin) {
      stroke(0,alphaNum);
      line(startX,startY,mouseX,mouseY);
      noStroke();
      fill(0,100,0,alphaNum);
      ellipse(startX,startY,circleSize/14,circleSize/14);
      fill(100,0,0,alphaNum);
      ellipse(mouseX,mouseY,circleSize/14,circleSize/14);
    }
  } 
  else if(!clicked) {
      rotDelta*=1-friction;
  }
  if(rotDelta<stopMoving&&rotDelta>-1*stopMoving) {
    dotColor=dotColorOff;
    rotDelta=0;
    nowSpinning=false;
  }
  rotDeg+=rotDelta;
  if(rotDeg<=-360||rotDeg>=360) {
    rotDeg=0;
  }
}

void spinRules(){
  float spinRulesGap = circleSize/8;
 if(!singleSpin){
   stroke(255,0,0,33);
   fill(255,0,0,25);
  rectMode(CORNER);
  rect((width/2)-(circleSize/2),(height/2)-(spinRulesGap/2),circleSize,spinRulesGap);
 }
  if(twoWay){
    if(startY<(height/2)-spinRulesGap||startY>(height/2)+spinRulesGap){
     if(startX>mouseX && startY<height/2) {
      rotDelta *= -1;
      spinLeft=false;
    } 
    else if(startX<mouseX && startY<height/2) {
      rotDelta = abs(rotDelta);
      spinLeft=true;
    } 
    else if(startX>mouseX && startY>=height/2) {
      rotDelta = abs(rotDelta);
      spinLeft=true;
    } 
    else if(startX<mouseX && startY>=height/2) {
      rotDelta *= -1;
      spinLeft=false;
    }
    } else {
      if(mouseX>=width/2){
    if(mouseY>startY){
      rotDelta = abs(rotDelta);
      spinLeft=true;

    } else if (mouseY<startY){
      rotDelta *= -1;
      spinLeft=false;

    }
      } else if(mouseX<width/2){
          if(mouseY>startY){
      rotDelta *= -1;
      spinLeft=false;

    } else if (mouseY<startY){
      rotDelta = abs(rotDelta);
      spinLeft=true;

    }
  }
    }
  }
}

void drawLabels(){
    float rotLines = 360/numLines;
  int labelCounter=1;
  for(int i=0;i<numLines;i++) {
    rotate(radians(rotLines));
    line(0,0,112,112);
    fill(0);
    pushMatrix();
    translate(-17,125);
    rotate(radians(190));
    text(labelCounter,0,0);
    popMatrix();
    labelCounter++;
  }
}

void winner(float x, float y) {
  float q = 360/numLines;
  float startPoint = 117;

  // can be streamlined, but watch out for problems
  if((rotDeg<startPoint+(1*q)&&rotDeg>=startPoint+(0*q)) || (rotDeg<startPoint-(360-(1*q))&&rotDeg>=startPoint-(360-(0*q)))) {
    winNum=1;

  } else if((rotDeg<startPoint+(2*q)&&rotDeg>=startPoint+(1*q)) || (rotDeg<startPoint-(360-(2*q))&&rotDeg>=startPoint-(360-(1*q)))) {
    winNum=10;

  } else if((rotDeg<startPoint+(3*q)&&rotDeg>=startPoint+(2*q)) || (rotDeg<startPoint-(360-(3*q))&&rotDeg>=startPoint-(360-(2*q)))) {
    winNum=9;

  } else if((rotDeg<startPoint+(4*q)&&rotDeg>=startPoint+(3*q)) || (rotDeg<startPoint-(360-(4*q))&&rotDeg>=startPoint-(360-(3*q)))) {
    winNum=8;

  } else if((rotDeg<startPoint+(5*q)&&rotDeg>=startPoint+(4*q)) || (rotDeg<startPoint-(360-(5*q))&&rotDeg>=startPoint-(360-(4*q)))) {
    winNum=7;

  } else if((rotDeg<startPoint+(6*q)&&rotDeg>=startPoint+(5*q)) || (rotDeg<startPoint-(360-(6*q))&&rotDeg>=startPoint-(360-(5*q)))) {
    winNum=6;

  } else if((rotDeg<startPoint+(7*q)&&rotDeg>=startPoint+(6*q)) || (rotDeg<startPoint-(360-(7*q))&&rotDeg>=startPoint-(360-(6*q)))) {
    winNum=5;

  } else if((rotDeg<startPoint-(360-(-2*q))&&rotDeg>=startPoint-(360-(-3*q))) || (rotDeg<startPoint-(360-(8*q))&&rotDeg>=startPoint-(360-(7*q)))) {
    winNum=4;

  } else if((rotDeg<startPoint-(360-(-1*q))&&rotDeg>=startPoint-(360-(-2*q))) || (rotDeg<startPoint-(360-(9*q))&&rotDeg>=startPoint-(360-(8*q)))) {
    winNum=3;

  } else if((rotDeg<startPoint-(360-(0*q))&&rotDeg>=startPoint-(360-(-1*q))) || (rotDeg<startPoint-(360-(10*q))&&rotDeg>=startPoint-(360-(9*q)))) {
    winNum=2;

  } else {
    winNum = 5;
  }
   
  fill(0);
  text("winner: ",x,y);
  text(winNum,x+60,y);
}

void toggleBox(float x, float y, float s) {
  stroke(0);
  fill(255);
  rectMode(CENTER);
  rect(x,y,s,s);
  if(!singleSpin) {
    pushMatrix();
    translate(0-s/2,0-s/2);
    line(x,y,x+s,y+s);
    line(x+s,y,x,y+s);
    popMatrix();
  }

  fill(0);
  text("debug",x-60,y+5);
}

boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
  w1 /= 2;
  h1 /= 2;
  w2 /= 2;
  h2 /= 2; 
  if(x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
    return true;
  } 
  else {
    return false;
  }
}

