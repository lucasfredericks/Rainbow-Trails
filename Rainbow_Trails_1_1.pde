/**
 * Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */



import processing.video.*;

int numPixels;
int[] previousFrame;
int threshold = 80;
int videoWidth = 1920;
int videoHeight = 1080;
Trail[] trails;
Capture video;
PGraphics rainbow;

void setup() {
  fullScreen();

  //default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, videoWidth, videoHeight);

  // Start capturing the images from the camera
  video.start(); 

  numPixels = videoWidth * videoHeight;
  trails = new Trail[numPixels];
  // Create an array to store the previously captured frame
  previousFrame = new int[numPixels];
  rainbow = createGraphics(videoWidth, videoHeight);
  rainbow.beginDraw();
  rainbow.background(0, 0, 0, 0);
  rainbow.loadPixels();
  for (int i = 0; i < numPixels; i++) {
    trails[i] = new Trail(i);
  }
  rainbow.endDraw();
}

void draw() {
  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new f rame from the camera
    video.loadPixels(); // Make its pixels[] array available

    colorMode(HSB);
    rainbow.beginDraw();
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i];
      color prevColor = previousFrame[i];

      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      trails[i].update();
      trails[i].drawTrail();
      if ((diffR + diffG + diffB) > threshold) {
        trails[i].reset();
      }

      previousFrame[i] = currColor;
    }
    rainbow.updatePixels();
    rainbow.endDraw();
    pushMatrix();
    //scale(-1,1);
    image(video, 0, 0, width, height);
    image(rainbow, 0, 0, width, height);
    popMatrix();
  }
  println(frameRate);
}
