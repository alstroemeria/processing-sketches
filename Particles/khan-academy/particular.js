var SPEED = 1;
var POWER = 100;
var NUM_PARTICLES = 1000;
var particles= [];
var f = createFont("sans-serif");
textFont(f); 
textSize(8); 

var Particle = function(x, y, dx, dy, lastX, lastY) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.lastX = lastX;
    this.lastY = lastY;
};

var init = function(){
    for (var x = 0; x < NUM_PARTICLES; x++) {
        var randX =  random(1)* width ;
        var randY =  random(1)* width ;
        particles.push(new Particle(randX,randY,0,0,randX,randY));
    }
};

var mouseClicked = function() {
    var randAngle;
    var randPower;
    var particle;
    for(var i = 0; i< NUM_PARTICLES; i++){
        randAngle = random()* 360;
        randPower = random()* POWER/2;
        particles[i].dx += randPower * cos(randAngle);
        particles[i].dy += randPower * sin(randAngle);  
    } 
}; 

var signature = function(data){
    fill(100);
    text(data, width-59, height-9);
};

init();

draw = function() {
    fill(59,59,59,100);
    noStroke();
    rect(0, 0, width, height);
    stroke(245,236,217);
    
    var angle;
    for(var i = 0; i< NUM_PARTICLES; i++) {
        particles[i].lastX = particles[i].x;
        particles[i].lastY = particles[i].y;
        angle = atan2( particles[i].y - mouseY, particles[i].x - mouseX );
        particles[i].dx -= SPEED * cos(angle);
        particles[i].dy -= SPEED * sin(angle);
        particles[i].x += particles[i].dx;
        particles[i].y += particles[i].dy;
        particles[i].x *= 0.97;
        particles[i].y *= 0.97;
        line( particles[i].lastX, particles[i].lastY, particles[i].x, particles[i].y);
    }
    signature("PARTICULAR");
};