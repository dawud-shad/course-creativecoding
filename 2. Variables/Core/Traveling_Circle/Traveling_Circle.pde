float x;
float y;

void setup(){
  size(400,400);
  x = width/2;
  y = height/2;
}

void draw(){
  ellipse(x,y,60,60);
  x-=1;
  y-=1;
  
}
