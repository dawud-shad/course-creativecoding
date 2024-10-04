float xPosition;  // -- Horizontal starting position on 'x' axis in coordinate space
float xVelocity; // -- Horizontal speed in x-direction
float radius;
 
void setup()
{
  size(400,300);
  fill(255,177,8);
  textSize(48);
 
  xPosition = width/2;  // -- Initialise xPosition to centre of sketch
  xVelocity = -2; // -- Initialise speed in x-direction to -2 (moving left)
  radius = 50;
}
 
void draw()
{
  background(64);
 
 
  xPosition = xPosition + xVelocity;  // -- Change position in x on each redraw by velocity in x
  
  circle(xPosition, height/2,radius);
  
  if (xPosition-(radius/2) <= 0){
    xVelocity = -xVelocity;
  }
  else if (xPosition + (radius/2)>=width){
    xVelocity = -xVelocity;
  }
  
}
