class Trail {
  int index;
  boolean cooldown;
  int x;
  int y;
  int timer;
  int h;
  int s;
  int b;
  int opacity;
  int timeMax = 10;

  Trail(int index_) {
    index = index_;
    x = index/rainbow.width;
    y = index % width;
    reset();
  }

  void update() {
    if (cooldown) {
      timer -= 1;
      h = int(map(timer, 0, timeMax, 0, 255));
      //s -= 1;
      //b -= 1;
      opacity = int(map(timer, 0, timeMax, 0, 255));
      if (timer < 0){
       cooldown = false; 
       opacity = 0;
      }
    }
  }

  void drawTrail() {
    rainbow.pixels[index] = color(h,s,b,opacity);
  }
  void reset() {
    h = 255;
    s = 255;
    b = 255; 
    opacity = 255;
    timer = timeMax;
    cooldown = true;
  }
}
