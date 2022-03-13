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
        //array = [array arrayByAddingObject:[]
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
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    // Run lane detection
    FaceTools laneDetector;
    
    ///////////////// HERE TO CONTINUE RETURN NULL //////////
    vector<Point2f> vector = laneDetector.getArrayOfLandmarksFromImage(convertedColorSpaceImage, faceDetector, facemark);
    
    return [self cvPointToSwiftPoint:vector];
}

- (UIImage *) getAnnotedImageWithLandmarkFromImage: (UIImage *) image {
    
    // convert uiimage to mat
    cv::Mat opencvImage;
    UIImageToMat(image, opencvImage, true);
    
    // convert colorspace to the one expected by the lane detector algorithm (RGB)
    cv::Mat convertedColorSpaceImage;
    cv::cvtColor(opencvImage, convertedColorSpaceImage, COLOR_RGBA2RGB);
    
    // Run lane detection
    FaceTools laneDetector;
    
    cv::Mat imageWithLaneDetected = laneDetector.getAnnotedImageWithLandmarkFromImage(convertedColorSpaceImage, faceDetector, facemark);
    
    // convert mat to uiimage and return it to the caller
    return MatToUIImage(imageWithLaneDetected);
}
    

@end
