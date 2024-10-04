float x;


void setup(){
  size(400,400);
  x=width/2;
}

void draw(){
  ellipse(x,x,60,60);
  ellipse(height-x,x,60,60);
  ellipse(x,height-x,60,60);
  ellipse(height-x,height-x,60,60);
  x+=1;
}
