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
      
    _viewController.radius = 50;
    _viewController.verticalFov = 180;
    _viewController.horizontalFov = 360;
    _viewController.rows = 50;
    _viewController.columns = 50;
    _viewController.showPlaceholder = false;
    
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
      if (video_url != nil) {
          NSURL *url = [[NSURL alloc] initWithString:video_url];
          
          if (url != nil) {
              [_viewController updatePlayerWithURL:url];
          }
      }
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}



@end
