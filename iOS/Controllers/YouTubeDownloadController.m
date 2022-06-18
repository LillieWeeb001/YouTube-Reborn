#import "YouTubeDownloadController.h"
#import "../MobileFFmpeg/MobileFFmpegConfig.h"
#import "../MobileFFmpeg/MobileFFmpeg.h"
#import "../AFNetworking/AFNetworking.h"
#import "../TheosLinuxFix.h"
#import "../iOS15Fix.h"

@interface YouTubeDownloadController () {
    UIImageView *artworkImage;
    UILabel *titleLabel;
    UILabel *downloadPercentLabel;
}
- (void)setupYouTubeDownloadControllerView;
- (void)videoDownloaderPartOne;
- (void)videoDownloaderPartTwo :(NSURL *)videoFilePath;
- (void)audioDownloader;
@end

@implementation YouTubeDownloadController

- (void)loadView {
    [super loadView];

    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [self setupYouTubeDownloadControllerView];

    UIWindow *boundsWindow = [[UIApplication sharedApplication] keyWindow];

    artworkImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, boundsWindow.safeAreaInsets.top, self.view.bounds.size.width, 480)];
    UIImage *artwork = [UIImage imageWithData:[NSData dataWithContentsOfURL:self.artworkURL]];
    artworkImage.image = artwork;

    if ([[self.artworkURL pathExtension] isEqualToString:@"jpg"]) {
        [self.view addSubview:artworkImage];
    }

    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, boundsWindow.safeAreaInsets.top + 480, self.view.bounds.size.width, 50)];
    titleLabel.text = self.downloadTitle;
    titleLabel.numberOfLines = 2;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    // titleLabel.textAlignment = NSTextAlignmentCenter;
    /* if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            titleLabel.textColor = [UIColor blackColor];
        } else {
            titleLabel.textColor = [UIColor whiteColor];
        }
    } else {
        titleLabel.textColor = [UIColor blackColor];
    } */

    [self.view addSubview:titleLabel];

    downloadPercentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, boundsWindow.safeAreaInsets.top + 480 + titleLabel.frame.size.height, self.view.bounds.size.width, 50)];
    downloadPercentLabel.numberOfLines = 1;
    downloadPercentLabel.adjustsFontSizeToFitWidth = YES;
    // downloadPercentLabel.textAlignment = NSTextAlignmentCenter;
    /* if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            downloadPercentLabel.textColor = [UIColor blackColor];
        } else {
            downloadPercentLabel.textColor = [UIColor whiteColor];
        }
    } else {
        downloadPercentLabel.textColor = [UIColor blackColor];
    } */

    [self.view addSubview:downloadPercentLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.modalInPresentation = YES;
    }

    if (self.downloadOption == 0) {
        [self videoDownloaderPartOne];
    } else if (self.downloadOption == 1) {
        [self audioDownloader];
    }
}

- (void)videoDownloaderPartOne {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.videoURL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float downloadPercent = downloadProgress.fractionCompleted * 100;
            downloadPercentLabel.text = [NSString stringWithFormat:@"Progress: %.02f%%", downloadPercent];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [self videoDownloaderPartTwo:filePath];
    }];
    [downloadTask resume];
}

- (void)videoDownloaderPartTwo :(NSURL *)videoFilePath {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.audioURL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float downloadPercent = downloadProgress.fractionCompleted * 100;
            downloadPercentLabel.text = [NSString stringWithFormat:@"Progress: %.02f%%", downloadPercent];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        [MobileFFmpeg execute:[NSString stringWithFormat:@"-i %@ -c:a libmp3lame -q:a 8 %@/videoplayback.mp3", filePath, documentsDirectory]];
        [MobileFFmpeg execute:[NSString stringWithFormat:@"-i %@ -i %@/videoplayback.mp3 -c:v copy -c:a aac %@/output.mp4", videoFilePath, documentsDirectory, documentsDirectory]];
        [[NSFileManager defaultManager] moveItemAtPath:[NSString stringWithFormat:@"%@/output.mp4", documentsDirectory] toPath:[NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, [[self.downloadTitle componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""]] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[videoFilePath path] error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/videoplayback.mp3", documentsDirectory] error:nil];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [downloadTask resume];
}

- (void)audioDownloader {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:self.audioURL];

    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float downloadPercent = downloadProgress.fractionCompleted * 100;
            downloadPercentLabel.text = [NSString stringWithFormat:@"Progress: %.02f%%", downloadPercent];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSCharacterSet *notAllowedChars = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        [MobileFFmpeg execute:[NSString stringWithFormat:@"-i %@ -c:a libmp3lame -q:a 8 %@/%@.mp3", filePath, documentsDirectory, [[self.downloadTitle componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""]]];
        [[NSFileManager defaultManager] removeItemAtPath:[filePath path] error:nil];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }];
    [downloadTask resume];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupYouTubeDownloadControllerView];
    /* if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            titleLabel.textColor = [UIColor blackColor];
            downloadPercentLabel.textColor = [UIColor blackColor];
        } else {
            titleLabel.textColor = [UIColor whiteColor];
            downloadPercentLabel.textColor = [UIColor whiteColor];
        }
    } else {
        titleLabel.textColor = [UIColor blackColor];
        downloadPercentLabel.textColor = [UIColor blackColor];
    } */
}

@end

@implementation YouTubeDownloadController (Privates)

- (void)setupYouTubeDownloadControllerView {
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        } else {
            self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
}

@end
