//
//  FaceToolsBridge.m
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//


#import <opencv2/opencv.hpp>
#include <opencv2/face.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <Foundation/Foundation.h>
#import "FaceToolsBridge.h"
#include "FaceTools.hpp"

using namespace std;
using namespace cv;
using namespace cv::face;

@implementation FaceToolsBridge

CascadeClassifier faceDetector;
cv::Ptr<Facemark> facemark = FacemarkLBF::create();


/**
 Converting c++ array of cv::Points to Objective-C NSArray of CGPoint.
 To do so, I wrap the CGPoint into an NSValue
 */
- (NSArray<NSValue *> *)cvPointToSwiftPoint: (vector<Point2f>) number {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < number.size(); i++) {
        [mutableArray addObject:[NSValue valueWithCGPoint:CGPointMake(number[i].x, number[i].y)]];
    }
    
    return mutableArray;
    /*return @[
        [NSValue valueWithCGPoint:CGPointMake(10, 10)]
    ];*/
}

- (void)initialize {
    NSString *faceCascadePath = [[NSBundle mainBundle]
                                 pathForResource:@"haarcascade_frontalface_alt2"
                                 ofType:@"xml"];
    const CFIndex CASCADE_NAME_LEN = 2048;
    char *CASCADE_NAME = (char *) malloc(CASCADE_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)faceCascadePath,
                                        CASCADE_NAME,
                                        CASCADE_NAME_LEN);
    if(!faceDetector.load(CASCADE_NAME)) {
        cout << "Unable to load the face detector!!!!" << endl;
        exit(-1);
    }
    
    NSString *landmarkModelPath = [[NSBundle mainBundle]
                                 pathForResource:@"lbfmodel"
                                 ofType:@"yaml"];
    const CFIndex LANDMARK_NAME_LEN = 2048;
    char *LANDMARK_NAME = (char *) malloc(LANDMARK_NAME_LEN);
    CFStringGetFileSystemRepresentation( (CFStringRef)landmarkModelPath,
                                        LANDMARK_NAME,
                                        LANDMARK_NAME_LEN);
    facemark->loadModel(LANDMARK_NAME);
}

- (NSArray<NSValue *> *) getArrayOfLandmarksFromImage: (UIImage *) image {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the face detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    // C++ source code with OpenCV implementation
    FaceTools faceDetectorTools;
    
    // Sending the picture and the classifier to get an array of facial landmark
    auto landmarkVector = faceDetectorTools.getArrayOfLandmarksFromImage(convertedColorSpaceImage, faceDetector, facemark);
    
    // The returned value is a C++ optional, so we open it and re-asign values
    if (landmarkVector.has_value()) {
        // If the optional contains an array, we transform it from an array of cv::points to an NSArray of CGPoint
        return [self cvPointToSwiftPoint:landmarkVector.value()];
    } else {
        // If the optional doens't contain a value, we return an empty NSArray
        NSArray *array = [NSArray array];
        return array;
    }
}

- (UIImage *) getAnnotatedImageFrom: (UIImage *) image {
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the face detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    // C++ source code with OpenCV implementation
    FaceTools faceDetectorTools;
    
    // Sending the picture and the classifier to get an annotated image with the found landmarks
    cv::Mat annotatedImage = faceDetectorTools.getAnnotatedImageWithLandmarkFromImage(convertedColorSpaceImage, faceDetector, facemark);
    
    // convert mat to uiimage and return it to the caller
    return MatToUIImage(annotatedImage);
}
    

@end
