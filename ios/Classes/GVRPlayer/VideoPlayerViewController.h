#import <UIKit/UIKit.h>
#import <GVRKit/GVRKit.h>

@interface VideoPlayerViewController : UIViewController
@property (nonatomic) IBOutlet GVRRendererView *videoView;
@property (strong, nonatomic) NSURL *videoURL;
@property(nonatomic, assign) int radius;
@property(nonatomic, assign) int verticalFov;
@property(nonatomic, assign) int horizontalFov;
@property(nonatomic, assign) int rows;
@property(nonatomic, assign) int columns;
@property(nonatomic, assign) bool showPlaceholder;
- (void)updatePlayerWithURL:(NSURL *)url;
@end
