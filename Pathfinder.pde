class Pathfinder{

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
}
