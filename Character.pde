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
    if(path.size() != 0){
      Node nextTile = path.get(path.size()-1);
      if (xPos == nextTile.getPos().x*tileSize && yPos == nextTile.getPos().y*tileSize){
        path.remove(nextTile);
      } else {
        if(speed >= abs(xPos - nextTile.getPos().x*tileSize)){
          xPos = nextTile.getPos().x*tileSize;
        }
        if(speed>= abs(yPos - nextTile.getPos().y*tileSize)){
          yPos = nextTile.getPos().y*tileSize;
        }
        PVector movementVector = new PVector(nextTile.getPos().x*tileSize - xPos, nextTile.getPos().y*tileSize-yPos);
        movementVector.normalize();
        movementVector.mult(speed);
        xPos+=movementVector.x;
        yPos+=movementVector.y;
      }
    }
  }
  
  void display(){
    imageMode(CORNER);
    image(characterImage, xPos, yPos, tileSize, tileSize);
  }
  
  void setSpeed(ArrayList<Node> nodes){
    for (Node node : nodes){
      if(node.pointIsOnNode(xPos+tileSize/2, yPos+tileSize/2)){
        speed = mainSpeed/node.getWeight();
      }
    }
  }
  
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
}
