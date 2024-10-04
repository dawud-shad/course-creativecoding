void setup(){
  size(600,400);
}

void draw(){
  background(0,0,0);
  fill(245,62,62);
  circle(mouseX,mouseY,250);
  
  fill(255,255,255);
  circle(mouseX,mouseY,140);
  
  fill(31,59,234);
  rect(mouseX-150,mouseY-30,300,55);
  
  //textAlign(CENTER,CENTER);
  fill(255,255.255);
  textSize(44);
  text("UNDERGROUND",mouseX-150,mouseY+15);
}
