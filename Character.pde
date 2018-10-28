class Character{
  float xPos, yPos;
  int xDest, yDest;
  float size;
  float speed = 5;
  ArrayList<Node> path;
  
  Character(float xPos, float yPos, float size){
    this.xPos = xPos;
    this.yPos = yPos;
    this.size = size;
    path = new ArrayList<Node>();
  }
  
  void update() {
    if(path.size() != 0){
      Node nextTile = path.get(path.size()-1);
      if (xPos == nextTile.getPos().x*size && yPos == nextTile.getPos().y*size){
        path.remove(nextTile);
      } else {
        if(speed >= abs(xPos - nextTile.getPos().x*size)){
          xPos = nextTile.getPos().x*size;
        }
        if(speed>= abs(yPos - nextTile.getPos().y*size)){
          yPos = nextTile.getPos().y*size;
        }
        PVector movementVector = new PVector(nextTile.getPos().x*size - xPos, nextTile.getPos().y*size-yPos);
        movementVector.normalize();
        movementVector.mult(speed);
        xPos+=movementVector.x;
        yPos+=movementVector.y;
      }
    }
  }
  
  void display(){
    imageMode(CORNER);
    image(characterImage, xPos, yPos, size, size);
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
