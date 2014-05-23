int PARTICLES = 5000;
int SPEED = 1;
int POWER = 100;
ArrayList<Particle> mParticles;

void setup(){
  size(1080, 640 , P2D);
  stroke(245,236,217);
  mParticles = new ArrayList<Particle>();
  
  for(int i = 0; i<PARTICLES; i++){
    Particle particle = new Particle();
    particle.x = random(1)* width ;
    particle.y = random(1)* height ;
    particle.dx = 0;
    particle.dy = 0;
    particle.lastX = particle.x;
    particle.lastY = particle.y;
    mParticles.add(particle);
    particle.colour = color(245,236,217);
  }
}

void draw(){
    fill(59,59,59,100);
    noStroke();
    rect(0, 0, width, height);

    Float angle;
    for(Particle particle : mParticles){
      particle.lastX = particle.x;
      particle.lastY = particle.y;
    
      angle = atan2( particle.y - mouseY, particle.x - mouseX );
      particle.dx -= SPEED * cos(angle);
      particle.dy -= SPEED * sin(angle);
      particle.x += particle.dx;
      particle.y += particle.dy;
      particle.x *= 0.97;
      particle.y *= 0.97;
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
    particle.dx += randPower * cos(randAngle);
    particle.dy += randPower * sin(randAngle);  
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


