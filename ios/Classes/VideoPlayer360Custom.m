//
//  VideoPlayer360Custom.m
//  Pods
//
//  Created by Miluska Arias on 6/21/20.
//

#import "VideoPlayer360Custom.h"

#import "VideoPlayerViewController.h"
#import "Player360.h"

@implementation VideoPlayer360Custom

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    Player360* player360 =
        [[Player360 alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:player360 withId:@"player360"];
}

@end
