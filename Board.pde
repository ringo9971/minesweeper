public class Board {
  int startTime, endTime;
  int mineNum, safetyNum, flagNum;
  boolean isFinish;
  boolean isGameOver;
  PVector pos, size, cnt, gridSize;
  int[][] aroundMineNums;
  boolean[][] boards, mines, flags;
  int[] dx = { 0,  1, 1, 1, 0, -1, -1, -1};
  int[] dy = {-1, -1, 0, 1, 1,  1,  0, -1};

  Board(float x, float y, float dx, float dy, int cx, int cy, int mineNum){
    pos  = new PVector(x, y);
    size = new PVector(dx, dy);
    cnt  = new PVector(cx, cy);
    gridSize = new PVector(2*dx/cx, 2*dy/cy);
    this.mineNum = mineNum;
    init();
  }

  void init(){
    isFinish = false;
    isGameOver = false;
    aroundMineNums = new int[int(cnt.x)][int(cnt.y)];
    boards = new boolean[int(cnt.x)][int(cnt.y)];
    mines  = new boolean[int(cnt.x)][int(cnt.y)];
    flags  = new boolean[int(cnt.x)][int(cnt.y)];
    safetyNum = int(cnt.x)*int(cnt.y)-mineNum;
    flagNum = 0;
    startTime = millis();
    int addMineNum = mineNum;
    while(addMineNum > 0){
      int x = int(random(cnt.x));
      int y = int(random(cnt.y));
      if(mines[x][y]) continue;
      mines[x][y] = true;
      addMineNum--;
    }
  }

  void push(int x, int y){
    if(boards[x][y] || flags[x][y]) return;

    boards[x][y] = true;
    safetyNum--;
    if(safetyNum == 0) isFinish = true;
    if(mines[x][y]){
      isGameOver = true;
      return;
    }
    int aroundMineNum = 0;
    for(int i = 0; i < 8; i++){
      int nx = x+dx[i];
      int ny = y+dy[i];
      if(OUT(0, nx, int(cnt.x)) || OUT(0, ny, int(cnt.y))) continue;
      if(mines[nx][ny]) aroundMineNum++;
    }
    aroundMineNums[x][y] = aroundMineNum;
    
    if(aroundMineNum != 0) return;
    for(int i = 0; i < 8; i++){
      int nx = x+dx[i];
      int ny = y+dy[i];
      if(OUT(0, nx, int(cnt.x)) || OUT(0, ny, int(cnt.y))) continue;
      push(nx, ny);
    }
  }
  void mousePush(float mouse_x, float mouse_y){
    if(IN(width/2-gridSize.x*1.5/2, mouse_x, width/2+gridSize.x*1.5/2) && IN(height/20-gridSize.y*1.5/2, mouse_y, height/20+gridSize.y*1.5/2)){
      init();
      return;
    }
    if(isFinish || isGameOver) return;
    if(OUT(pos.x-size.x, mouse_x, pos.x+size.x)) return;
    if(OUT(pos.y-size.y, mouse_y, pos.y+size.y)) return;

    int x = int((mouse_x-(pos.x-size.x))/gridSize.x);
    int y = int((mouse_y-(pos.y-size.y))/gridSize.y);
    push(x, y);
  }
  void setFlag(float mouse_x, float mouse_y){
    if(isFinish || isGameOver) return;
    if(OUT(pos.x-size.x, mouse_x, pos.x+size.x)) return;
    if(OUT(pos.y-size.y, mouse_y, pos.y+size.y)) return;

    int x = int((mouse_x-(pos.x-size.x))/gridSize.x);
    int y = int((mouse_y-(pos.y-size.y))/gridSize.y);
    if(boards[x][y]) return;
    flagNum = flagNum + (flags[x][y]? -1: 1);
    flags[x][y] = !flags[x][y];
  }
  void expandPush(float mouse_x, float mouse_y){
    if(isFinish || isGameOver) return;
    if(OUT(pos.x-size.x, mouse_x, pos.x+size.x)) return;
    if(OUT(pos.y-size.y, mouse_y, pos.y+size.y)) return;

    int x = int((mouse_x-(pos.x-size.x))/gridSize.x);
    int y = int((mouse_y-(pos.y-size.y))/gridSize.y);
    if(!boards[x][y] || aroundMineNums[x][y] == 0) return;

    int aroundFlagNum = 0;
    for(int i = 0; i < 8; i++){
      int nx = x+dx[i];
      int ny = y+dy[i];
      if(OUT(0, nx, int(cnt.x)) || OUT(0, ny, int(cnt.y))) continue;
      if(flags[nx][ny]) aroundFlagNum++;
    }
    if(aroundFlagNum != aroundMineNums[x][y]) return;
    for(int i = 0; i < 8; i++){
      int nx = x+dx[i];
      int ny = y+dy[i];
      if(OUT(0, nx, int(cnt.x)) || OUT(0, ny, int(cnt.y))) continue;
      push(nx, ny);
    }
  }
  void displeyEmoticon(){
    fill(255);
    float x = width/2;
    float y = height/20;
    float dx = gridSize.x;
    float dy = gridSize.y;
    rect(x, y, 1.5*dx, 1.5*dy);
    fill(255, 255, 0);
    ellipse(x, y, 1.2*dx, 1.2*dy);

    fill(0);
    if(isGameOver){
      strokeWeight(5);
      line(x-dx/4-dx/8, y-dy/7-dy/8, x-dx/4+dx/8, y-dy/7+dy/8);
      line(x-dx/4-dx/8, y-dy/7+dy/8, x-dx/4+dx/8, y-dy/7-dy/8);
      line(x+dx/4-dx/8, y-dy/7-dy/8, x+dx/4+dx/8, y-dy/7+dy/8);
      line(x+dx/4-dx/8, y-dy/7+dy/8, x+dx/4+dx/8, y-dy/7-dy/8);
      fill(255, 255, 0);
      arc(x, y+dy*0.45, 0.6*dx, 0.5*dy, PI+PI/10, 2*PI-PI/10);
    }else if(isFinish){
      rect(x-dx/4, y-dy/8, dx*0.4, dy/4);
      rect(x+dx/4, y-dy/8, dx*0.4, dy/4);
      line(x-dx/4, y-dy/4, x+dx/4, y-dy/4);
      line(x-dx/4-dx*0.2, y-dy/4, x-dx*0.6, y);
      line(x+dx/4+dx*0.2, y-dy/4, x+dx*0.6, y);
      fill(255, 255, 0);
      strokeWeight(5);
      arc(x, y+dy/20, 0.8*dx, 0.7*dy, PI/10, PI-PI/10);
    }else{
      ellipse(x-dx/4, y-dy/8, 0.2*dx, 0.2*dy);
      ellipse(x+dx/4, y-dy/8, 0.2*dx, 0.2*dy);
      fill(255, 255, 0);
      strokeWeight(5);
      arc(x, y+dy/20, 0.8*dx, 0.7*dy, PI/10, PI-PI/10);
    }
    strokeWeight(1);
  }
  void displayMine(float i, float j){
    float x = pos.x-size.x + (1.0+2*i)*gridSize.x/2;
    float y = pos.y-size.y + (1.0+2*j)*gridSize.y/2;
    fill(0);
    ellipse(x, y, 0.7*gridSize.x, 0.7*gridSize.y);
  }
  void displayMissFlag(float i, float j){
    float x = pos.x-size.x + (1.0+2*i)*gridSize.x/2;
    float y = pos.y-size.y + (1.0+2*j)*gridSize.y/2;
    strokeWeight(5);
    stroke(255, 0, 0);
    line(x-gridSize.x/2, y-gridSize.y/2, x+gridSize.x/2, y+gridSize.y/2);
    line(x-gridSize.x/2, y+gridSize.y/2, x+gridSize.x/2, y-gridSize.y/2);
    strokeWeight(1);
    stroke(0);
  }
  void displayALLMines(){
    for(int i = 0; i < cnt.x; i++) for(int j = 0; j < cnt.y; j++){
      if(!mines[i][j] && flags[i][j]) displayMissFlag(i, j);
      if(mines[i][j] && !flags[i][j]) displayMine(i, j);
    }
  }
  void displayGrid(){
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
  }
  void displayMineNum(){
    float x = width*0.9;
    float y = height/20;
    fill(255);
    rect(x, y, width/6, gridSize.y*1.5);
    fill(255, 0, 0);
    text(mineNum-flagNum, x, y);
  }
  void displayTime(){
    float x = width*0.1;
    float y = height/20;
    fill(255);
    rect(x, y, width/6, gridSize.y*1.5);
    fill(255, 0, 0);
    text((endTime-startTime)/1000, x, y);
  }
  void display(){
    displeyEmoticon();
    displayGrid();
    displayMineNum();
    displayTime();

    for(int i = 0; i < cnt.x; i++) for(int j = 0; j < cnt.y; j++){
      float x = pos.x-size.x + (1.0+2*i)*gridSize.x/2;
      float y = pos.y-size.y + (1.0+2*j)*gridSize.y/2;
      if(boards[i][j]){
        if(mines[i][j]) fill(255, 0, 0);
        else fill(170);
        rect(x, y, gridSize.x, gridSize.y);
        if(aroundMineNums[i][j] != 0){
          fill(255);
          text(aroundMineNums[i][j], x, y-gridSize.y/10);
        }
      }
      if(flags[i][j]){
        fill(255, 0, 0);
        rect(x, y, gridSize.x/2, gridSize.y/2);
      }
    }

    if(isGameOver || isFinish) displayALLMines();
    else endTime = millis();
  }
}
