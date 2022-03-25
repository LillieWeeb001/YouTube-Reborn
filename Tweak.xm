#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import <AFNetworking/AFNetworking.h>
#import <MediaRemote/MediaRemote.h>
#import "Controllers/RootOptionsController.h"
#import "Controllers/PictureInPictureController.h"
#import "../Jailbreak-Detection-Lib/JailbreakDetectionLib.h"
#import "Tweak.h"

NSString *YTApiKey = @"AIzaSyAcHI73xntvCiURGWERFcJxm5vX12p5bN8";
UIColor *rebornCustomColour;

UIColor *hexColour() {
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kYTRebornColourOptionsVTwo"];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
    [unarchiver setRequiresSecureCoding:NO];
    return [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
}

YTLocalPlaybackController *playingVideoID;

%hook YTLocalPlaybackController
- (NSString *)currentVideoID {
    playingVideoID = self;
    return %orig;
}
%end

YTMainAppVideoPlayerOverlayViewController *resultOut;
YTMainAppVideoPlayerOverlayViewController *layoutOut;
YTMainAppVideoPlayerOverlayViewController *stateOut;

%hook YTMainAppVideoPlayerOverlayViewController
- (CGFloat)mediaTime {
    resultOut = self;
    return %orig;
}
- (int)playerViewLayout {
    layoutOut = self;
    return %orig;
}
- (NSInteger)playerState {
    stateOut = self;
    return %orig;
}
%end

YTUserDefaults *ytThemeSettings;

%hook YTUserDefaults
- (long long)appThemeSetting {
    ytThemeSettings = self;
    return %orig;
}
%end

%hook YTWrapperView
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSettingsViewController")]) {
        UIView *childView = MSHookIvar<UIView *>(self, "_childView");
        childView.frame = CGRectMake(childView.frame.origin.x, 51, childView.frame.size.width, childView.frame.size.height);
        
        long long ytDarkModeCheck = [ytThemeSettings appThemeSetting];

        UIView *rebornView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, childView.bounds.size.width, 51)];
        [rebornView setUserInteractionEnabled:YES];
        rebornView.backgroundColor = [UIColor clearColor];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, rebornView.frame.size.width, 51)];
        label.text = @"YT Reborn Settings";
        if (ytDarkModeCheck == 0 || ytDarkModeCheck == 1) {
            if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                label.textColor = [UIColor blackColor];
            } else {
                label.textColor = [UIColor whiteColor];
            }
        }
        if (ytDarkModeCheck == 2) {
            label.textColor = [UIColor blackColor];
        }
        if (ytDarkModeCheck == 3) {
            label.textColor = [UIColor whiteColor];
        }
        [label setFont:[UIFont systemFontOfSize:16]];
        [rebornView addSubview:label];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(rootOptionsAction:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, rebornView.frame.size.width, 51);
        [rebornView addSubview:button];

        [self addSubview:rebornView];
    }
}
%new;
- (void)rootOptionsAction:(id)sender {
    RootOptionsController *rootOptionsController = [[RootOptionsController alloc] init];
    UINavigationController *rootOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:rootOptionsController];
    rootOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

    UIViewController *rootPrefsViewController = self._viewControllerForAncestor;
    [rootPrefsViewController presentViewController:rootOptionsControllerView animated:YES completion:nil];
}
%end

%hook SSOKeychain
+ (id)accessGroup {
    if (![JailbreakDetectionLib isJailbroken]) {
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                            (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                            @"bundleSeedID", kSecAttrAccount,
                            @"", kSecAttrService,
                            (id)kCFBooleanTrue, kSecReturnAttributes,
                            nil];
        CFDictionaryRef result = nil;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        if (status == errSecItemNotFound)
            status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            if (status != errSecSuccess)
                return nil;
        NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
        
        return accessGroup;
    }
    return %orig;
}
+ (id)sharedAccessGroup {
    if (![JailbreakDetectionLib isJailbroken]) {
        NSDictionary *query = [NSDictionary dictionaryWithObjectsAndKeys:
                            (__bridge NSString *)kSecClassGenericPassword, (__bridge NSString *)kSecClass,
                            @"bundleSeedID", kSecAttrAccount,
                            @"", kSecAttrService,
                            (id)kCFBooleanTrue, kSecReturnAttributes,
                            nil];
        CFDictionaryRef result = nil;
        OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
        if (status == errSecItemNotFound)
            status = SecItemAdd((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
            if (status != errSecSuccess)
                return nil;
        NSString *accessGroup = [(__bridge NSDictionary *)result objectForKey:(__bridge NSString *)kSecAttrAccessGroup];
        
        return accessGroup;
    }
    return %orig;
}
%end

NSString *videoTime;
NSURL *directURL;
NSURL *streamURL;

%hook YTMainAppControlsOverlayView

%property(retain, nonatomic) UIButton *overlayButtonOne;

- (id)initWithDelegate:(id)delegate {
    self = %orig;
    if (self) {
        self.overlayButtonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.overlayButtonOne addTarget:self action:@selector(optionsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.overlayButtonOne setTitle:@"OP" forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES) {
                self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
            } else {
                self.overlayButtonOne.frame = CGRectMake(40, 24, 40.0, 30.0);
            }
        } else {
            self.overlayButtonOne.frame = CGRectMake(40, 9, 40.0, 30.0);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButtonVTwo"] == YES) {
            self.overlayButtonOne.hidden = YES;
        }
        [self addSubview:self.overlayButtonOne];
    }
    return self;
}

- (void)setTopOverlayVisible:(BOOL)visible isAutonavCanceledState:(BOOL)canceledState {
    if (canceledState) {
        if (!self.overlayButtonOne.hidden) {
            self.overlayButtonOne.alpha = 0.0;
        }
    } else {
        if (!self.overlayButtonOne.hidden) {
            int rotation = [layoutOut playerViewLayout];
            if (rotation == 2) {
                self.overlayButtonOne.alpha = visible ? 1.0 : 0.0;
            } else {
                self.overlayButtonOne.alpha = 0.0;
            }
        }
    }
    %orig;
}

%new;
- (void)optionsAction:(id)sender {
    NSInteger videoStatus = [stateOut playerState];
    if (videoStatus == 3) {
        MRMediaRemoteSendCommand(MRMediaRemoteCommandPause, 0);
    }

    XCDYouTubeClient.innertubeApiKey = YTApiKey;

    NSString *videoIdentifier = [playingVideoID currentVideoID];

    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video) {
            NSDictionary *streamURLs = video.streamURLs;

            videoTime = [NSString stringWithFormat:@"%f", [resultOut mediaTime]];
            directURL = streamURLs[@(XCDYouTubeVideoQualityHD720)] ?: streamURLs[@(XCDYouTubeVideoQualityMedium360)] ?: streamURLs[@(XCDYouTubeVideoQualitySmall240)];
            streamURL = streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming];

            UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Audio (M4A)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self audioDownloader];
            }]];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Download Video (MP4)" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self videoDownloader];
            }]];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Picture In Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self pictureInPicture];
            }]];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Play In External App" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self playInApp];
            }]];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Test" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self test];
            }]];

            [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }]];

            CGRect rect = self.frame;
            rect.origin.x = self.frame.size.width / 20;
            rect.origin.y = self.frame.size.height / 20;
            alertMenu.popoverPresentationController.sourceView = self;
            alertMenu.popoverPresentationController.sourceRect = rect;

            UIViewController *menuViewController = self._viewControllerForAncestor;
            [menuViewController presentViewController:alertMenu animated:YES completion:nil];
        } else {
            UIAlertController *alertMenuError = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Unable to fetch youtube video url from googles api" preferredStyle:UIAlertControllerStyleAlert];

            [alertMenuError addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];

            UIViewController *menuErrorViewController = self._viewControllerForAncestor;
            [menuErrorViewController presentViewController:alertMenuError animated:YES completion:nil];
        }
    }];
}

%new;
- (void)audioDownloader {
    if (directURL != NULL) {
        NSString *videoIdentifier = [playingVideoID currentVideoID];

        NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

        NSString *apiUrl = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=%@", videoIdentifier, YTApiKey];
        NSURL *dataUrl = [NSURL URLWithString:apiUrl];
        NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

        NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSMutableDictionary *jsonResponse = responseObject;
                NSArray *items = [jsonResponse objectForKey:@"items"];
                NSString *escapedString;
                for (NSDictionary *item in items) {
                    NSDictionary *snippet = [item objectForKey:@"snippet"];
                    NSString *title = [snippet objectForKey:@"title"];
                    NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                    escapedString = [[title componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                }

                UIAlertController *alertDownloading = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Audio Is Downloading \n\nProgress: 0.00%% \n\nDon't Exit The App"] preferredStyle:UIAlertControllerStyleAlert];
                UIViewController *downloadingViewController = self._viewControllerForAncestor;
                [downloadingViewController presentViewController:alertDownloading animated:YES completion:nil];
    
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                NSURLRequest *request = [NSURLRequest requestWithURL:directURL];

                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        float downloadPercent = downloadProgress.fractionCompleted * 100;
                        alertDownloading.message = [NSString stringWithFormat:@"Audio Is Downloading \n\nProgress: %.02f%% \n\nDon't Exit The App", downloadPercent];
                    });
                } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    
                    NSURL *outputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/videoplayback.m4a", documentsDirectory]];
                    NSURL *inputURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory]];
                    AVAsset *asset = [AVAsset assetWithURL:inputURL];

                    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
                    session.outputURL = outputURL;
                    session.outputFileType = AVFileTypeAppleM4A;

                    [session exportAsynchronouslyWithCompletionHandler:^{
                        if (session.status == AVAssetExportSessionStatusCompleted) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSString *oldVideoName = [NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory];
                                NSString *oldName = [NSString stringWithFormat:@"%@/videoplayback.m4a", documentsDirectory];
                                NSString *newName = [NSString stringWithFormat:@"%@/%@.m4a", documentsDirectory, escapedString];
                                [[NSFileManager defaultManager] removeItemAtPath:oldVideoName error:nil];
                                [[NSFileManager defaultManager] moveItemAtPath:oldName toPath:newName error:nil];
                                [alertDownloading dismissViewControllerAnimated:YES completion:nil];
                                UIAlertController *alertDownloaded = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Audio Download Complete" preferredStyle:UIAlertControllerStyleAlert];

                                [alertDownloaded addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                }]];

                                UIViewController *downloadedViewController = self._viewControllerForAncestor;
                                [downloadedViewController presentViewController:alertDownloaded animated:YES completion:nil];
                            });
                        }
                    }];
                }];
                [downloadTask resume];
            }
        }];
        [dataTask resume];
    } else {
        UIAlertController *alertFailed = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the downloader" preferredStyle:UIAlertControllerStyleAlert];

        [alertFailed addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];

        UIViewController *failedViewController = self._viewControllerForAncestor;
        [failedViewController presentViewController:alertFailed animated:YES completion:nil];
    }
}

%new;
- (void)videoDownloader {
    if (directURL != NULL) {
        NSString *videoIdentifier = [playingVideoID currentVideoID];

        NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

        NSString *apiUrl = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/videos?part=snippet&id=%@&key=%@", videoIdentifier, YTApiKey];
        NSURL *dataUrl = [NSURL URLWithString:apiUrl];
        NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

        NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSMutableDictionary *jsonResponse = responseObject;
                NSArray *items = [jsonResponse objectForKey:@"items"];
                NSString *escapedString;
                for (NSDictionary *item in items) {
                    NSDictionary *snippet = [item objectForKey:@"snippet"];
                    NSString *title = [snippet objectForKey:@"title"];
                    NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
                    escapedString = [[title componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
                }

                UIAlertController *alertDownloading = [UIAlertController alertControllerWithTitle:@"Notice" message:[NSString stringWithFormat:@"Video Is Downloading \n\nProgress: 0.00%% \n\nDon't Exit The App"] preferredStyle:UIAlertControllerStyleAlert];
                UIViewController *downloadingViewController = self._viewControllerForAncestor;
                [downloadingViewController presentViewController:alertDownloading animated:YES completion:nil];
    
                NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
                NSURLRequest *request = [NSURLRequest requestWithURL:directURL];

                NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        float downloadPercent = downloadProgress.fractionCompleted * 100;
                        alertDownloading.message = [NSString stringWithFormat:@"Video Is Downloading \n\nProgress: %.02f%% \n\nDon't Exit The App", downloadPercent];
                    });
                } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *oldName = [NSString stringWithFormat:@"%@/videoplayback.mp4", documentsDirectory];
                    NSString *newName = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, escapedString];
                    [[NSFileManager defaultManager] moveItemAtPath:oldName toPath:newName error:nil];
                    [alertDownloading dismissViewControllerAnimated:YES completion:nil];
                    UIAlertController *alertDownloaded = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Video Download Complete" preferredStyle:UIAlertControllerStyleAlert];

                    [alertDownloaded addAction:[UIAlertAction actionWithTitle:@"Finish" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }]];

                    UIViewController *downloadedViewController = self._viewControllerForAncestor;
                    [downloadedViewController presentViewController:alertDownloaded animated:YES completion:nil];
                }];
                [downloadTask resume];
            }
        }];
        [dataTask resume];
    } else {
        UIAlertController *alertFailed = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the downloader" preferredStyle:UIAlertControllerStyleAlert];

        [alertFailed addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];

        UIViewController *failedViewController = self._viewControllerForAncestor;
        [failedViewController presentViewController:alertFailed animated:YES completion:nil];
    }
}

%new;
- (void)pictureInPicture {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) {
        if (streamURL != NULL) {
            PictureInPictureController *pictureInPictureController = [[PictureInPictureController alloc] init];
            pictureInPictureController.videoTime = videoTime;
            pictureInPictureController.videoPath = streamURL;
            UINavigationController *pictureInPictureControllerView = [[UINavigationController alloc] initWithRootViewController:pictureInPictureController];
            pictureInPictureControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            UIViewController *pictureInPictureViewController = self._viewControllerForAncestor;
            [pictureInPictureViewController presentViewController:pictureInPictureControllerView animated:YES completion:nil];
        } else {
            UIAlertController *alertPip = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the Picture-In-Picture" preferredStyle:UIAlertControllerStyleAlert];

            [alertPip addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];

            UIViewController *pipViewController = self._viewControllerForAncestor;
            [pipViewController presentViewController:alertPip animated:YES completion:nil];
        }
    } else {
        UIAlertController *alertPip = [UIAlertController alertControllerWithTitle:@"Notice" message:@"You must enable 'Background Playback' in YouTube Reborn settings to use Picture-In-Picture" preferredStyle:UIAlertControllerStyleAlert];

        [alertPip addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];

        UIViewController *pipViewController = self._viewControllerForAncestor;
        [pipViewController presentViewController:alertPip animated:YES completion:nil];
    }
}

%new;
- (void)playInApp {
    if (streamURL != NULL) {
        UIAlertController *alertMenu = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Play In Infuse" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"infuse://x-callback-url/play?url=%@", streamURL]] options:@{} completionHandler:nil];
        }]];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Play In VLC" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"vlc-x-callback://x-callback-url/stream?url=%@", streamURL]] options:@{} completionHandler:nil];
        }]];

        [alertMenu addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];

        UIViewController *menuViewController = self._viewControllerForAncestor;
        [menuViewController presentViewController:alertMenu animated:YES completion:nil];
    } else {
        UIAlertController *alertFailed = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This video is not supported by the play in external app feature" preferredStyle:UIAlertControllerStyleAlert];

        [alertFailed addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }]];

        UIViewController *failedViewController = self._viewControllerForAncestor;
        [failedViewController presentViewController:alertFailed animated:YES completion:nil];
    }
}

%new;
- (void)test {
    NSString *videoIdentifier = [playingVideoID currentVideoID];
    
    NSURLSessionConfiguration *dataConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *dataManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:dataConfiguration];

    NSString *apiUrl = [NSString stringWithFormat:@"https://yt.lillieweeb001.xyz/?videoID=%@", videoIdentifier];
    NSURL *dataUrl = [NSURL URLWithString:apiUrl];
    NSURLRequest *apiRequest = [NSURLRequest requestWithURL:dataUrl];

    NSURLSessionDataTask *dataTask = [dataManager dataTaskWithRequest:apiRequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            UIAlertController *alertFailed = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Failed" preferredStyle:UIAlertControllerStyleAlert];

            [alertFailed addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];

            UIViewController *failedViewController = self._viewControllerForAncestor;
            [failedViewController presentViewController:alertFailed animated:YES completion:nil];
        } else {
            NSMutableDictionary *jsonResponse = responseObject;
            NSString *thumbnail = [jsonResponse objectForKey:@"thumbnail"];

            UIAlertController *alertTest = [UIAlertController alertControllerWithTitle:@"Notice" message:thumbnail preferredStyle:UIAlertControllerStyleAlert];

            [alertTest addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];

            UIViewController *testViewController = self._viewControllerForAncestor;
            [testViewController presentViewController:alertTest animated:YES completion:nil];
        }
    }];
    [dataTask resume];
}
%end

%group gNoVideoAds
%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%hook YTInnerTubeContextDecorator
- (void)decorateContext:(id)arg1 {
}
%end
%hook YTIPlayerResponse
- (BOOL)isMonetized {
    return NO;
}
%end
%hook YTDataUtils
+ (id)spamSignalsDictionary {
    return NULL;
}
%end
%end

%group gBackgroundPlayback
%hook YTIPlayerResponse
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTSingleVideo
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTSingleVideoMediaData
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTPlaybackData
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground {
    return YES;
}
%end
%hook YTPlaybackBackgroundTaskController
- (BOOL)isContentPlayableInBackground {
    return YES;
}
- (void)setContentPlayableInBackground:(BOOL)arg1 {
    arg1 = YES;
	%orig;
}
%end
%hook YTBackgroundabilityPolicy
- (BOOL)isBackgroundableByUserSettings {
    return YES;
}
%end
%end

%group gNoCastButton
%hook YTSettings
- (BOOL)disableMDXDeviceDiscovery {
    return YES;
} 
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self MDXButton] isHidden]) [[self MDXButton] setHidden:YES];
}
%end
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self playbackRouteButton] isHidden]) [[self playbackRouteButton] setHidden:YES];
}
%end
%end

%group gNoNotificationButton
%hook YTNotificationPreferenceToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTNotificationMultiToggleButton
- (void)setHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self notificationButton] isHidden]) [[self notificationButton] setHidden:YES];
}
%end
%end

%group gAllowHDOnCellularData
%hook YTUserDefaults
- (BOOL)disableHDOnCellular {
	return NO;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTSettings
- (BOOL)disableHDOnCellular {
	return NO;
}
- (void)setDisableHDOnCellular:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%end

%group gShowStatusBarInOverlay
%hook YTSettings
- (BOOL)showStatusBarWithOverlay {
    return YES;
}
%end
%end

%group gDisableRelatedVideosInOverlay
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return NO;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gDisableVideoEndscreenPopups
%hook YTCreatorEndscreenView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%end

%group gDisableYouTubeKids
%hook YTWatchMetadataAppPromoCell
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTHUDMessageView
- (id)initWithMessage:(id)arg1 dismissHandler:(id)arg2 {
    return NULL;
}
%end
%hook YTNGWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%hook YTWatchMiniBarViewController
- (id)miniplayerRenderer {
    return NULL;
}
%end
%end

%group gDisableVoiceSearch
%hook YTSearchTextField
- (void)setVoiceSearchEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTSearchViewController
- (void)viewDidLoad {
    %orig();
    MSHookIvar<UIButton *>(self, "_voiceButton").enabled = NO;
    MSHookIvar<UIButton *>(self, "_voiceButton").frame = CGRectMake(0, 0, 0, 0);
}
%end
%end

%group gDisableHints
%hook YTSettings
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%hook YTUserDefaults
- (BOOL)areHintsDisabled {
	return YES;
}
- (void)setHintsDisabled:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
%end
%end

%group gHideExploreTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideUploadTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideSubscriptionsTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gHideLibraryTab
%hook YTPivotBarView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

%group gDisableDoubleTapToSkip
%hook YTDoubleTapToSeekController
- (void)enableDoubleTapToSeek:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
- (void)showDoubleTapToSeekEducationView:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTSettings
- (BOOL)doubleTapToSeekEnabled {
    return NO;
}
%end
%end

%group gHideOverlayDarkBackground
%hook YTMainAppVideoPlayerOverlayView
- (void)setBackgroundVisible:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%end

%group gAlwaysShowPlayerBar
%hook YTPlayerBarController
- (void)setPlayerViewLayout:(int)arg1 {
    arg1 = 2;
    %orig;
} 
%end
%hook YTRelatedVideosViewController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
	%orig;
}
%end
%hook YTFullscreenEngagementOverlayView
- (BOOL)isEnabled {
    return NO;
} 
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
} 
%end
%hook YTFullscreenEngagementOverlayController
- (BOOL)isEnabled {
    return NO;
}
- (void)setEnabled:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayView
- (void)setInfoCardButtonHidden:(BOOL)arg1 {
    arg1 = YES;
    %orig;
}
- (void)setInfoCardButtonVisible:(BOOL)arg1 {
    arg1 = NO;
    %orig;
}
%end
%hook YTMainAppVideoPlayerOverlayViewController
- (void)adjustPlayerBarPositionForRelatedVideos {
}
%end
%end

%group gEnableiPadStyleOniPhone
%hook UIDevice
- (long long)userInterfaceIdiom {
    return YES;
} 
%end
%hook UIStatusBarStyleAttributes
- (long long)idiom {
    return NO;
} 
%end
%hook UIKBTree
- (long long)nativeIdiom {
    return NO;
} 
%end
%hook UIKBRenderer
- (long long)assetIdiom {
    return NO;
} 
%end
%end

%group gHidePreviousButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_previousButton").hidden = YES;
}
%end
%end

%group gHideNextButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTMainAppControlsOverlayView *>(self, "_nextButton").hidden = YES;
}
%end
%end

%group gDisableVideoAutoPlay
%hook YTPlaybackConfig
- (void)setStartPlayback:(BOOL)arg1 {
	arg1 = NO;
	%orig;
}
%end
%end

%group gHideAutoPlaySwitchInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
	if(![[self autonavSwitch] isHidden]) [[self autonavSwitch] setHidden:YES];
}
%end
%end

%group gHideCaptionsSubtitlesButtonInOverlay
%hook YTMainAppControlsOverlayView
- (void)layoutSubviews {
	%orig();
    if(![[self closedCaptionsOrSubtitlesButton] isHidden]) [[self closedCaptionsOrSubtitlesButton] setHidden:YES];
}
%end
%end

%group gDisableVideoInfoCards
%hook YTInfoCardDarkTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return NO;
}
%end
%hook YTInfoCardTeaserContainerView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
- (BOOL)isVisible {
    return NO;
}
%end
%hook YTSimpleInfoCardDarkTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTSimpleInfoCardTeaserView
- (id)initWithFrame:(CGRect)arg1 {
    return NULL;
}
%end
%hook YTPaidContentOverlayView
- (id)initWithParentResponder:(id)arg1 paidContentRenderer:(id)arg2 enableNewPaidProductDisclosure:(BOOL)arg3 {
    arg2 = NULL;
    arg3 = NO;
    return %orig;
}
%end
%end

%group gNoSearchButton
%hook YTRightNavigationButtons
- (void)layoutSubviews {
	%orig();
	if(![[self searchButton] isHidden]) [[self searchButton] setHidden:YES];
}
%end
%end

%group gHideTabBarLabels
%hook YTPivotBarItemView
- (void)layoutSubviews {
    %orig();
    [[self navigationButton] setTitle:@"" forState:UIControlStateNormal];
    [[self navigationButton] setTitle:@"" forState:UIControlStateSelected];
}
%end
%end

%group gHideChannelWatermark
%hook YTAnnotationsViewController
- (void)loadFeaturedChannelWatermark {
}
%end
%end

%group gUnlockUHDQuality
%hook YTSettings
- (BOOL)isWebMEnabled {
    return YES;
}
%end
%hook YTUserDefaults
- (int)manualQualitySelectionChosenResolution {
    return 2160;
}
- (int)ml_manualQualitySelectionChosenResolution {
    return 2160;
}
- (int)manualQualitySelectionPrecedingResolution {
    return 2160;
}
- (int)ml_manualQualitySelectionPrecedingResolution {
    return 2160;
}
%end
%hook MLManualFormatSelectionMetadata
- (int)stickyCeilingResolution {
    return 2160;
}
%end
%hook YTIHamplayerStreamFilter
- (BOOL)enableVideoCodecSplicing {
    return YES;
}
- (BOOL)hasVp9 {
    return YES;
}
%end
%hook YTIHamplayerSoftwareStreamFilter
- (int)maxFps {
    return 60;
}
- (int)maxArea {
    return 8294400;
}
%end
%end

%group gHideShortsCameraButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_cameraOrSearchButton").hidden = YES;
}
%end
%end

%group gHideShortsMoreActionsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_overflowButton").hidden = YES;
}
%end
%end

%group gHideShortsLikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelLikeButton").hidden = YES;
}
%end
%end

%group gHideShortsDislikeButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_reelDislikeButton").hidden = YES;
}
%end
%end

%group gHideShortsCommentsButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_viewCommentButton").hidden = YES;
}
%end
%end

%group gHideShortsShareButton
%hook YTReelWatchPlaybackOverlayView
- (void)layoutSubviews {
	%orig();
	MSHookIvar<YTQTMButton *>(self, "_shareButton").hidden = YES;
}
%end
%end

%group gColourOptions
%hook UIView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPivotBarView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSlideForActionsView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTChipCloudCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTEngagementPanelView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistPanelProminentThumbnailVideoCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTPlaylistHeaderView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTAsyncCollectionView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTLinkCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTMessageCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTSearchView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTDrawerAvatarCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFeedHeaderView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTextCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatViewerEngagementCell")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTCommentsHeaderView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatView")]) {
        color = rebornCustomColour;
    }
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YCHLiveChatTickerViewController")]) {
        color = rebornCustomColour;
    }
    %orig;
}
- (void)layoutSubviews {
    %orig();
    if([self.nextResponder isKindOfClass:NSClassFromString(@"_ASDisplayView")]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
}
%end
%hook YTAsyncCollectionView
- (void)setBackgroundColor:(UIColor *)color {
    if([self.nextResponder isKindOfClass:NSClassFromString(@"YTRelatedVideosCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else if([self.nextResponder isKindOfClass:NSClassFromString(@"YTFullscreenMetadataHighlightsCollectionViewController")]) {
        color = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    } else {
        color = rebornCustomColour;
    }
    %orig;
}
%end
%hook YTPivotBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTSubheaderContainerView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTAppView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTChannelListSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTSlideForActionsView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTPageView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTWatchView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTPlaylistMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTEngagementPanelHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTPlaylistPanelControlsView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTHorizontalCardListView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTWatchMiniBarView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTCreateCommentAccessoryView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTCreateCommentTextView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTSearchView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTVideoView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTSearchBoxView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTTabTitlesView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTPrivacyTosFooterView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTOfflineStorageUsageView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTInlineSignInView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTFeedChannelFilterHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YCHLiveChatView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YCHLiveChatActionPanelView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTEmojiTextView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTTopAlignedView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
- (void)layoutSubviews {
    %orig();
    MSHookIvar<YTTopAlignedView *>(self, "_contentView").backgroundColor = rebornCustomColour;
}
%end
%hook GOODialogView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTNavigationBar
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
- (void)setBarTintColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTChannelMobileHeaderView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTChannelSubMenuView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTWrapperSplitView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTReelShelfCell
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTReelShelfItemView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTReelShelfView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YTCommentView
- (void)setBackgroundColor:(UIColor *)color {
    color = rebornCustomColour;
    %orig;
}
%end
%hook YCHLiveChatBannerCell
- (void)layoutSubviews {
	%orig();
	MSHookIvar<UIImageView *>(self, "_bannerContainerImageView").hidden = YES;
    MSHookIvar<UIView *>(self, "_bannerContainerView").backgroundColor = rebornCustomColour;
}
%end
%hook YTSearchSuggestionCollectionViewCell
- (void)updateColors {
}
%end
%end

%group gAutoFullScreen
%hook YTPlayerViewController
- (void)loadWithPlayerTransition:(id)arg1 playbackConfig:(id)arg2 {
    %orig();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        YTWatchController *watchController = [self valueForKey:@"_UIDelegate"];
        [watchController showFullScreen];
    });
}
%end
%end

%group gHideYouTubeLogo
%hook YTHeaderLogoController
- (YTHeaderLogoController *)init {
    return NULL;
}
%end
%end

%group gEnableEnhancedSearchBar
%hook YTColdConfig
- (BOOL)isEnhancedSearchBarEnabled {
    return YES;
}
%end
%end

%group gHideTabBar
%hook YTPivotBarView
- (BOOL)isHidden {
    return YES;
}
- (void)layoutSubviews {
	%orig();
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView1").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView2").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView3").hidden = YES;
    MSHookIvar<YTPivotBarItemView *>(self, "_itemView4").hidden = YES;
	MSHookIvar<YTPivotBarItemView *>(self, "_itemView5").hidden = YES;
}
- (YTPivotBarItemView *)itemView1 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView2 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView3 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView4 {
	return 1 ? 0 : %orig;
}
- (YTPivotBarItemView *)itemView5 {
	return 1 ? 0 : %orig;
}
%end
%end

int selectedTabIndex = 0;

%hook YTPivotBarViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig();
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"]) {
        int selectedTab = [[NSUserDefaults standardUserDefaults] integerForKey:@"kStartupPageInt"];
        if (selectedTab == 0 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEwhat_to_watch"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 1 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEexplore"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 2 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEshorts"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 3 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEuploads"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 4 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEsubscriptions"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 5 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FElibrary"];
            selectedTabIndex = 1;
        }
        if (selectedTab == 6 && selectedTabIndex == 0) {
            [self selectItemWithPivotIdentifier:@"FEtrending"];
            selectedTabIndex = 1;
        }
    }
}
%end

%hook YTColdConfig
- (BOOL)shouldUseAppThemeSetting {
    return YES;
}
- (BOOL)enableYouthereCommandsOnIos {
    return NO;
}
%end

%hook YTYouThereController
- (BOOL)shouldShowYouTherePrompt {
    return NO;
}
%end

%hook YTCommerceEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers {
}
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial {
    return YES;
}
%end

%hook YTSettings
- (BOOL)allowAudioOnlyManualQualitySelection {
    return YES;
}
%end

%hook YTUpsell
- (BOOL)isCounterfactual {
    return YES;
}
%end

static void colourPrefsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    rebornCustomColour = hexColour();
}

%ctor {
    @autoreleasepool {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"kEnableNoVideoAds"] == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableNoVideoAds"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableNoVideoAds"] == YES) %init(gNoVideoAds);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableBackgroundPlayback"] == YES) %init(gBackgroundPlayback);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"] == YES) %init(gNoCastButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"] == YES) %init(gNoNotificationButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAllowHDOnCellularData"] == YES) %init(gAllowHDOnCellularData);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoEndscreenPopups"] == YES) %init(gDisableVideoEndscreenPopups);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"] == YES) %init(gDisableYouTubeKids);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVoiceSearch"] == YES) %init(gDisableVoiceSearch);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"] == YES) %init(gDisableHints);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBarLabels"] == YES) %init(gHideTabBarLabels);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideExploreTab"] == YES) %init(gHideExploreTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideUploadTab"] == YES) %init(gHideUploadTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideSubscriptionsTab"] == YES) %init(gHideSubscriptionsTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideLibraryTab"] == YES) %init(gHideLibraryTab);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableDoubleTapToSkip"] == YES) %init(gDisableDoubleTapToSkip);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"] == YES) %init(gHideOverlayDarkBackground);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousButtonInOverlay"] == YES) %init(gHidePreviousButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideNextButtonInOverlay"] == YES) %init(gHideNextButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoAutoPlay"] == YES) %init(gDisableVideoAutoPlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"] == YES) %init(gHideAutoPlaySwitchInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"] == YES) %init(gHideCaptionsSubtitlesButtonInOverlay);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableVideoInfoCards"] == YES) %init(gDisableVideoInfoCards);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"] == YES) %init(gNoSearchButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideChannelWatermark"] == YES) %init(gHideChannelWatermark);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kUnlockUHDQuality"] == YES) %init(gUnlockUHDQuality);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCameraButton"] == YES) %init(gHideShortsCameraButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsMoreActionsButton"] == YES) %init(gHideShortsMoreActionsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsLikeButton"] == YES) %init(gHideShortsLikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsDislikeButton"] == YES) %init(gHideShortsDislikeButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsCommentsButton"] == YES) %init(gHideShortsCommentsButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideShortsShareButton"] == YES) %init(gHideShortsShareButton);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAutoFullScreen"] == YES) %init(gAutoFullScreen);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideYouTubeLogo"] == YES) %init(gHideYouTubeLogo);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableEnhancedSearchBar"] == YES) %init(gEnableEnhancedSearchBar);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kHideTabBar"] == YES) %init(gHideTabBar);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES) {
            %init(gShowStatusBarInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"] == NO) {
            %init(gEnableiPadStyleOniPhone);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == NO & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES) {
            %init(gDisableRelatedVideosInOverlay);
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == YES or [[NSUserDefaults standardUserDefaults] boolForKey:@"kAlwaysShowPlayerBar"] == YES & [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"] == NO) {
            %init(gAlwaysShowPlayerBar);
        }
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kYTRebornColourOptionsVTwo"];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
        [unarchiver setRequiresSecureCoding:NO];
        NSString *hexString = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        if(hexString != nil) {
            rebornCustomColour = hexColour();
            CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)colourPrefsChanged, CFSTR("h.ryan.youtubereborn.prefs.colour"), NULL, CFNotificationSuspensionBehaviorCoalesce);
            %init(gColourOptions);
        }
        %init(_ungrouped);
    }
}
