class Player{
  float xPos, yPos, xDest, yDest;
  float size;
  float speed = 5;
  ArrayList<Node> path;
  
  Player(float xPos, float yPos, float size){
    this.xPos = xPos;
    this.yPos = yPos;
    this.size = size;
    path = new ArrayList<Node>();
  }
  
  void update() {
    if(path.size() != 0){
      Node dest = path.get(path.size()-1);
      if (xPos == dest.getPos().x*size && yPos == dest.getPos().y*size){
        path.remove(dest);
      } else {
        if(speed >= abs(xPos - dest.getPos().x*size)){
          xPos = dest.getPos().x*size;
        }
        if(speed>= abs(yPos - dest.getPos().y*size)){
          yPos = dest.getPos().y*size;
        }
        PVector movementVector = new PVector(dest.getPos().x*size - xPos, dest.getPos().y*size-yPos);
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
  
  void setDest(float xDest, float yDest){
    this.xDest = xDest;
    this.yDest = yDest;
  }
  
  void setPath(ArrayList<Node> path){
    this.path = path;
  }
  
  PVector getPos() {
    return new PVector(xPos, yPos);
  }
}
