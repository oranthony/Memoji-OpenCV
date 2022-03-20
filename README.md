# Memoji OpenCV
Attempt to recreate Memoji without TrueDepth sensor.

## Objective
My goal was to play with OpenCV and Objective-C++ to see if I could prototype an experimental version of Memoji.

## How it started
At university I worked at multiple occasions with OpenCV. I've done Steganography with it, as well as a hand sign detector (American Sign Language) with Machine Learning.

## How it works
It is a SwiftUI App that records the front camera feed and send it to a C++ written OpenCV program through an Objective-C++ Bridge.

![Basic Model of the App](Doc/model.jpg)



## How to use it 
Run the script install-opencv.sh to download opencv and the required 3D model. The srcipt will automatically move the files to the correct place.

Once compiled and installed, you have to hold your iPhone at 90° close to your face. A text will be displayed on the app to tell you to get closer or move away from the screen in order to be at the correct distance from the device.

## Result
The facial landmarks produced move too much from one image to another. This makes the result not stable enough to build an efficient face tracker for a memoji like App. 


https://user-images.githubusercontent.com/6161861/159190314-6def951e-21a2-4dc5-a667-e46ff11bbcd5.mp4

