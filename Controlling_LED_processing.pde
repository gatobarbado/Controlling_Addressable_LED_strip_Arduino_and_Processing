import processing.video.*;
import processing.serial.*;


// Size of each cell in the grid
int cellSize = 1;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Serial serial;
byte[]buffer; 
float[]numbers;

Capture video;


void setup() {
  size(160, 120);
  frameRate(10);
  
  String portName = Serial.list()[0];
  serial  = new Serial(this, portName, 57600);
  //serial.bufferUntil('D');
  buffer = new byte[1000];
  
  String[] cameras = Capture.list(); //array storing different camera settings for different cameras available on the device
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    
    video = new Capture(this, cameras[12]); //this is where you set the index number corresponding to the camera of your choosing
    video.start();     
  } 
  
  cols = width / cellSize;
 rows = height / cellSize;

  colorMode(RGB, 255, 255, 255, 100);

  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  //video = new Capture(this, width, height);
  
  // Start capturing the images from the camera
  video.start();  
  
  background(0);
}
void draw() { 
  if (serial != null) {
    loadPixels();
  if (video.available()) {
    video.read();
    video.loadPixels();
  int k = 0;
  int q = 160;
    // Begin loop for columns
    for (int j = 0; j < 160; j++) {
      // Begin loop for rows
      for (int i = 0; i < 1; i++) {
      
        // Where are we, pixel-wise?
        int x = j*cellSize;
        int y = i*cellSize;
        float r = red(video.pixels[q]);
        float g = green(video.pixels[q]);
        float b = blue(video.pixels[q]);
        // Make a new color with an alpha component
        color c = color(r, g, b, 75);
        buffer[k] = (byte)(r);
        k++;
        buffer[k] = (byte)(g); 
        k++;
        buffer[k] = (byte)(b); 
        k++;
        q--;
        // Code for drawing a single rect
        // Using translate in order for rotation to work properly
        pushMatrix();
        translate(x+cellSize/2, y+cellSize/2);
        // Rotation formula based on brightness
        //rotate((2 * PI * brightness(c) / 255.0));
        rectMode(CENTER);
        fill(c);
        noStroke();
        // Rects are larger than the cell for some overlap
        rect(0, 0, cellSize+6, cellSize+6);
        popMatrix();
      }
    }
  }
  serial.write('*');
   for (int i=0; i<480; i++) { 
      serial.write(buffer[i]);
   }
  }
}
