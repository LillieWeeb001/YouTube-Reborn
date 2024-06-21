#import "RebornPlayerController.h"

@interface RebornPlayerController ()
- (void)coloursView;
@end

@implementation RebornPlayerController

AVPlayer *rebornPlayer;
AVPlayerLayer *rebornPlayerLayer;
AVPictureInPictureController *rebornPictureInPictureController;

- (void)loadView {
	[super loadView];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self coloursView];

    UIWindow *boundsWindow = [[[UIApplication sharedApplication] windows] firstObject];

    AVPlayerItem *rebornPlayerItem = [[AVPlayerItem alloc] initWithURL:self.videoPath];
    rebornPlayer = [[AVPlayer alloc] initWithPlayerItem:rebornPlayerItem];
    CMTime newTime = CMTimeMakeWithSeconds([self.videoTime floatValue], NSEC_PER_SEC);
    [rebornPlayer seekToTime:newTime];

    [rebornPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];

    rebornPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:rebornPlayer];
    rebornPlayerLayer.frame = CGRectMake(0, boundsWindow.safeAreaInsets.top, self.view.bounds.size.width, self.view.bounds.size.width * 9 / 16);
    // rebornPlayerLayer.hidden = YES;

    [self.view.layer addSublayer:rebornPlayerLayer];
}

- (void)coloursView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self coloursView];
}

@end

@implementation RebornPlayerController (Privates)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == rebornPlayer && [keyPath isEqualToString:@"status"]) {
        if (rebornPlayer.status == AVPlayerStatusReadyToPlay) {
            if ([AVPictureInPictureController isPictureInPictureSupported]) {
                rebornPictureInPictureController = [[AVPictureInPictureController alloc] initWithPlayerLayer:rebornPlayerLayer];
                rebornPictureInPictureController.delegate = self;
                rebornPictureInPictureController.canStartPictureInPictureAutomaticallyFromInline = YES;
            }
            [rebornPlayer play];
        }
    }
}

@end