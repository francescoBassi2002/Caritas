class Object {
  float x, y, w, h;                                 //Values of the LEFT objects
  float x1, y1, w1, h1;                             //Values of the RIGHT objects

  Object() {
    x = 0;
    x1 = width;
   // y = -random(5, 100);
   // y1 = -random(5, 100);
    y = -5 ;                                       //Giving a y value that can let them spawn earlier 
    y1 = - 200;                                    //Giving a y value that can let them spawn earlier and that it got some dist for the first obj
    w = random(100, 350);                          //Random the size of the objects
    w1 = random(100, 350);
    h = random(20, 25);
    h1 = random(20, 25);

  }
  
  void draw() {
    noStroke();
    fill(86,78,50);
    rect(this.x, this.y, this.w, this.h);
    rect(this.x1, this.y1, -this.w1, this.h1);
  }

  void update(int n) {
    y += n;
    y1 += n;
  }

}
