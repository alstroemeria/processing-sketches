import processing.opengl.*;
int radius = 100;

ArrayList<MovingNode> nodes;
float maxDistance = 60;
float dx = 100;
float dy = 100;
float maxNeighbors = 20;
Boolean drawMode = false;


void setup() {
  size(1080, 640, P2D);
  stroke(255);
  nodes = new ArrayList<MovingNode>();
}

void draw() {
  background(59,59,59,59);
  addNewNode(random(width), random(height), 0, 0);
  
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
    if ( currentNode.x < -10 ||  currentNode.y < -10  || currentNode.x > width +10 ||  currentNode.y > height+10 )
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
      line(currentNode.x, currentNode.y, neighborNode.x, neighborNode.y);
    }
    currentNode.display();
  }
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
    ellipse(x,y,nodeWidth,nodeHeight);
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


