boolean TF = false;
int M_WIDTH = 1080;
int M_HEIGHT = 640;
int OX = M_WIDTH/2;
int OY = M_HEIGHT/2;
int V = 2;
int OBJ_MAX =2;

int max = 20;
int amax = 0;
float _sr;
float _vr;
Particle first;

void setup(){
  size(M_WIDTH, M_HEIGHT , P2D);
  stroke(1);
  translate(OX, OY);
  
   _sr = 1;
   _vr = 0.5;
   first = new Particle();
   Particle p = first;
   for (int i =0; i < max; i++){
     p.ang = i * 360/max;
     p.vang =1;
     p.r =10;
     p.vr = 0;
     p.x = OX;
     p.y = OY;
     if(i != max -1){
       p.next = new Particle();
       p= p.next;
     }
   }
  
}

void draw(){
  float ang,ax,ay,rr,anga,px,py,r,ran = 0;
  int cnt = 0;
  Particle p = first;
  
  while (p!=null){
    cnt++;
    if(p.r>400){
      p = p.next;
      continue;
    }
    ran = random(1);
    if (ran<0.1){
      p.vang =0;
      p.vr =0;
    }
    else if (ran<0.2){
      p.vang = -V;
      p.vr =0;
    }
    else if (ran < 0.3){
      p.vang = V;
      p.vr= 0;
    }
    else if (ran <0.304 && amax < OBJ_MAX){
      Particle newP = new Particle();
      newP.ang = p.ang;
      if (p.vang == 0){
        newP.vang =0;
      }
      else {
        newP.vang = (random(1) <0.5)? -1:1;
      }
      newP.r = p.r;
      if(p.vang ==0){
        newP.vr =1;
      }
      else{
        newP.vr=0;
      }
      newP.x = p.x;
      newP.y = p.y;
      newP.next = p.next;
      p.next = newP;
    }
    r = p.ang+p.vang;
    p.r = p.r +p.vr;
    //g.moveTo(p.x,p.y);
    ang = PI/180 *r;
    ax = p.r * cos(ang);
    ay = p.r * sin(ang);
    
    rr = sqrt(ax*ax +ay*ay);
    
    anga = PI/180 * (r - (r - p.ang)/2);
    px = rr *cos(anga);
    py = rr * sin(anga);
    
    line(px+OX, py +OY,ax +OX, ay+OY);
    p.y = ay+OY;
    p.ang = r;
    p = p.next; 
  }
  
  if(_sr < 400 && TF){
         if(_vr < 8) _vr += _vr/30;
       _sr = _sr + _vr;
       ellipse(OX,OY,_sr,_sr);
  }
}


void mouseClicked() {

}

class Particle{
  float ang;
  float vang;
  float r;
  float vr;
  float x;
  float y;
  Particle next;
}

