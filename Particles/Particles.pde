int PARTICLES =2000;
int SPEED = 3;
int POWER = 200;

ArrayList<Particle> mParticles;

void setup(){
  size(640, 360);
  mParticles = new ArrayList<Particle>();
  
  for(int i = 0; i<PARTICLES; i++){
    Particle particle = new Particle();
    particle.x = random(1)* width ;
    particle.y = random(1)* height ;
    particle.dx = 0;
    particle.dy = 0;
    particle.lastX = particle.x;
    particle.lastY = particle.y;
    particle.colour = color(255);
    mParticles.add(particle);
  }
}

void draw(){
    background(0);
    
    Float angle;
    for(Particle particle : mParticles){
      particle.lastX = particle.x;
      particle.lastY = particle.y;
      
      angle = atan2( particle.y - mouseY, particle.x - mouseX );
      particle.dx -= SPEED * cos(angle);
      particle.dy -= SPEED * sin(angle);
      particle.x += particle.dx;
      particle.y += particle.dy;
      particle.x *= 0.95;
      particle.y *= 0.95;

      stroke(particle.colour);
      line( particle.lastX, particle.lastY, particle.x, particle.y);
    }
}

void mouseClicked() {
  float randAngle;
  float randPower;
  for(Particle particle : mParticles){
    randAngle = random(1)* PI*2;
    randPower = random(1)* POWER/2;
    particle.dx = randPower * cos(randAngle);
    particle.dy = randPower * sin(randAngle);  
  } 
}

class Particle{
  float x;
  float y;
  float dx;
  float dy;
  float lastX;
  float lastY;
  color colour;
}

