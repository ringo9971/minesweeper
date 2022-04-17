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

  void push(float mouse_x, float mouse_y){
    if(OUT(mouse_x, pos.x-size.x, pos.x+size.x)) return;
    if(OUT(mouse_y, pos.y-size.y, pos.y+size.y)) return;

    int x = int((mouse_x-(pos.x-size.x))/(size.x*2/cnt.x));
    int y = int((mouse_y-(pos.y-size.y))/(size.y*2/cnt.y));
    board[x][y] = true;
  }
  void display(){
    fill(255);
    rect(pos.x, pos.y, size.x*2, size.y*2);
    fill(0);
    for(int i = 1; i < cnt.x; i++){
      float x = pos.x-size.x + i*2*size.x/cnt.x;
      line(x, pos.y-size.y, x, pos.y+size.y);
    }
    for(int j = 1; j < cnt.y; j++){
      float y = pos.y-size.y + j*2*size.y/cnt.y;
      line(pos.x-size.x, y, pos.x+size.x, y);
    }

    fill(170);
    for(int i = 0; i < cnt.x; i++) for(int j = 0; j < cnt.y; j++){
      if(board[i][j]){
        float x = pos.x-size.x + (1.0+2*i)*(size.x/cnt.x);
        float y = pos.y-size.y + (1.0+2*j)*(size.y/cnt.y);
        rect(x, y, 2*size.x/cnt.x, 2*size.y/cnt.y);
      }
    }
  }
}