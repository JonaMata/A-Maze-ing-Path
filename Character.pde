class Character{
  float xPos, yPos;
  int xDest, yDest;
  float mainSpeed = 5;
  float speed;
  ArrayList<Node> path;
  
  Character(float xPos, float yPos){
    this.xPos = xPos;
    this.yPos = yPos;
    path = new ArrayList<Node>();
    speed = mainSpeed;
  }
  
  void update() {
    
    //Check if the path contains tiles
    if(path.size() != 0){
      
      //Get the current destination tile
      Node nextTile = path.get(path.size()-1);
      
      //If the character is on this tile, remove the tile from the path list, else move towards this tile
      if (xPos == nextTile.getPos().x*tileSize && yPos == nextTile.getPos().y*tileSize){
        path.remove(nextTile);
      } else {
        //Check if the character would move past the tile at the current speed, if so, set it's x or y position to that of the tile
        if(speed >= abs(xPos - nextTile.getPos().x*tileSize)){
          xPos = nextTile.getPos().x*tileSize;
        }
        if(speed>= abs(yPos - nextTile.getPos().y*tileSize)){
          yPos = nextTile.getPos().y*tileSize;
        }
        
        //Create a movement vector and make sure its magnitude is equal to the current speed
        PVector movementVector = new PVector(nextTile.getPos().x*tileSize - xPos, nextTile.getPos().y*tileSize-yPos);
        movementVector.normalize();
        movementVector.mult(speed);
        
        //Move the character according to the movement vector
        xPos+=movementVector.x;
        yPos+=movementVector.y;
      }
    }
  }
  
  void display(){
    imageMode(CORNER);
    image(characterImage, xPos, yPos, tileSize, tileSize);
  }
  
  //Set the current speed to a fraction of the main speed according to the weight of the node the character is currently on
  void setSpeed(ArrayList<Node> nodes){
    for (Node node : nodes){
      if(node.pointIsOnNode(xPos+tileSize/2, yPos+tileSize/2)){
        speed = mainSpeed/node.getWeight();
      }
    }
  }
  
  //Get and set different variables of the character
  
  void setPos(float xPos, float yPos){
    this.xPos = xPos;
    this.yPos = yPos;
  }
  
  void setDest(int xDest, int yDest){
    this.xDest = xDest;
    this.yDest = yDest;
  }
  
  void setPath(ArrayList<Node> path){
    this.path = path;
  }
  
  PVector getPos() {
    return new PVector(xPos, yPos);
  }
  
  PVector getDest() {
    return new PVector(xDest, yDest);
  }
  
  //Get the node the character is currently on
  Node getNode(ArrayList<Node> nodes) {
    Node resultNode = null;
    for(Node node : nodes){
      if (node.pointIsOnNode(xPos, yPos)){
        resultNode = node;
      }
    }
    return resultNode;
  }
  
  //Get the node corresponding to the destination of the character
  Node getDestNode(ArrayList<Node> nodes){
    Node resultNode = null;
    for(Node node : nodes){
      if(node.pointIsOnNode(xDest*tileSize, yDest*tileSize)){
        resultNode = node;
      }
    }
    return resultNode;
  }
}
