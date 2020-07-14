class FrameComparison extends Thread{
  
  PGraphics thisFrame;
  int[] lastFrame;
  boolean newFrame;
  //int videoWidth = 1280;
  //int videoHeight = 720;
  //int numPixels;
  IntList changedPixels;


  FrameComparison(PGraphics thisFrame_) {
    thisFrame = createGraphics(videoWidth, videoHeight);
    thisFrame = thisFrame_;
    thisFrame.loadPixels();
    numPixels = videoWidth*videoHeight;
    lastFrame = new int[numPixels]; // create an array to store color integers for comparison
    for (int i = 0; i < numPixels; i++){
      lastFrame[i] = thisFrame.pixels[i]; //init array with 
    }
    newFrame = false;
    changedPixels = new IntList();
  }  
  
  void getFrame(PGraphics thisFrame_){ //saves latest frame to class variable and calls an asynchronous comparison function
    thisFrame = thisFrame_;
  }
  public void compare() {
    super.run();
    newFrame = false;
    changedPixels.clear();
    thisFrame.loadPixels(); // Make its pixels[] array available
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = thisFrame.pixels[i];
      //println(currColor);
      color prevColor = lastFrame[i];
      //println(prevColor);
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
      //println(diffR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      //int diff = abs(currColor - prevColor);
      //println(diff);

      if ((diffR + diffG + diffB) > threshold) {
        changedPixels.append(i);
      }

      lastFrame[i] = currColor;
    }
    newFrame = true;
    //println(changedPixels);
  }
}
