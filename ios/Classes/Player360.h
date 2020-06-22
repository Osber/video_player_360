//
//  Player360.h
//  Pods
//
//  Created by Miluska Arias on 6/21/20.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "VideoPlayerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface Player360Controller : NSObject <FlutterPlatformView>

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end


@interface Player360 : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end

NS_ASSUME_NONNULL_END
