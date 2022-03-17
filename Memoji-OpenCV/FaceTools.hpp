//
//  FaceTools.hpp
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

#include <opencv2/opencv.hpp>
#include <opencv2/face.hpp>

using namespace cv;
using namespace std;
using namespace cv::face;

class FaceTools {
    
    public:
    
    /*
     Returns image with facial landmarks on the picture overlay
     */
    Mat getAnnotatedImageWithLandmarkFromImage(Mat image, CascadeClassifier faceDetector, cv::Ptr<Facemark> facemark);
    
    /*
     Returns a vector of Points corresponding to the position of the facial landmarks
     */
    vector<Point2f> getArrayOfLandmarksFromImage(Mat image, CascadeClassifier faceDetector, cv::Ptr<Facemark> facemark);
    
    private:
    
    
};
