/** //<>//
 * Frame Differencing 
 * by Golan Levin. 
 *
 * Quantify the amount of movement in the video frame using frame-differencing.
 */



import processing.video.*;

int numPixels;
int[] previousFrame;
int threshold = 80;
int videoWidth = 1280;
int videoHeight = 720;
Trail[] trails;
Capture video;
PGraphics rawVideo; //video buffer
PGraphics rainbow;
FrameComparison frameComparison;

void setup() {
  size(1280, 720);


  rawVideo = createGraphics(videoWidth, videoHeight);
  rainbow = createGraphics(videoWidth, videoHeight);
  rainbow.beginDraw();
  rainbow.background(0, 0, 0, 0);
  rainbow.endDraw();

  //default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, videoWidth, videoHeight);

  // Start capturing the images from the camera
  video.start(); 
  //Draw the first frame onto the raw video buffer
  rawVideo.beginDraw();
  rawVideo.image(video, 0, 0, videoWidth, videoHeight);
  rawVideo.endDraw();
  numPixels = videoWidth * videoHeight;

  //initialize an array of objects to track per pixel effects
  trails = new Trail[numPixels];
  for (int i = 0; i < numPixels; i++) {
    trails[i] = new Trail(i);
  }


  frameComparison = new FrameComparison(rawVideo, "name");
  frameComparison.start();
}

void draw() {
  if (video.available()) {
    // When using video to manipulate the screen, use video.available() and
    // video.read() inside the draw() method so that it's safe to draw to the screen
    video.read(); // Read the new frame from the camera
  }
  //image(video, 0, 0, videoWidth, videoHeight);

  //check for new frameComparison intList
  if (frameComparison.newFrame == true) {
    int[] resetList = frameComparison.changedPixels.array(); //copy the intList into a new array
    frameComparison.unpause();
    for (int i = 0; i < resetList.length; i++) {
      int j = resetList[i]; 
      trails[j].reset(); //trigger an effect in all of the affected pixels
    }
  }
  rawVideo.beginDraw();
  rawVideo.image(video, 0, 0, videoWidth, videoHeight); //load the latest frame into the video buffer
  rawVideo.endDraw();
  
  rainbow.loadPixels();
  colorMode(HSB);
  for (int i = 0; i < numPixels; i++) { //loop through all of the effects pixels, update, and render
    trails[i].update();
    trails[i].drawTrail();
  }
  rainbow.updatePixels();
  //rainbow.endDraw();
  pushMatrix();
  //scale(-1,1);
  //image(rawVideo, 0, 0, videoWidth, videoHeight);
  image(rainbow, 0, 0, width, height);
  image(frameComparison.thisFrame, 0, 0, videoWidth, videoHeight);
  popMatrix();
  println(frameRate);
}
