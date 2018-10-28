class Pathfinder{

  //A* pathfinding algorithm

  
  ArrayList<Node> findPath(Node start, Node end, ArrayList<Node> nodes) {
    
    //Create arraylists for the path, the open nodes and the closed nodes
    ArrayList<Node> path = new ArrayList<Node>();
    ArrayList<Node> openList = new ArrayList<Node>();
    ArrayList<Node> closedList = new ArrayList<Node>();
    
    //Add the start position to the open list
    openList.add(start);
    
    
    //Loop till the 
    while (openList.size() > 0) {
      
      //Get the node with the lowest F score from the open list
      Node currentNode = openList.get(0);
      for (Node openNode : openList) {
        if (openNode.getFScore() < currentNode.getFScore()) {
          currentNode = openNode;
        }
      }
      
      //Add the node to the closed list and remove it from the open list
      closedList.add(currentNode);
      openList.remove(currentNode);
      
      
      //Check if the end node is in the closed list, if this is true the path has been found and the loop can be stopped.
      boolean pathFound = false;
      for (Node closedNode : closedList) {
        if (closedNode.getPos().x == end.getPos().x && closedNode.getPos().y == end.getPos().y) {
          pathFound = true;
        }
      }

      if (pathFound) {
        break;
      }
      
      //Create an arraylist of all the neighbour nodes
      ArrayList<Node> adjacentNodes = new ArrayList<Node>();
      for (Node node : nodes) {
        if (PVector.dist(node.getPos(), currentNode.getPos()) <= 1) {
          adjacentNodes.add(node);
        }
      }
      
      //Cycle through all the neighbour nodes
      for (Node adjacentNode : adjacentNodes) {
        
        //Check if the node is in the closed list, if it is, continue to the next node.
        boolean isInClosedList = false;
        for (Node closedNode : closedList) {
          if (adjacentNode.getPos().x == closedNode.getPos().x && adjacentNode.getPos().y == closedNode.getPos().y) {
            isInClosedList = true;
          }
        }
        if (isInClosedList) {
          continue;
        }

        //Check if the node is in the open list
        boolean isInOpenList = false;
        for (Node openNode : openList) {
          if (openNode.getPos().x == adjacentNode.getPos().x && openNode.getPos().y == adjacentNode.getPos().y) {
            isInOpenList = true;
          }
        }

        //Calculate the G and H score of the node
        int gScore = currentNode.getGScore()+adjacentNode.getWeight();
        int hScore = (int) abs(adjacentNode.getPos().x-end.getPos().x)+(int) abs(adjacentNode.getPos().y-end.getPos().y);

        //If the node is not in the open list, calculate its scores and define its parent, then add it to the open list
        if (!isInOpenList) {
          adjacentNode.setGScore(gScore);
          adjacentNode.setHScore(hScore);
          adjacentNode.setParent(currentNode);
          openList.add(adjacentNode);
        } else {
          
          //If it is in the open list, check if its current G score is lower than its defined G score, if it is, change its parent and scores
          if (gScore<adjacentNode.getGScore()) {
            adjacentNode.setParent(currentNode);
            adjacentNode.setGScore(gScore);
            adjacentNode.setHScore(hScore);
          }
        }
      }
    }

    //Add the path nodes the the path arraylist by adding the end node and then repeating the process for every parent untill the start node is reached
    Node currentNode = null;
    for (Node node : closedList) {
      if (node.getPos().x == end.getPos().x && node.getPos().y == end.getPos().y) {
        currentNode = node;
      }
    }

    while (!(currentNode.getPos().x == start.getPos().x && currentNode.getPos().y == start.getPos().y) && currentNode != null) {
      path.add(currentNode);
      currentNode = currentNode.getParent();
    }

    
    return path;
  }
}
