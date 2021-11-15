import processing.sound.*;
import processing.video.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String portName;
int slidePos;
int pin1Out;
int pin2Out;
int pin3Out;
int pin4Out;
//int powerOut;

//create movie object named space 1
Movie space1;

//sound file object
SoundFile bgm;
SoundFile soundEffect1;
SoundFile soundEffect2;

//gif image obj
PImage cat;
PImage meteor;
float catX = 0;
float catY = height/2;
PShape bot;

// Text
PFont f;
float x;
int index = 0;
int number;

// Declare the rings array
Ring[] rings;
int numRings = 20;
int currentRing = 0;


void setup() {
  //application canvas size
  fullScreen();

  //serial connection setup
  //portName is denoting port [1]
  String portName = Serial.list()[2];
  // get myPort to listen to port 1
  myPort = new Serial(this, portName, 9600);
  //read incoming bytes into a buffer until you get a line break
  myPort.bufferUntil('\n');


  //load video
  space1 = new Movie(this, "Worm Hole - 6797.mov");
  space1.loop();

  //load sound
  bgm = new SoundFile(this, "cosmic-universe.aif");
  soundEffect1 = new SoundFile(this, "winsquarewav-6993.wav");
  soundEffect2 = new SoundFile(this, "classic-computing-sound-6165.wav");

  // These methods return useful info about the sound file
  //println("SFSampleRate= " + bgm.sampleRate() + " Hz");
  //println("SFSamples= " + bgm.frames() + " samples");
  //println("SFDuration= " + bgm.duration() + " seconds");
  bgm.loop();

  rings = new Ring[numRings]; // Create the array
  for (int i = 0; i < rings.length; i++) {
    rings[i] = new Ring(); // Create each object
  }

  //load gif
  cat = loadImage("cat-nyan-cat.gif");
  meteor = loadImage("Meteor.gif");
  bot = loadShape("ufo.svg");

  //load text
  f = createFont( "SpaceAge", 200);
  x = width;
}

//read current video frame
void movieEvent(Movie space1) {
  space1. read();
}



////////////////////////
//serialEvent stays on port and listens for new data to come in
//strips string to essential
//convert string to int and save it to var to use in application

void serialEvent(Serial myPort) {
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    //trim is to remove white space by string
    myString = trim(myString);
    String tempData[] = split(myString, ',');


    slidePos = int(tempData[0]);
    pin1Out = int(tempData[1]);
    pin2Out = int(tempData[2]);
    pin3Out = int(tempData[3]);
    pin4Out = int(tempData[4]);
    //powerOut = int(tempData[5]);
  }
}


void draw() {
  //bgm
  bgm.rate(map(slidePos, 0, 1023, 3, 0.5));

  //video
  image (space1, 0, 0);
  space1.speed(map(slidePos, 0, 1023, 4, 0.5));


  //pin 1 sound effect 1
  if (pin1Out == 1 && !soundEffect2.isPlaying()) {
    tint(255, 60);
    image (cat, catX, catY);
    catX += 20;
    catY = catY + random (-50, 50);
    if (catX>=width) {
      catX = 0;
    }
    if (catY >= height || catY <=0) {
      catY = height/2;
    }

    if (!soundEffect1.isPlaying()&& !soundEffect2.isPlaying()) {
      soundEffect1.play();
    }
  }
  //pin 2 rings array
  if (pin2Out ==  1 ) {
    rings[currentRing].start(random(width), random(height));
    currentRing++;
    if (currentRing >= numRings) {
      currentRing = 0;
    }
    //pin 2 sound effect 2
    if (!soundEffect2.isPlaying()&& !soundEffect1.isPlaying()) {
      soundEffect2.play();
    }
  }
  print(pin1Out);
  println(pin2Out);
  print(pin3Out);
  print(pin4Out);

  //call ring function
  for (int i = 0; i < rings.length; i++) {
    rings[i].grow();
    rings[i].display();
  }

  //pin3 force sensor
  if (pin3Out>800) {
    String[] words = { "Earth", "Mercury", "Venus", "Mars", "Moon" };
    int n = int(random(5));

    //int index = int(random(words.length));


    textAlign(CENTER);
    textFont(f);
    textSize(120);
    fill(251, 239, 255);
    text((int)random(1, 9), 360, height/2-100);
    text((int)random(1, 9), 480, height/2-100);
    text((int)random(1, 9), 600, height/2-100);
    text((int)random(1, 9), 720, height/2-100);
    text((int)random(1, 9), 840, height/2-100);
    text((int)random(1, 9), 960, height/2-100);

    //text(millis()/1000, 360, height/2-100);

    text(words[n], width/3+300, height/2+300);
    fill(61, 2, 189);
    text("km", 1200, height/2-100);
    text("from", width/2, height/2+100);
  }

  //pin4 ultradistance sensor
  if (pin4Out>5 && pin4Out<40) {
    tint(255, 60);
    //shape(bot, 960, 960, 120, 120);
    translate(width/3, height/3);
    float zoom = map(0.05*pin4Out, 0, width, 0.1, 700);
    scale(zoom);
    shape(bot, -140, -140);
  } else if (pin4Out>=50 && pin4Out<= 100 ) {
    f = createFont("SpaceAge", 200);
    String []headlines = {"WARNING WARNING WARNING WARNING ALIEN IS APPROACHING ALIEN IS APPROACHING WARNING WARNING WARNING WARNING ALIEN IS APPROACHING ALIEN IS APPROACHING WARNING WARNING WARNING WARNING ALIEN IS APPROACHING ALIEN IS APPROACHING",
    };
    fill(random(0, 255), random(0, 255), random(0, 255));
    textFont(f, 200);
    textAlign (CENTER, BOTTOM);

    // A specific String from the array is displayed according to the value of the "index" variable.
    text(headlines[index], x, height-800);
    text(headlines[index], x/2, height-600);
    text(headlines[index], x, height-400);
    text(headlines[index], x/2, height-200);


    // Decrement x
    x = x - 20;

    // If x is less than the negative width, then it is off the screen
    // textWidth() is used to calculate the width of the current String.
    float w = textWidth(headlines[index]);
    if (x < -w) {
      x = width;
      // index is incremented when the current String has left the screen in order to display a new String.
      index = (index + 1) % headlines.length;
    }
  }
}
