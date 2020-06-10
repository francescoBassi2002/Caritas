class Player {

  float x1 ;                                                      //PosX Img
  float y1 ;                                                      //PosY Img
  float imgw = 150;                                               //Img Width
  float imgh = 110;                                               //Img Height
  float rocketw = 90;                                            //Used for animated vector
  float rocketh = 120;                                            //Used for animated vector
  PImage img = loadImage("bat.png");                              //Player PNG Image


  Player() {

    this.x1 = width/2-60;
    this.y1 =  height-150;

  }

  void draw(PImage rocket[], int i) {
    stroke(1);
    image(rocket[i], x1, y1, rocketw, rocketh);
    //fill(255, 0 ,0);
    //triangle(x1, y1, x2, y2, x3, y3);
  }


  void draw() {
    //rect( x1, y1, imgw, imgh);
    image(this.img, this.x1, this.y1, this.imgw, this.imgh);
  }

  void updateright() {
    this.x1 += 3;
  }

  void updateleft() {
    this.x1 -= 3;
  }

  float getx1() {
    return x1;
  }

  float gety1() {
    return y1;
  }

  float getimgw() {
    return imgw;
  }

  float getimgh() {
    return imgh;
  }
}
