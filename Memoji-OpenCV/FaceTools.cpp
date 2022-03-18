//
//  FaceTools.cpp
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

#include "FaceTools.hpp"
#include <opencv2/face.hpp>

using namespace cv;
using namespace std;
using namespace cv::face;

#define COLOR Scalar(255, 200,0)

// Function found online
// drawPolyLine draws a poly line by joining
// successive points between the start and end indices.
void drawPolyline
(
  Mat &im,
  const vector<Point2f> &landmarks,
  const int start,
  const int end,
  bool isClosed = false
)
{
    // Gather all points between the start and end indices
    vector <Point> points;
    for (int i = start; i <= end; i++)
    {
        points.push_back(cv::Point(landmarks[i].x, landmarks[i].y));
    }
    // Draw polylines.
    polylines(im, points, isClosed, COLOR, 2, 16);
}

/**
 Draw each  landmarks points
 */
void drawLandmarksPoints(Mat &im, vector<Point2f> &landmarks)
{
  for(int i = 0; i < landmarks.size(); i++)
  {
    circle(im,landmarks[i],3, COLOR, FILLED);
    cv::putText(im, to_string(i), landmarks[i], cv::FONT_HERSHEY_SIMPLEX, 1, cv::Scalar(255, 0, 0), 2, cv::LINE_AA);
  }
}

/**
 Function found online
 Draw landmarks and a rectangle arround face
 */
void drawLandmarksLines(Mat &im, vector<Point2f> &landmarks)
{
    // Draw face for the 68-point model.
    if (landmarks.size() == 68)
    {
      drawPolyline(im, landmarks, 0, 16);           // Jaw line
      drawPolyline(im, landmarks, 17, 21);          // Left eyebrow
      drawPolyline(im, landmarks, 22, 26);          // Right eyebrow
      drawPolyline(im, landmarks, 27, 30);          // Nose bridge
      drawPolyline(im, landmarks, 30, 35, true);    // Lower nose
      drawPolyline(im, landmarks, 36, 41, true);    // Left eye
      drawPolyline(im, landmarks, 42, 47, true);    // Right Eye
      drawPolyline(im, landmarks, 48, 59, true);    // Outer lip
      drawPolyline(im, landmarks, 60, 67, true);    // Inner lip
    }
    else
    { // If the number of points is not 68, we do not know which
      // points correspond to which facial features. So, we draw
      // one dot per landamrk.
        drawLandmarksPoints(im, landmarks);
    }
}

/* MAIN CALL*/

/**
 Get array of landmarks from image
 */
optional<vector<Point2f>> FaceTools::getArrayOfLandmarksFromImage(Mat image, CascadeClassifier faceDetector, Ptr<Facemark> facemark) {
    
    Mat gray;
    
    // Find face
    vector<Rect> faces;
    // Convert frame to grayscale because
    // faceDetector requires grayscale image.
    cvtColor(image, gray, COLOR_BGR2GRAY);

    // Detect faces
    faceDetector.detectMultiScale(gray, faces);
    
    cv::Scalar color(0, 105, 205);
    //int frame_thickness = 4;
    
    // Variable for landmarks.
    // Landmarks for one face is a vector of points
    // There can be more than one face in the image. Hence, we
    // use a vector of vector of points.
    vector< vector<Point2f> > landmarks;
    
    // Run landmark detector
    bool success = facemark->fit(image,faces,landmarks);
    
    if(success)
    {
        return landmarks[0];
    } else {
        return {};
    }
}

/**
 Get annoted image with landmarks from image
 */
Mat FaceTools::getAnnotatedImageWithLandmarkFromImage(Mat image, CascadeClassifier faceDetector, Ptr<Facemark> facemark) {
    
    Mat gray;
    
    // Find face
    vector<Rect> faces;
    // Convert frame to grayscale because
    // faceDetector requires grayscale image.
    cvtColor(image, gray, COLOR_BGR2GRAY);
    
    // Detect faces
    faceDetector.detectMultiScale(gray, faces);
    
    // Variable for landmarks.
    // Landmarks for one face is a vector of points
    // There can be more than one face in the image. Hence, we
    // use a vector of vector of points.
    vector< vector<Point2f> > landmarks;
    
    // Run landmark detector
    bool success = facemark->fit(image,faces,landmarks);
    
    if(success)
    {
        // If successful, render the landmarks on the face
        for(int i = 0; i < landmarks.size(); i++)
        {
          drawLandmarksLines(image, landmarks[i]);
          //drawLandmarksPoints(image, landmarks[i]);
        }
        
        // Uncomment to draw rectangle arround face
        //cv::Scalar color(0, 105, 205);
        //int frame_thickness = 4;
        //cv::rectangle(image, faces[0], color, frame_thickness);
    }
    
    return image;
}
