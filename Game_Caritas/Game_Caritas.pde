/*
Title : Carits
Objective : A fun and easy Indie game of a Bat going out of a cave. 
*/
import java.net.*;
import java.io.*;
import java.util.Arrays;
import processing.sound.*;

DatagramSocket socket;
DatagramPacket packet;

//--------------------------------------------From OpenCV-------------------------------------------------
float nose_x;                                      
float nose_y;
float nose2_x;
float nose2_y;

int fCountVal = 30;                                 //Value of fCout for the walls
Wall muro; 
Player player;
ArrayList<Object> obj = new ArrayList<Object>();
ArrayList<Wall> muri = new ArrayList<Wall>();
static int stage= 0;                                //Putting the stage as start menu
int spCount=3;                                      //Speed counter for updating the speed of flying of the player
int i ;                                             // Counter for the loops
int time;                                           //Time counter
byte[] buf = new byte[24];                          //Set your buffer size as desired(OpneCV)

//----------------------------------------------------Images and sounds-------------------------------------------------------------------
PImage[] loading = new PImage[3];
PImage startScreen;                                 
PImage cave ; 
SoundFile file;
String audioName = "gameMusic.mp3";


void setup() {
  size(700, 1000);
  player = new Player(); 
  muri.add(new Wall(player));                        //Adding the first wall block
  cave = loadImage("backCave1.png");                  //Background Image
  startScreen = loadImage("caritas.png");            //Start Image
  file = new SoundFile(this, audioName);
  file.play();                                       //Playing the sound 
  file.amp(0.2);                                     //Sound vol in range of (0.0 - 1.0)
  time = millis();                                   //Time counting
  
  
//---------------------------------------------------Loading the tutorial screens---------------------------------------------------------

  for(i = 0; i < loading.length; i++){
    loading[i]  = loadImage("loading"+i+".png");
    loading[i].resize(width, height);
  }

// ---------------------------------------------------Vector for animated player---------------------------------------------------------- 
  /* 
   for(int l = 1 ;  l < rocket.size(); l++){  
   rocket[l] = loadImage("frame_"+l+".png");
   } 
   */
//------------------------------------------------------OpenCV Part---------------------------------------------------------------------
  try {
      socket = new DatagramSocket(4124);               // Set your port here(DON'T!!)
    }
    catch (Exception e) {
      e.printStackTrace(); 
      println(e.getMessage());
    }

}
  
void draw() {
  switch(stage) {
  case 0:                                               
    screen();                                           //Start Screen
    break;
  case 1:
    println("loading");
    tutorial();                                         //Tutorial
    break;
  case 2:
  println("Play");
    play();                                             //Main Game
    break;
  }
  
}
//----------------------------------------------------------Start------------------------------------------------------------------------
void screen() {                                          //Funzione per la schermata dello start 
  image(startScreen, 0, 0, width, height);               //Img for the screen on the full canvas
  if (keyPressed == true) {
      stage = 1;                                         //Passing on the loading screen
      file.play();                                       //Playing the sound 
      file.amp(0.7);                                     //Max Volume
  }
}
//---------------------------------------------------------Tutorial----------------------------------------------------------------------
void tutorial(){
  
  image(loading[2], 0, 0, width, height);               //Img for loading3 Screen
  if (keyPressed == true) {
      stage = 2; 
  }
  
  /*
  while(millis() < 15000 ){
  background(loading[0]);
  println(millis());
  }
  stage = 2;  
  
  
  while (time < 15000){
    if(time > 0){
      image(loading[0], 0, 0, width, height);
    }
    if(time > 3000){
      image(loading[1], 0, 0, width, height);
    }
    if(time > 6500){
      image(loading[2], 0, 0, width, height);
    } 
                                                          //Not Working
    for(int i = 0; i < loading.length; i++){
      image(loading[i], 0, 0, width, height);
      println("Tutorial"+i);
      delay(5000);
    }
    
    }
  */
  
}

//---------------------------------------------------------Playwable----------------------------------------------------------------------
void play() { // Funzione del gioco 
  try {
    DatagramPacket packet = new DatagramPacket(buf, buf.length);
    socket.receive(packet);
    InetAddress address = packet.getAddress();
    int port = packet.getPort();
    packet = new DatagramPacket(buf, buf.length, address, port);

    nose_x = Float.intBitsToFloat( (buf[0]& 0xFF) ^ (buf[1]& 0xFF)<<8 ^ (buf[2]& 0xFF)<<16 ^ (buf[3]& 0xFF)<<24 );
    nose_y = Float.intBitsToFloat( (buf[4]& 0xFF) ^ (buf[5]& 0xFF)<<8 ^ (buf[6]& 0xFF)<<16 ^ (buf[7]& 0xFF)<<24 );
    
    nose2_x = Float.intBitsToFloat( (buf[8]& 0xFF) ^ (buf[9]& 0xFF)<<8 ^ (buf[10]& 0xFF)<<16 ^ (buf[11]& 0xFF)<<24 );
    nose2_y = Float.intBitsToFloat( (buf[12]& 0xFF) ^ (buf[13]& 0xFF)<<8 ^ (buf[14]& 0xFF)<<16 ^ (buf[15]& 0xFF)<<24 );
    
    println("DATA:");
    println(nose_x);                                    // blue Object posX
    println(nose_y);                                    // blue Object posY
    println(nose2_x);                                   // red Object posX
    println(nose2_y);                                   // red Object posY
    
    println("DATA END\n");
  }
  catch (IOException e) {
    e.printStackTrace(); 
    println(e.getMessage());
  }
//----------------------------------------------------Game Code------------------------------------------------------------------------

  image(cave, 0, 0, width, height);                      //Background fix

  if (frameCount % fCountVal == 0) {                     //Every time the frame counter is divisible for 10 by giving a rest of 0 
    muri.add(new Wall(player));                          //we create a new wall obj in the vector 
  } 
//----------------------------------------------------------Objects----------------------------------------------------------------------
  if (frameCount % 70 == 0 && spCount > 3) {
    obj.add(new Object());
  }
  
  if(spCount > 3){                                       //Rect obj coming up

    for (int i = obj.size() - 1; i >= 0; i--) {          //It runs all the methods indicated in the "for", for vector size
    Object o = obj.get(i);
    o.draw();
    o.update(spCount);                                   //Passing the speed as parameter 
    //o.collisione();                                    //Not Working

    if (o.y >= height+100) {                             //This simply removes an wall obj when they pass the game height
      obj.remove(i);                                     //So that the vector remains light
    }
  }

 }
 //--------------------------------------------------------WALL------------------------------------------------------------------------
 
  for (int i = muri.size() - 1; i >= 0; i--) {           //It runs all the methods indicated in the "for", for vector size
    Wall m = muri.get(i);
    m.draw();
    m.update(spCount);                                   //Passing the speed as parameter 
    //m.collisione();                                      //Not Working

    if (m.y >= height+100) {                             //This simply removes an wall obj when they pass the game height
      muri.remove(i);                                    //So that the vector remains light
    }
  }

  player.draw();                                         //It draws the game character(BAT)

  /*            //----------------------------------------- controlli temporanei------------------------------------------------
  if (keyPressed == true) {
    player.updateright();
  } else {
    player.updateleft();
  } 
  */

   if(nose_x < 50 && nose_y < 300 && nose_x > 0){                    //Let's you move the character
     player.updateright();                                 //Gose right if the color obj is on your top-right
   } 
   if(nose_x > 300  && nose_y > 250){                    
     player.updateleft();                                  //Gose left when the color obj is on your top-left
   } 
   
                                                         //Speed update
   if (frameCount % 150 == 0) {
    spCount++;
    fCountVal--;
  }
  
  
  
}

void animatedPlayer(){                                    //Not i use for now
  
  /*
   if(i < rocket.length){ 
   player.draw(rocket, i);
   }else{
   i = 1;
   }
  */
}
