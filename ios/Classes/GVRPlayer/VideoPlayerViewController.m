#import <UIKit/UIKit.h>


#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()<GVRRendererViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIView *tiltView;
@property (nonatomic) AVPlayer *player;
@property (nonatomic) NSBundle *bundle;

@end

@implementation VideoPlayerViewController


- (void)viewDidLoad {
  [super viewDidLoad];

    // NSURL *felix = [NSURL URLWithString:@"https://video.felixsmart.com:9443/vod/_definst_/mp4:40A36BC38F2D/40A36BC38F2D1592246163170/playlist.m3u8?token=16eaa183-d548-475c-ad07-7b1c61e31dde"];
      
    [self updatePlayerWithURL: _videoURL];
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"360_bundle" ofType:@"bundle"];
    _bundle = [NSBundle bundleWithPath:bundlePath];
    
    [self hideGVRButtons];
    [self hideTiltView];
}

- (void)updatePlayerWithURL:(NSURL *)url {
    NSLog(@"updatePlayerUrl");
    _player = [AVPlayer playerWithURL:url];
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_player currentItem]];

  
    GVRRendererViewController *viewController = self.childViewControllers[0];
    GVRSceneRenderer *sceneRenderer = (GVRSceneRenderer *)viewController.rendererView.renderer;
    GVRVideoRenderer *videoRenderer = [sceneRenderer.renderList objectAtIndex:0];
    videoRenderer.player = _player;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self updateVideoPlayback];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  [super prepareForSegue:segue sender:sender];
  if ([segue.destinationViewController isKindOfClass:[GVRRendererViewController class]]) {
    GVRRendererViewController *viewController = segue.destinationViewController;
    viewController.delegate = self;
  }
}

#pragma mark - Actions

- (IBAction)didTapPlayPause:(id)sender {
    [self updateVideoPlayback];
}

- (IBAction)didTapBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:TRUE];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


//- (void)updateProgressBar {
//  UIProgressView *progressView = (UIProgressView *)_progressBar.customView;
//  double duration = CMTimeGetSeconds(_player.currentItem.duration);
//  double time = CMTimeGetSeconds(_player.currentTime);
//  progressView.progress = (CGFloat)(time / duration);
//}

#pragma mark - AVPlayer

- (void)playerItemDidReachEnd:(NSNotification *)notification {
  AVPlayerItem *player = [notification object];
  [player seekToTime:kCMTimeZero];
}

#pragma mark - GVRRendererViewControllerDelegate

- (void)didTapTriggerButton {
  [self updateVideoPlayback];
}

- (GVRRenderer *)rendererForDisplayMode:(GVRDisplayMode)displayMode {
    GVRVideoRenderer *videoRenderer = [[GVRVideoRenderer alloc] init];
    videoRenderer.player = _player;
    
//    [videoRenderer setSphericalMeshOfRadius:50
//                                  latitudes:50
//                                 longitudes:50
//                                verticalFov:180
//                              horizontalFov:360
//                                   meshType:kGVRMeshTypeMonoscopic]; // kGVRMeshTypeStereoTopBottom
    
    [videoRenderer setSphericalMeshOfRadius:_radius
                                  latitudes:_rows
                                 longitudes:_columns
                                verticalFov:_verticalFov
                              horizontalFov:_horizontalFov
                                   meshType:kGVRMeshTypeMonoscopic]; // kGVRMeshTypeStereoTopBottom


    GVRSceneRenderer *sceneRenderer = [[GVRSceneRenderer alloc] init];
    [sceneRenderer.renderList addRenderObject:videoRenderer];
    sceneRenderer.hidesReticle = YES;
    
    
  /*if (displayMode == kGVRDisplayModeEmbedded) {
    // Hide the reticle in embedded mode.
    sceneRenderer.hidesReticle = YES;
  } else {
    // In fullscreen mode, add the toolbar to the GL scene.
    GVRUIViewRenderer *viewRenderer = [[GVRUIViewRenderer alloc] initWithView:_toolbar];

    // Position the playback controls half a meter in front (z = -0.5).
    GLKMatrix4 position = GLKMatrix4MakeTranslation(-0.0, -0.3, -0.5);
    // Rotate along x axis so that it looks oriented towards us.
    position = GLKMatrix4RotateX(position, GLKMathDegreesToRadians(-20));
    viewRenderer.position = position;

    [sceneRenderer.renderList addRenderObject:viewRenderer];
  }*/

  return sceneRenderer;
}

#pragma mark - Private

- (void)updateVideoPlayback {
    
    if (_player.rate == 1.0) {
        [_player pause];
        //_toolbar.items = @[ _playButton, _progressBar ];
        
        if (_bundle != nil) {
            [_playPauseButton setImage: [UIImage imageNamed:@"play" inBundle:_bundle compatibleWithTraitCollection:nil]
                              forState:UIControlStateNormal];
        }
        
    } else {
        [_player play];
        //_toolbar.items = @[ _pauseButton, _progressBar ];

        if (_bundle != nil) {
            [_playPauseButton setImage: [UIImage imageNamed:@"pause" inBundle:_bundle compatibleWithTraitCollection:nil]
            forState:UIControlStateNormal];
        }
    }
}

- (void)hideGVRButtons {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        GVRRendererViewController *viewController = self.childViewControllers[0];
        self.videoView = (GVRRendererView *)viewController.view;
        self.videoView.overlayView.hidesBackButton = true;
        self.videoView.overlayView.hidesCardboardButton = true;
        self.videoView.overlayView.hidesFullscreenButton = true;
        self.videoView.overlayView.hidesSettingsButton = true;
    });
}

- (void)hideTiltView {
    if (!_showPlaceholder) {
        [self.tiltView setHidden:TRUE];
    } else {
        double delayInSeconds = 2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView transitionWithView:self.tiltView
                              duration:delayInSeconds
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                [self.tiltView setHidden:TRUE];
            } completion:NULL];
        });
    }
}

@end

