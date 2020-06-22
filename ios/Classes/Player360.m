//
//  Player360.m
//  Pods
//
//  Created by Miluska Arias on 6/21/20.
//

#import "Player360.h"



@implementation Player360 {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
  return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    
    Player360Controller *viewController =
          [[Player360Controller alloc] initWithWithFrame:frame
                                           viewIdentifier:viewId
                                                arguments:args
                                          binaryMessenger:_messenger];
    
  return viewController;
}

@end

@implementation Player360Controller {
  VideoPlayerViewController* _viewController;
  int64_t _viewId;
  FlutterMethodChannel* _channel;
}

- (instancetype)initWithWithFrame:(CGRect)frame
                   viewIdentifier:(int64_t)viewId
                        arguments:(id _Nullable)args
                  binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if ([super init]) {
    _viewId = viewId;
      
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"360_bundle" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
              
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"GVRBoard" bundle:bundle];
      
    _viewController = (VideoPlayerViewController*)[storyBoard instantiateInitialViewController];
    
    NSString* channelName = [NSString stringWithFormat:@"player360_%lld", viewId];
      
    _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
      
    __weak __typeof__(self) weakSelf = self;
      
    [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      [weakSelf onMethodCall:call result:result];
    }];

  }
  return self;
}

- (UIView*)view {
    return _viewController.view;
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"++++++++++++++++++++++++");
    
  if ([@"playvideo" isEqualToString:call.method]) {
      NSLog(@"++++++++++++++++++++++++");
      NSString *video_url = call.arguments[@"video_url"];
      int radius = [call.arguments[@"radius"] intValue];
      int verticalFov = [call.arguments[@"verticalFov"] intValue];
      int horizontalFov = [call.arguments[@"horizontalFov"] intValue];
      int rows = [call.arguments[@"rows"] intValue];
      int columns = [call.arguments[@"columns"] intValue];
      bool showPlaceholder = [call.arguments[@"showPlaceholder"] boolValue];
      
      if (video_url != nil) {
          NSURL *url = [[NSURL alloc] initWithString:video_url];
          
          if (url != nil) {
              _viewController.videoURL = url;
              _viewController.radius = radius;
              _viewController.verticalFov = verticalFov;
              _viewController.horizontalFov = horizontalFov;
              _viewController.rows = rows;
              _viewController.columns = columns;
              _viewController.showPlaceholder = showPlaceholder;
              // [_viewController updatePlayerWithURL:url];
          }
      }
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}



@end
