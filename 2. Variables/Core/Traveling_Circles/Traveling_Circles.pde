float a,b,c,d,e,f,g,h;


void setup(){
  size(400,400);
  a = width/2; c = width/2; e = width/2; g = width/2;
  b = height/2; d = height/2; f = height/2; h = height/2;
}

void draw(){
  ellipse(a,b,60,60);
  ellipse(c,d,60,60);
  ellipse(e,f,60,60);
  ellipse(g,h,60,60);
  a+=1; c-=1; e+=1; g-=1;
  b+=1; d-=1; f-=1; h+=1;
  
}
