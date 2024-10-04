float xPos;
float yPos;
float radius = 50;
float rectWidth = 130;
float rectHeight = 20;

void setup(){
  size(200, 300);

  xPos = random(rectWidth / 2, width - rectWidth / 2);
  yPos = random(radius, height - radius);
}

void draw(){
  background(150);
  fill(255);

  boolean insideRect = mouseX >= xPos - rectWidth/2 && mouseX <= xPos + rectWidth/2 && mouseY >= yPos - rectHeight/2 && mouseY <= yPos + rectHeight/2;

  boolean insideCircle = dist(mouseX, mouseY, xPos, yPos) <= radius/2;

  if (insideCircle && !insideRect) {
    fill(255, 0, 0);
  }

  circle(xPos, yPos, radius);

  if (insideRect) {
    fill(31, 40, 203);
  } else {
    fill(255);
  }

  rectMode(CENTER);
  rect(xPos, yPos, rectWidth, rectHeight);
}
