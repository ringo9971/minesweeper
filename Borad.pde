public class Board {
  int mineNum;
  boolean isGameOver;
  PVector pos, size, cnt, gridSize;
  boolean[][] board, mine, flag;

  Board(float x, float y, float dx, float dy, int cx, int cy, int mineNum){
    pos  = new PVector(x, y);
    size = new PVector(dx, dy);
    cnt  = new PVector(cx, cy);
    gridSize = new PVector(2*dx/cx, 2*dy/cy);
    this.mineNum = mineNum;
    init();
  }

  void init(){
    isGameOver = false;
    board = new boolean[int(cnt.x)][int(cnt.y)];
    mine  = new boolean[int(cnt.x)][int(cnt.y)];
    flag  = new boolean[int(cnt.x)][int(cnt.y)];
    int addMineNum = mineNum;
    while(addMineNum > 0){
      int x = int(random(cnt.x));
      int y = int(random(cnt.y));
      if(mine[x][y]) continue;
      mine[x][y] = true;
      addMineNum--;
    }
  }

  void push(float mouse_x, float mouse_y){
    if(isGameOver) return;
    if(OUT(mouse_x, pos.x-size.x, pos.x+size.x)) return;
    if(OUT(mouse_y, pos.y-size.y, pos.y+size.y)) return;

    int x = int((mouse_x-(pos.x-size.x))/gridSize.x);
    int y = int((mouse_y-(pos.y-size.y))/gridSize.y);
    if(mine[x][y]){
      isGameOver = true;
      return;
    }
    board[x][y] = true;
  }
  void display(){
    fill(255);
    rect(pos.x, pos.y, size.x*2, size.y*2);
    fill(0);
    for(int i = 1; i < cnt.x; i++){
      float x = pos.x-size.x + i*gridSize.x;
      line(x, pos.y-size.y, x, pos.y+size.y);
    }
    for(int j = 1; j < cnt.y; j++){
      float y = pos.y-size.y + j*gridSize.y;
      line(pos.x-size.x, y, pos.x+size.x, y);
    }

    fill(170);
    for(int i = 0; i < cnt.x; i++) for(int j = 0; j < cnt.y; j++){
      if(board[i][j]){
        float x = pos.x-size.x + (1.0+2*i)*gridSize.x/2;
        float y = pos.y-size.y + (1.0+2*j)*gridSize.y/2;
        rect(x, y, gridSize.x, gridSize.y);
      }
    }
  }
}
