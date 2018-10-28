class MazeGenerator {

  /*Depth First Search Algorithm to create maze
   http://www.migapro.com/depth-first-search/
   A-Maze-ing
   */



  int[][] createMaze(int mazeWidth, int mazeHeight) {
    int[][] maze = new int[mazeWidth][mazeHeight];

    for (int x = 0; x<mazeWidth; x++) {
      for (int y = 0; y<mazeHeight; y++) {
        maze[x][y] = 1;
      }
    }
    
    //Create a random starting position that is on an even row and an even column
    int tileX = 0, tileY = 0;
    while (tileX%2==0) {
      tileX=round(random(0, mazeWidth-1));
    }
    while (tileY%2==0) {
      tileY=round(random(0, mazeHeight-1));
    }
    
    //Set the starting position to be a floor tile
    maze[tileX][tileY] = 0;
    
    createPath(tileX, tileY, maze);

    return maze;
  }

   private void createPath(int tileX, int tileY, int[][] maze) {
    //Get an array of the 4 different directions in a randomized order
    Integer[] randDirs = generateRandomDirections();
    
    //Cycle through the different directions
    for (int i = 0; i<randDirs.length; i++) {
      switch(randDirs[i]) {
      case 1://up
        //Check if this direction will cross the edge of the maze, if it does, continue to the next direction
        if (checkTile(tileX-2,tileY,maze)) {
          continue;
        }
        nextTile(tileX,tileY,-2,0,maze);
        break;
      case 2://right
        if (checkTile(tileX,tileY+2,maze)) {
          continue;
        }
        nextTile(tileX,tileY,0,2,maze);
        break;
      case 3://down
        if (checkTile(tileX+2,tileY,maze)) {
          continue;
        }
        nextTile(tileX,tileY,2,0,maze);
        break;
      case 4://left
        if (checkTile(tileX,tileY-2, maze)) {
          continue;
        }
        nextTile(tileX,tileY,0,-2,maze);
        break;
      }
    }
  }
  
  private boolean checkTile(int xTile, int yTile, int[][] maze) {
    return (xTile <= 0 || xTile >= maze.length || yTile <= 0 || yTile >= maze[0].length);
  }
  
  //Check if there is not already a path in this direction, if there is not, create a path in this direction and start creating a path from that tile.
  private void nextTile(int xTile, int yTile, int xMove, int yMove, int[][] maze){
    if(maze[xTile+xMove][yTile+yMove] != 0){
      maze[xTile+xMove][yTile+yMove] = 0;
      maze[xTile+xMove/2][yTile+yMove/2] = 0;
      createPath(xTile+xMove, yTile+yMove, maze);
    }
  }

  private Integer[] generateRandomDirections() {
    ArrayList<Integer> dirs = new ArrayList<Integer>();
    for (int i = 0; i<4; i++) {
      dirs.add(i+1);
    }
    Collections.shuffle(dirs);

    return dirs.toArray(new Integer[4]);
  }
}
