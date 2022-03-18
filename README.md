# Memoji OpenCV
Attempt to recreate Memoji without TrueDepth sensor.

## Objective
My goal was to play with OpenCV and Objective-C++ to see if I could prototype an experimental version of Memoji.

## How it started
At university I worked at multiple occasions with OpenCV. I've done Steganography with it, as well as a hand sign detector (American Sign Language) with Machine Learning.

## How it works
It is a SwiftUI App that records the front camera feed and send it to a C++ written OpenCV program through an Objective-C++ Bridge.



## How to use it 
Run the script install-opencv.sh to download opencv and the required 3D model. The srcipt will automatically move the files to the correct place.

Once compiled and install on an iPhone, you have to hold it at 90° close to your face. A text will be displayed on the app to tell you to get closer or move away from the screen in order to be at the correct distance from the device.
