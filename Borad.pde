public class Board {
  PVector pos, size, cnt;
  boolean[][] board, mine, flag;

  Board(float x, float y, float dx, float dy, int cx, int cy){
    pos  = new PVector(x, y);
    size = new PVector(dx, dy);
    cnt  = new PVector(cx, cy);
    board = new boolean[cx][cy];
    mine  = new boolean[cx][cy];
    flag  = new boolean[cx][cy];
  }

  void display(){
    rect(pos.x, pos.y, size.x*2, size.y*2);
    for(int i = 1; i < cnt.x; i++){
      float x = pos.x-size.x + i*2*size.x/cnt.x;
      line(x, pos.y-size.y, x, pos.y+size.y);
    }
    for(int j = 1; j < cnt.y; j++){
      float y = pos.y-size.y + j*2*size.y/cnt.y;
      line(pos.x-size.x, y, pos.x+size.x, y);
    }
  }
}
