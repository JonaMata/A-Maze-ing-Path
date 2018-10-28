/*  A-Maze-ing by Jonathan Matarazzi 28-10-2018
 This 
 
 */


import java.util.Collections;


Pathfinder pathfinder;
MazeGenerator mazeGenerator;


//Create a 2-dimensional array for the tilemap
int[][] tiles;


ArrayList<Node> nodes;
int tileSize = 50;
int gridWidth, gridHeight;

PImage zeroWall, singleWall, doubleWall, doubleStraightWall, tripleWall, quadrupleWall;

PImage weight1, weight2, weight3;

PImage characterImage;

Character character;

void setup() {
  size(600, 600, P3D);
  //fullScreen(P3D);

  pathfinder = new Pathfinder();
  mazeGenerator = new MazeGenerator();


  //Load all the needed images
  zeroWall = loadImage("zero_wall.png");
  singleWall = loadImage("single_wall.png");
  doubleWall = loadImage("double_wall.png");
  doubleStraightWall = loadImage("double_straight_wall.png");
  tripleWall = loadImage("triple_wall.png");
  quadrupleWall = loadImage("quadruple_wall.png");

  weight1 = loadImage("weight_1.png");
  weight2 = loadImage("weight_2.png");
  weight3 = loadImage("weight_3.png");

  characterImage = loadImage("character.png");


  //Create a new character out of view
  character = new Character(-tileSize, -tileSize);


  //Calculate the amount rows and columns of the grid and make sure it has an odd number of rows and columns
  gridWidth = width/tileSize;
  if (gridWidth % 2 == 0) {
    gridWidth-=1;
  }
  gridHeight = height/tileSize;
  if (gridHeight % 2 == 0) {
    gridHeight-=1;
  }


  //Create a maze with the calculated amound of rows and columns
  tiles = mazeGenerator.createMaze(gridWidth, gridHeight);


  /*
  tiles = new int[gridWidth][gridHeight];
   for (int i = 0; i<gridWidth; i++) {
   for (int j=0; j<gridHeight; j++) {
   tiles[i][j]=round(random(-0.5, 1));
   }
   }
   */



  //Create nodes for all the floor tiles
  nodes = new ArrayList<Node>();
  for (int x =0; x<tiles.length; x++) {
    for (int y=0; y<tiles[x].length; y++) {
      if (tiles[x][y] == 0) {
        nodes.add(new Node(x, y));
      }
    }
  }

  //Place the character on a random node
  Node characterNode = nodes.get(floor(random(0, nodes.size())));
  character.setPos(characterNode.getPos().x*tileSize, characterNode.getPos().y*tileSize);
  character.setPath(new ArrayList<Node>());
}

void draw() {
  println(mouseX+" , "+mouseY);
  background(250);

  //Draw each waal tile
  for (int x=0; x<tiles.length; x++) {
    for (int y=0; y<tiles[x].length; y++) {
      if (tiles[x][y] == 1) {

        //Check where the wall has neighbours
        int right = 0;
        int bottom = 0;
        int left = 0;
        int top = 0;

        if (x+1 < tiles.length) {
          right = tiles[x+1][y];
        }
        if (y+1<tiles[x].length) {
          bottom = tiles[x][y+1];
        }
        if (x-1>=0) {
          left = tiles[x-1][y];
        }
        if (y-1>=0) {
          top = tiles[x][y-1];
        }

        //Pass an array containing data about where the wall has neighbours to the displayWall function
        int[] neighbours = {top, right, bottom, left};
        displayWall(x, y, neighbours);
      }
    }
  }

  //Display all nodes
  for (Node node : nodes) {
    node.display();
  }

  //Update and display the character
  character.setSpeed(nodes);
  character.update();
  character.display();
}

void displayWall(float wallX, float wallY, int[] connections) {
  PImage wallImage = zeroWall;
  int rotation = 0;
  int connectionSum = 0;

  //Get the amount of neighbours a wall has
  for (int connection : connections) {
    connectionSum += connection;
  }

  //Execute the function corresponding to the amount of neighbours to set the correct image and rotation for the wall
  switch(connectionSum) {
  case 0:
    wallImage = zeroWall;
    break;
  case 1:
    rotation=connections[1]*90+connections[2]*180+connections[3]*270;
    wallImage = singleWall;
    break;
  case 2:
    if (connections[0]+connections[2]==2) {
      rotation = 90;
      wallImage = doubleStraightWall;
    } else if (connections[1]+connections[3]==2) {
      wallImage = doubleStraightWall;
    } else if (connections[0] ==1) {
      if (connections[3] ==1) {
        rotation = 270;
      }
      wallImage = doubleWall;
    } else if (connections[2] ==1) {
      if (connections[1] == 1) {
        rotation = 90;
      } else {
        rotation = 180;
      }
      wallImage = doubleWall;
    }
    break;
  case 3:
    rotation = abs((connections[1]-1)*90+(connections[2]-1)*180+(connections[3]-1)*270);
    wallImage = tripleWall;
    break;
  case 4:
    wallImage = quadrupleWall;
    break;
  }


  //Rotate and draw the image of the wall
  pushMatrix();
  translate((wallX+0.5)*tileSize, (wallY+0.5)*tileSize);
  rotate(radians(rotation));
  imageMode(CENTER);
  image(wallImage, 0, 0, tileSize, tileSize);
  popMatrix();
}

void mousePressed() {

  //Check what mouse button has been pressed

  if (mouseButton == LEFT) {
    //Check which tile has been pressed
    int xTile = floor(mouseX/tileSize);
    int yTile = floor(mouseY/tileSize);
    if (xTile < tiles.length && yTile < tiles[0].length) {
      
      //If the pressed tile is a wall, transform it into a floor tile and create a node for it. Then update the path of character
      
      if (tiles[xTile][yTile] == 1) {
        
        tiles[xTile][yTile] = 0;
        nodes.add(new Node(xTile, yTile));


        Node start = character.getNode(nodes);
        Node end = character.getDestNode(nodes);

        if (start != null && end != null) {
          character.setPath(pathfinder.findPath(start, end, nodes));
        }
      }
    }
  } else if (mouseButton == RIGHT) {
    //Create path from the current position of the character to the clicked position
    
    Node start = character.getNode(nodes);
    Node end = null;
    
    //get the clicked tile
    for (Node node : nodes) {
      if (node.pointIsOnNode(mouseX, mouseY)) {
        end = node;
      }
    }
    
    //If the start and end are valid nodes, create and set the path and set the destination
    if (start != null && end != null) {
      character.setPath(pathfinder.findPath(start, end, nodes));
      character.setDest((int)end.getPos().x, (int)end.getPos().y);
    }
  }
}
