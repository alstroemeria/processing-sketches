
int PARTICLES = 1000;
int SPEED = 1;
int MAXPOWER = 100;

ArrayList<Pixel> mPixels;
Point mZero;

void setup(){
  mPixels = new ArrayList<Pixel>();
  
  for(int i = 0; i<PARTICLES; i++){
    Pixel pixel = mew Pixel();
    pixel.x = random(1)* displayHeight ;
    pixel.y = random(1)* displayWidth ;
    pixel.dx = 0;
    pixel.dy = 0;
    pixel.lastX = pixel.x;
    pixel.lastY = pixel.y;
    pixel.colour = color(255);
    mPixels.add(pixel);
  }
  
  //ColourTransform - adjusts colors
  //BlurFilter - Gaussian effect
  mZero = new Point();
  //mouse listeners
}

void draw(){
    background(0);
    
    Float angle;
    for(Pixel pixel : mPixels){
      pixel.lastX = pixel.x;
      pixel.lastY = pixel.y;
      
      angle = atan2( pixel.y - mouseY, pixel.x - mouseX );
      pixel.dx -= SPEED * cos(angle);
      pixel.dy -= SPEED * sin(angle);
      
      pixel.x += 0.95;
      pixel.y += 0.95;

      stroke(pixel.colour);
      line( pixel.lastX, pixel.lastY, pixel.x, pixel.y);
    }
}

class Pixel{
  float x;
  float y;
  float dx;
  float dy;
  float lastX;
  float lastY;
  color colour;
 
}

class Point{
  float x;
  float y;
}

