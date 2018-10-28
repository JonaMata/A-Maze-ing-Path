import java.util.Collections;

Pathfinder pathfinder;
MazeGenerator mazeGenerator;


int[][] tiles;
ArrayList<Node> nodes;
int tileSize = 50;
int gridWidth, gridHeight;

PImage zeroWall, singleWall, doubleWall, doubleStraightWall, tripleWall, quadrupleWall;

PImage weight1, weight2, weight3;

PImage characterImage;

Character character;

void setup() {
  //size(600, 600);
  fullScreen(P3D);
  
  pathfinder = new Pathfinder();
  mazeGenerator = new MazeGenerator();

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

  character = new Character(-tileSize, -tileSize);

  gridWidth = width/tileSize;
  if (gridWidth % 2 == 0) {
    gridWidth-=1;
  }
  gridHeight = height/tileSize;
  if (gridHeight % 2 == 0) {
    gridHeight-=1;
  }

  tiles = mazeGenerator.createMaze(gridWidth, gridHeight);


  /*
  tiles = new int[gridWidth][gridHeight];
   for (int i = 0; i<gridWidth; i++) {
   for (int j=0; j<gridHeight; j++) {
   tiles[i][j]=round(random(-0.5, 1));
   }
   }
   */




  nodes = new ArrayList<Node>();
  for (int x =0; x<tiles.length; x++) {
    for (int y=0; y<tiles[x].length; y++) {
      if (tiles[x][y] == 0) {
        nodes.add(new Node(x, y));
      }
    }
  }

  Node characterNode = nodes.get(floor(random(0, nodes.size())));
  character.setPos(characterNode.getPos().x*tileSize, characterNode.getPos().y*tileSize);
  character.setPath(new ArrayList<Node>());
}

void draw() {
  background(250);

  for (int x=0; x<tiles.length; x++) {
    for (int y=0; y<tiles[x].length; y++) {
      if (tiles[x][y] == 1) {
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

        int[] neighbours = {top, right, bottom, left};
        displayWall(x, y, neighbours);
      }

      fill(255-(tiles[x][y]*255));
      rectMode(CORNER);
      //rect(x*tileSize, y*tileSize, tileSize, tileSize);
    }
  }

  for (Node node : nodes) {
    node.display();
  }
  character.setSpeed(nodes);
  character.update();
  character.display();
}

void displayWall(float wallX, float wallY, int[] connections) {
  PImage wallImage = zeroWall;
  int rotation = 0;
  int connectionSum = 0;
  for (int connection : connections) {
    connectionSum += connection;
  }

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



  pushMatrix();
  translate((wallX+0.5)*tileSize, (wallY+0.5)*tileSize);
  rotate(radians(rotation));
  imageMode(CENTER);
  image(wallImage, 0, 0, tileSize, tileSize);
  popMatrix();
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (int x=0; x<tiles.length; x++) {
      for (int y=0; y<tiles[x].length; y++) {
        if (mouseX >= x*tileSize && mouseX < (x+1)*tileSize && mouseY >= y*tileSize && mouseY < (y+1)*tileSize) {
          if (tiles[x][y] == 1) {
            tiles[x][y] = 0;
            nodes.add(new Node(x, y));


            Node start = null;
            Node end = null;

            for (Node node : nodes) {
              if (character.getPos().x >= node.getPos().x*tileSize && character.getPos().x < (node.getPos().x+1)*tileSize && character.getPos().y >= node.getPos().y*tileSize && character.getPos().y < (node.getPos().y+1)*tileSize) {
                start = node;
              }
            }


            for (Node node : nodes) {
              if (character.getDest().x == node.getPos().x && character.getDest().y == node.getPos().y ) {
                end = node;
              }
            }



            if (start != null && end != null) {
              character.setPath(pathfinder.findPath(start, end, nodes));
            }
          }
        }
      }
    }
  } else if (mouseButton == RIGHT) {
    Node start = null;
    Node end = null;
    for (Node node : nodes) {
      if (character.getPos().x >= node.getPos().x*tileSize && character.getPos().x < (node.getPos().x+1)*tileSize && character.getPos().y >= node.getPos().y*tileSize && character.getPos().y < (node.getPos().y+1)*tileSize) {
        start = node;
      }
    }
    for (Node node : nodes) {
      if (mouseX >= node.getPos().x*tileSize && mouseX < (node.getPos().x+1)*tileSize && mouseY >= node.getPos().y*tileSize && mouseY < (node.getPos().y+1)*tileSize) {
        end = node;
      }
    }
    if (start != null && end != null) {
      character.setPath(pathfinder.findPath(start, end, nodes));
      character.setDest((int)end.getPos().x, (int)end.getPos().y);
    }
  }
}



void keyPressed() {
  if (key == ' ') {
  }
}
