import java.util.Collections;

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

  zeroWall = loadImage("weight_3.png");
  singleWall = loadImage("single_wall.png");
  doubleWall = loadImage("double_wall.png");
  doubleStraightWall = loadImage("double_straight_wall.png");
  tripleWall = loadImage("triple_wall.png");
  quadrupleWall = loadImage("quadruple_wall.png");

  weight1 = loadImage("weight_1.png");
  weight2 = loadImage("weight_2.png");
  weight3 = loadImage("weight_3.png");

  characterImage = loadImage("character.png");

  character = new Character(-tileSize, -tileSize, tileSize);

  gridWidth = width/tileSize;
  if (gridWidth % 2 == 0) {
    gridWidth-=1;
  }
  gridHeight = height/tileSize;
  if (gridHeight % 2 == 0) {
    gridHeight-=1;
  }

  tiles = createMaze(gridWidth, gridHeight);


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
          if (tiles[x][y] == 0) {
            character.setPos(x*tileSize, y*tileSize);
            character.setPath(new ArrayList<Node>());
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
      character.setPath(findPath(start, end, nodes));
    }
  }
}

void keyPressed() {
  if (key == ' ') {
  }
}


//A* pathfinding algorithm

ArrayList<Node> findPath(Node start, Node end, ArrayList<Node> nodes) {
  ArrayList<Node> path = new ArrayList<Node>();
  ArrayList<Node> openList = new ArrayList<Node>();
  ArrayList<Node> closedList = new ArrayList<Node>();

  openList.add(start);

  do {

    Node currentNode = openList.get(0);
    for (Node openNode : openList) {
      if (openNode.getFScore() < currentNode.getFScore()) {
        currentNode = openNode;
      }
    }

    closedList.add(currentNode);
    openList.remove(currentNode);

    boolean pathFound = false;
    for (Node closedNode : closedList) {
      if (closedNode.getPos().x == end.getPos().x && closedNode.getPos().y == end.getPos().y) {
        pathFound = true;
      }
    }

    if (pathFound) {
      break;
    }

    ArrayList<Node> adjacentNodes = new ArrayList<Node>();
    for (Node node : nodes) {
      if (PVector.dist(node.getPos(), currentNode.getPos()) <= 1) {
        adjacentNodes.add(node);
      }
    }

    for (Node adjacentNode : adjacentNodes) {
      boolean isInClosedList = false;
      for (Node closedNode : closedList) {
        if (adjacentNode.getPos().x == closedNode.getPos().x && adjacentNode.getPos().y == closedNode.getPos().y) {
          isInClosedList = true;
        }
      }
      if (isInClosedList) {
        continue;
      }

      boolean isInOpenList = false;
      for (Node openNode : openList) {
        if (openNode.getPos().x == adjacentNode.getPos().x && openNode.getPos().y == adjacentNode.getPos().y) {
          isInOpenList = true;
        }
      }


      int gScore = currentNode.getGScore()+adjacentNode.getWeight();

      if (!isInOpenList) {
        int hScore = (int) abs(adjacentNode.getPos().x-end.getPos().x)+(int) abs(adjacentNode.getPos().y-end.getPos().y);
        adjacentNode.setGScore(gScore);
        adjacentNode.setHScore(hScore);
        adjacentNode.setParent(currentNode);
        openList.add(adjacentNode);
        println("Added node "+closedList.size());
      } else {
        if (gScore<adjacentNode.getGScore()) {
          adjacentNode.setParent(currentNode);
        }
      }
    }
  } while (openList.size()>0);


  Node currentNode = null;
  for (Node node : closedList) {
    if (node.getPos().x == end.getPos().x && node.getPos().y == end.getPos().y) {
      currentNode = node;
    }
  }

  while (!(currentNode.getPos().x == start.getPos().x && currentNode.getPos().y == start.getPos().y) && currentNode != null) {
    path.add(currentNode);
    Node newNode = null;
    for (Node node : closedList) {
      if (currentNode.getParent().getPos().x == node.getPos().x && currentNode.getParent().getPos().y == node.getPos().y) {
        newNode = node;
      }
    }
    currentNode = newNode;
  }


  println();
  println();
  println("Path:");
  println();
  for (Node node : path) {
    println("x:"+node.getPos().x+" y:"+node.getPos().y+" parent: x:"+node.getParent().getPos().x+" y:"+node.getParent().getPos().y);
  }

  return path;
}











/*Depth First Search Algorithm to create maze
 http://www.migapro.com/depth-first-search/
 A-Maze-ing
 */



int[][] createMaze(int mazeWidth, int mazeHeight) {
  int[][] maze = new int[mazeWidth][mazeHeight];

  for (int x = 0; x<maze.length; x++) {
    for (int y = 0; y<maze[x].length; y++) {
      maze[x][y] = 1;
    }
  }

  int r = 0, c = 0;
  while (r%2==0) {
    r=round(random(0, mazeWidth-1));
  }
  while (c%2==0) {
    c=round(random(0, mazeHeight-1));
  }

  maze[r][c] = 0;

  recursion(r, c, maze);

  return maze;
}

void recursion(int r, int c, int[][] maze) {
  if (r > maze.length || c > maze[0].length) {
    return;
  }

  Integer[] randDirs = generateRandomDirections();

  for (int i = 0; i<randDirs.length; i++) {
    switch(randDirs[i]) {
    case 1://up
      if (r-2<= 0 || !(r-2<maze.length && c<maze[0].length)) {
        continue;
      }
      if (maze[r-2][c] !=0) {
        maze[r-2][c] = 0;
        maze[r-1][c] = 0;
        recursion(r-2, c, maze);
      }
      break;
    case 2://right
      if (c+2<= 0 || !(r<maze.length && c+2<maze[0].length)) {
        continue;
      }
      if (maze[r][c+2] !=0) {
        maze[r][c+2] = 0;
        maze[r][c+1] = 0;
        recursion(r, c+2, maze);
      }
      break;
    case 3://down
      if (r+2<= 0 || !(r+2<maze.length && c<maze[0].length)) {
        continue;
      }
      if (maze[r+2][c] !=0) {
        maze[r+2][c] = 0;
        maze[r+1][c] = 0;
        recursion(r+2, c, maze);
      }
      break;
    case 4://left
      if (c-2<= 0 || !(r<maze.length && c-2<maze[0].length)) {
        continue;
      }
      if (maze[r][c-2] !=0) {
        maze[r][c-2] = 0;
        maze[r][c-1] = 0;
        recursion(r, c-2, maze);
      }
      break;
    }
  }
}

Integer[] generateRandomDirections() {
  ArrayList<Integer> dirs = new ArrayList<Integer>();
  for (int i = 0; i<4; i++) {
    dirs.add(i+1);
  }
  Collections.shuffle(dirs);

  return dirs.toArray(new Integer[4]);
}
