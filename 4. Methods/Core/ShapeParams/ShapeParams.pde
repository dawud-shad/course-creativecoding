float rectHeight;

void setup(){
  size(400, 400);
  background(255);
  rectHeight = 20;
}

void shape(float xCenter,float yCenter, float scale)
{
  fill(random(0,255));
  circle(xCenter, yCenter, scale * 125);
  
  fill(random(0,255));
  circle(xCenter, yCenter, scale * 50);
  
  fill(random(0,255),random(0,255),random(0,255));
  rectMode(CENTER);
  rect(xCenter, yCenter - rectHeight/2 - 25, scale * 250, scale * rectHeight);
}

void draw(){
  
  shape(width/2, height/2, 1);
  shape(random(0,width),random(0,height), random(0, 2));

}
