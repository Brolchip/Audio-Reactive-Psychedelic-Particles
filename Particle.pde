//Define variables 'GRAVITY and FRICTION which determine particle movement
float GRAVITY = 0.5;
float FRICTION = 0.9;


//Declare Particle class
public class Particle {
  //xy co-ordinates of particles
  float x,y;
  //Particle displacement on x and y axes
  float dpx,dpy;
  //Particle/ellipse radius
  float radius;
  //Colour and size of particles
  color outer_color;
  color inner_color;
  float particleSize;
  
  //Declare Particle class constructor
  Particle(
    float _x,float _y,
    float _dpx,float _dpy,
    float _radius,
    color _outer_color,
    color _inner_color) {
    x  = _x;
    y  = _y;
    dpx = _dpx;
    dpy = _dpy;
    radius = _radius;
    outer_color = _outer_color;
    inner_color = _inner_color;
  }

    //Move Method
    public void move() {
      //Map 'potValue' values to suit 'FRICTION' values
      // - Level of friction now determined by potentiometer
      FRICTION = map(potValue, 0, 1023, 1., 0.8);
      //Apply friction to particle displacement
      dpx *= FRICTION;
      dpy *= FRICTION;

      //Draw particles towards the centre of the display 
      //based on how far displaced to the right or left they are
      if (x>width/2){
        dpx -= GRAVITY;
      }else{
        dpx += GRAVITY;
      }
      //Draw particles towards the centre of the display 
      //based on how far displaced to the top or bottom they are
      if (y>height/2){
        dpy -= GRAVITY;
      }else{
        dpy += GRAVITY;
      }
      //Update particle position
        x    += dpx;
        y    += dpy;
        //Call bounce function
        this.bounce();
      }
      
    // Draw Method
    public void draw() {
    //Draw outer circle
    fill(outer_color);
    ellipse(x,y,radius*1.5*particleSize,radius*1.5*particleSize);
    //Draw inner circle
    fill(inner_color);
    ellipse(x,y,radius*particleSize,radius*particleSize);
  }
  //Hit Method
   public void hit(float sx,float sy){
      dpx = sx;
      dpy = sy;
  }
  //Pit Method
  public void pit(float value){
    //Define variables to assign colour to particles, determined by pitch of sound input from Max
    float hue = map(value, 0, 1, 0, 360);
    float sat = map(value, 0, 1, 30, 100);
    float bright = map(value, 0, 1, 50, 100);
    //Define variable to assign opacity to particles, determined by sensor (potentiometer) value received from Arduino
    float opa = map(potValue, 0, 1023, 70, 30);
    colorMode(HSB, 360, 100, 100, 100);
      inner_color = color(hue,sat,bright, opa);
      outer_color = color(hue*.75, sat, bright*.75, opa);
      //Size of particles determined by frequency
      particleSize = value*2+0.3;
    }
    
  //Bounce Function
  private void bounce() {
      //Minimum bounce distance is radius of particle/ellipse
      float bounceMinX = radius;
      //Maximum bounce distance is the display window - radius of particle/ellipse
      float bounceMaxX = width - radius;
      float bounceMaxY = height - radius;
      
      if(x < bounceMinX || x > bounceMaxX){
        dpx= -dpx * FRICTION;
        if(x < bounceMinX) x=bounceMinX - (x-bounceMinX);
        if(x > bounceMaxX) x=bounceMaxX - (x-bounceMaxX);
      }
      
      if(y < bounceMinX || y > bounceMaxY) {
        dpy= -dpy * FRICTION*0.7;
        if(y < bounceMinX) y=bounceMinX - (y-bounceMinX);
        if(y >bounceMaxY) y=bounceMaxY - (y-bounceMaxY);
      }
  }
}
