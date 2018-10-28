class MazeGenerator {

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

   private void recursion(int r, int c, int[][] maze) {
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
}
