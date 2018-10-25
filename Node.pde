class Node{
  int xPos, yPos, weight, gScore, hScore;
  Node parent = null;
  
  PImage nodeImage;
  
  Node(int xPos, int yPos) {
    this.xPos = xPos;
    this.yPos = yPos;
    weight = round(random(0.5,2.5));
    if(weight == 2){
      weight = 5;
    }
    switch(weight) {
      case 1:
        nodeImage = weight1;
        break;
      case 5:
        nodeImage = weight2;
        break;
      case 3:
        nodeImage = weight3;
        break;
    }
  }
  
  void display() {
    imageMode(CORNER);
    image(nodeImage, xPos*tileSize, yPos*tileSize, tileSize, tileSize);
  }
  
  
  void setGScore(int score){
    this.gScore = score;
  }
  
  void setHScore(int score) {
    this.hScore = score;
  }
  
  void setParent(Node node){
    parent = node;
  }
  
  int getWeight() {
    return weight;
  }
  
  int getGScore() {
    return gScore;
  }
  
  int getHScore() {
    return hScore;
  }
  
  int getFScore() {
    return gScore+hScore;
  }
  
  PVector getPos() {
    return new PVector(xPos, yPos);
  }
  
  Node getParent() {
    return parent;
  }
}
