import processing.opengl.*;
int radius = 100;

ArrayList<MovingNode> nodes;
float maxDistance = 65;
float dx = 30;
float dy = 30;
float maxNeighbors = 10;
Boolean drawMode = false;


void setup() {
  size(500, 300, OPENGL);
  background(220);
  stroke(255);
  nodes = new ArrayList<MovingNode>();
}

void draw() {
  background(220);
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.003);
  rotateX(frameCount * 0.004);
  float s = 0;
  float t = 0;
  float lastx = 0;
  float lasty = 0;
  float lastz = 0;


  if (drawMode) {
    if (mousePressed) {
      addNewNode(mouseX, mouseY, random(-dx, dx), random(-dx, dx));
    }
  }
  else {
    addNewNode(random(360), random(360), 0, 0);
  }

  //set neighbours
  for (int i=0; i<nodes.size(); i++)
  {
    MovingNode currentNode = nodes.get(i);
    currentNode.setNumNeighbors( countNumNeighbors(currentNode, maxDistance) );
  }

  //remove out of bounds
  for (int i=0; i<nodes.size(); i++)
  {
    MovingNode currentNode = nodes.get(i);
    if ( currentNode.x < 0 ||  currentNode.y < 0)
    {
      nodes.remove(currentNode);
    }
  }


  for (int i = 0; i < nodes.size(); i++) {
    MovingNode currentNode = nodes.get(i);
    for (int j=0; j<currentNode.neighbors.size(); j++)
    {
      MovingNode neighborNode = currentNode.neighbors.get(j);
      float lineColor = currentNode.calculateLineColor(neighborNode, maxDistance);
      stroke(lineColor, lineColor, lineColor);
      //line(currentNode.x, currentNode.y, neighborNode.x, neighborNode.y);



      xyz coord = mapFromPlaneToSphere(currentNode.x/360, currentNode.y/360);
      xyz coord2 = mapFromPlaneToSphere(neighborNode.x/360, neighborNode.y/360);
      //println(currentNode.x + " "+ currentNode.y);

      line(coord.x, coord.y, coord.z, coord2.x, coord2.y, coord2.z);
    }
    currentNode.display();
  }

  //  while (t < 180) {
  //    s += 2.8;
  //    t += 0.1;
  //    float radianS = radians(s);
  //    float radianT = radians(t);
  //    float thisx = 0 + (radius * cos(radianS) * sin(radianT));
  //    float thisy = 0 + (radius * sin(radianS) * sin(radianT));
  //    float thisz = 0 + (radius * cos(radianT));
  //    if (lastx != 0) {
  //      line(thisx, thisy, thisz, lastx, lasty, lastz);
  //    }
  //    lastx = thisx;
  //    lasty = thisy;
  //    lastz = thisz;
  //  }
}

class xyz
{
  float x, y, z;
  xyz(float _x, float _y, float _z)
  {
    x=_x;
    y=_y;
    z=_z;
  }
} 

// x and y in [0,1]
xyz mapFromPlaneToSphere(float x, float y) {
  float z = -1 + 2 * x;
  float phi = 2 * PI * y;
  float theta = asin(z);
  return new xyz( radius* cos(theta) * cos(phi), 
  radius* cos(theta) * sin(phi), 
  radius* z);
}

void addNewNode(float xPos, float yPos, float dx, float dy)
{
  MovingNode node = new MovingNode(xPos+dx, yPos+dy);
  node.setNumNeighbors( countNumNeighbors(node, maxDistance) );

  if (node.numNeighbors < maxNeighbors) {
    nodes.add(node);
  }
}

int countNumNeighbors(MovingNode nodeA, float maxNeighborDistance)
{
  int numNeighbors = 0;
  nodeA.clearNeighbors();

  for (int i = 0; i < nodes.size(); i++)
  {
    MovingNode nodeB = nodes.get(i);
    float distance = sqrt((nodeA.x-nodeB.x)*(nodeA.x-nodeB.x) + (nodeA.y-nodeB.y)*(nodeA.y-nodeB.y));
    if (distance < maxNeighborDistance)
    {
      numNeighbors++;
      nodeA.addNeighbor(nodeB);
    }
  }
  return numNeighbors;
}

void keyPressed()
{
  drawMode = !drawMode;
  nodes = new ArrayList<MovingNode>();
}

class MovingNode
{
  float x;
  float y;
  int numNeighbors;
  ArrayList<MovingNode> neighbors;
  float lineColor;
  float nodeWidth = 3;
  float nodeHeight = 3;
  float fillColor = 50;
  float lineColorRange = 180;

  float xVel=0;
  float yVel=0;
  float xAccel=0;
  float yAccel=0;

  float accelValue = 0.5;

  float startX;
  float startY;
  float kGravity = 0.01;

  MovingNode(float xPos, float yPos)
  {
    startX = xPos;
    startY = yPos;

    x = xPos;
    y = yPos;
    numNeighbors = 0;
    neighbors = new ArrayList<MovingNode>();
  }

  void display()
  {
    move();

    noStroke();
    fill(fillColor);
    //ellipse(x,y,nodeWidth,nodeHeight);
  }

  void move()
  {    
    xAccel = (startX - x) * kGravity + random(-accelValue, accelValue);
    yAccel = (startY - y) * kGravity + random(-accelValue, accelValue);

    xAccel = random(-accelValue, accelValue);
    if (xAccel != 0) {
      xAccel *= 1/(1 + abs(startX - x));
      if ((startX-x < 0 && xAccel > 0) || (startX-x > 0 && xAccel < 0))
      {
        xAccel *= -1;
      }
    }

    yAccel = random(-accelValue, accelValue);
    if (yAccel != 0) {
      yAccel *= 1/(1 + abs(startY - y));
      if ((startY-y < 0 && yAccel > 0) || (startY-y > 0 && yAccel < 0))
      {
        yAccel *= -1;
      }
    }

    xVel += xAccel;
    yVel += yAccel;

    x += xVel;
    y += yVel;
  }

  void addNeighbor(MovingNode node)
  {
    neighbors.add(node);
  }

  void setNumNeighbors(int num)
  {
    numNeighbors = num;
  }

  void clearNeighbors()
  {
    neighbors = new ArrayList<MovingNode>();
  }

  float calculateLineColor(MovingNode neighborNode, float maxDistance)
  {
    float distance = sqrt((x-neighborNode.x)*(x-neighborNode.x) + (y-neighborNode.y)*(y-neighborNode.y));
    lineColor = (distance/maxDistance)*lineColorRange;
    return lineColor;
  }
}

