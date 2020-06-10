class Wall {
  float x, x1; 
  float y, y1; 
  float r, r1;
  PShape wall;
  PShape wall2;
  float dSX;
  float dDX;
  float speed = 5;
  Player bat;
  PImage img = loadImage("rock.jpg");
  
  Wall(Player player) {
    this.x = 0;
    this.x1 = width;
    this.y = -100;                                          //Same value of the "y" pos of both side of the wall
    this.r = random(100, 500);                              //DX Radius of the wall
    this.r1 = random(100, 500);                             //SX Radius of the wall
    this.bat = player;
  }

  void draw() {
    noStroke();
    fill(75,69,50);
    wall = createShape(ELLIPSE, x, y, r, r);
    wall2 = createShape(ELLIPSE, x1, y, r1, r1);

    wall.setTexture(img);
    wall2.setTexture(img);

    shape(wall);
    shape(wall2);
  }

  void update(int n) {
    this.y += n;
  }

  void collisione() {

    this.dSX = dist(0, this.y, bat.getx1(), bat.gety1());  // Collisione SX
    if (this.dSX < r) {
      // Tocca muro sx
      println("valore SX :");
      println( dSX);
      background(255, 0, 0);
    }
    this.dDX = dist(width, this.y, bat.getx1(), bat.gety1());  // Collisione DX
    if (this.dDX < (this.r1+bat.getimgw())) { 
      // Tocca muro DX
      println("valore DX :");
      println( dDX);
      background(0, 0, 255);
    }
  }
}
