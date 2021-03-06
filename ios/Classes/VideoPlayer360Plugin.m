#import "VideoPlayer360Plugin.h"
#import "VideoPlayerViewController.h"
#import "Player360.h"

@implementation VideoPlayer360Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    Player360* player360 =
        [[Player360 alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:player360 withId:@"player360"];
}
@end
