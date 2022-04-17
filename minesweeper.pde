Board board;
void setup(){
  size(900, 1200);
  rectMode(CENTER);
  board = new Board(width/2, height/2+height/20, width/2*0.98, height*(1.0/2-1.0/20)*0.98, 15, 18);
}

void keyPressed(){
  if(key == 'q'){
    exit();
  }
}

void draw(){
  background(200);
  board.display();
}

