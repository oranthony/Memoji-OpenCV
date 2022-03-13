//
//  FaceToolsBridge.h
//  Memoji-OpenCV
//
//  Created by anthony loroscio on 09/03/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceToolsBridge : NSObject

- (void)initialize;

- (UIImage *) getAnnotedImageWithLandmarkFromImage: (UIImage *) image;

- (NSArray<NSValue *> *) getArrayOfLandmarksFromImage: (UIImage *) image;

@end
