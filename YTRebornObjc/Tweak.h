@interface YTQTMButton : UIButton
@property (strong, nonatomic) UIImageView *imageView;
+ (instancetype)iconButton;
@end

@interface YTPlaybackButton : UIControl
@end

@interface ABCSwitch : UISwitch
@end

@interface YTPivotBarItemView : UIView
@property(readonly, nonatomic) YTQTMButton *navigationButton;
@end

@interface YTTopAlignedView : UIView
@end

@interface YTAsyncCollectionView : UICollectionView
@end

@interface YTRightNavigationButtons : UIView
- (id)_viewControllerForAncestor;
@property(readonly, nonatomic) YTQTMButton *MDXButton;
@property(readonly, nonatomic) YTQTMButton *searchButton;
@property(readonly, nonatomic) YTQTMButton *notificationButton;
@property(strong, nonatomic) YTQTMButton *youtubeRebornButton;
- (void)setLeadingPadding:(CGFloat)arg1;
- (void)rebornRootOptionsAction;
@end

@interface YTMainAppControlsOverlayView : UIView
- (id)_viewControllerForAncestor;
@property(readonly, nonatomic) YTQTMButton *playbackRouteButton;
@property(readonly, nonatomic) YTQTMButton *previousButton;
@property(readonly, nonatomic) YTQTMButton *nextButton;
@property(readonly, nonatomic) ABCSwitch *autonavSwitch;
@property(readonly, nonatomic) YTQTMButton *closedCaptionsOrSubtitlesButton;
@property(strong, nonatomic) UIButton *rebornOverlayButton;
- (id)playPauseButton;
- (void)didPressPause:(id)button;
- (void)rebornOptionsAction;
- (void)rebornVideoDownloader :(NSString *)videoID;
- (void)rebornAudioDownloader :(NSString *)videoID;
- (void)rebornPictureInPicture :(NSString *)videoID;
- (void)rebornPlayInRebornPlayer :(NSString *)videoID;
- (void)rebornPlayInExternalApp :(NSString *)videoID;
@end

@interface YTMainAppSkipVideoButton
@property(readonly, nonatomic) UIImageView *imageView;
@end

@protocol YTPlaybackController
@end

@interface YTPlayerViewController : UIViewController <YTPlaybackController>
- (void)seekToTime:(CGFloat)time;
- (NSString *)currentVideoID;
- (CGFloat)currentVideoMediaTime;
- (void)autoFullscreen;
@end

@interface YTLocalPlaybackController : NSObject
- (NSString *)currentVideoID;
@end

@interface YTMainAppVideoPlayerOverlayViewController : UIViewController
- (CGFloat)mediaTime;
- (int)playerViewLayout;
- (NSInteger)playerState;
@end

@interface YTUserDefaults : NSObject
- (long long)appThemeSetting;
@end

@interface YTWatchController : NSObject
- (void)showFullScreen;
@end

@interface YTPivotBarViewController : UIViewController
- (void)selectItemWithPivotIdentifier:(id)pivotIndentifier;
@end

@interface YTPageStyleController
+ (NSInteger)pageStyle;
@end

@interface YTSingleVideoTime : NSObject
@end

@interface MLHAMQueuePlayer : NSObject
@property id playerEventCenter;
-(void)setRate:(float)rate;
@end

@interface YTVarispeedSwitchControllerOption : NSObject
- (id)initWithTitle:(id)title rate:(float)rate;
@end

@interface HAMPlayerInternal : NSObject
- (void)setRate:(float)rate;
@end

@interface MLPlayerEventCenter : NSObject
- (void)broadcastRateChange:(float)rate;
@end

@interface GPBMessage : NSObject
@end

@interface YTIPivotBarItemRenderer : NSObject
- (NSString *)pivotIdentifier;
@end

@interface YTIPivotBarIconOnlyItemRenderer : GPBMessage
- (NSString *)pivotIdentifier;
@end

@interface YTIPivotBarSupportedRenderers : NSObject
- (YTIPivotBarItemRenderer *)pivotBarItemRenderer;
- (YTIPivotBarIconOnlyItemRenderer *)pivotBarIconOnlyItemRenderer;
@end

@interface YTIPivotBarRenderer : NSObject
- (NSMutableArray <YTIPivotBarSupportedRenderers *> *)itemsArray;
@end

@interface YTSingleVideo : NSObject
- (NSString *)videoId;
@end

@interface YTReelHeaderView : UIView
- (id)_viewControllerForAncestor;
- (void)rebornOptionsAction;
- (void)rebornVideoDownloader :(NSString *)videoID;
- (void)rebornAudioDownloader :(NSString *)videoID;
- (void)rebornPictureInPicture :(NSString *)videoID;
- (void)rebornPlayInExternalApp :(NSString *)videoID;
@end

@interface YTReelPlayerMoreButton : YTQTMButton
@end

@interface YTTransportControlsButtonView : UIView
@end

@interface _ASDisplayView : UIView
@end

@interface YTLabel : UILabel
@end

@interface YTInlinePlayerBarContainerView : UIView
@property(readonly, nonatomic) YTLabel *durationLabel;
@property(readonly, nonatomic) YTLabel *currentTimeLabel;
@end

@interface YTIElementRendererCompatibilityOptions : GPBMessage
@property (nonatomic, assign, readwrite) BOOL hasAdLoggingData;
@end

@interface YTIElementRenderer : GPBMessage
@property (nonatomic, strong, readwrite) YTIElementRendererCompatibilityOptions *compatibilityOptions;
@property (nonatomic, assign, readwrite) BOOL hasCompatibilityOptions;
@end