/*This is an audioreactive project in which a particle system of ellipses is created. 
The sound is received from Max MSP.
The colour and size of the ellipses are determined by the pitch of the given sound.
The movement of the particles is determined both by the crossing
of a given amplitude threshold and potentiometer values received
from Arduino. 
*/
//Import Serial communication library
import processing.serial.*;
//Define object myPort of class Serial 
Serial myPort;

//Global variables
float potValue = 0;
int particleAm = 500;

//Import Open Sound Control library
import oscP5.*;
//Define object oscp5 of class OscP5 
OscP5 oscP5;

Particle[] particles = new Particle[particleAm];

void setup(){ 
  //Start serial communication which listens for messages from Arduino at port 'COM3'
  String whichPort = "COM3";
  myPort = new Serial(this, whichPort, 9600); 
  myPort.bufferUntil('\n');
 
  //Set display window size and background colour (white)
  size(1500, 750);
  background(255);
  noStroke();
  
  //Set framerate
  frameRate(30);

  //Create particle system at the centre of the display window
  for(int i=0;i<particleAm;i++){
    particles[i] = new Particle(width/2, height/2, random(-20,20), random(-30,0), 10, color(0,0,0), color(255,255,255));
  }
  
  //Start oscP5 which listens for incoming messages coming from Max at port 7400
  oscP5 = new OscP5(this,7400);
}

void draw(){
  //Draw particles
  for(int i=0;i<particleAm;i++){
    particles[i].move();
    particles[i].draw();
  }
}

void oscEvent(OscMessage theOscMessage) {
  
  //Define variables whose values are determined by the that which is output from Max objects defined below
  float value = theOscMessage.get(0).floatValue();
 
  //Perform 'hit' method if '/trigger' outputs values in Max
  if(theOscMessage.checkAddrPattern("/trigger")){
    for(int i=0;i<particleAm;i++){
      //Displace particles to a degree determined by values received from Max
      particles[i].hit(random(-value*value*250,value*value*250),random(-value*value*250,value*value*250));
    }
    //Perform 'pit' method when messages are received from '/pitch' in Max
  }else if(theOscMessage.checkAddrPattern("/pitch")){
    for(int i=0;i<particleAm;i++){
      particles[i].pit(value);
    }
    println(value);
  }
}
void serialEvent (Serial myPort){
  //Get ASCII string from Arduino
  String inString = myPort.readStringUntil('\n');
  if(inString !=null){
  //Trim off whitespace
  inString = trim(inString);
  //potValue variable now determined by Serial reading from Arduino
  potValue = float(inString);
 // println(potValue);
 }
}
  
