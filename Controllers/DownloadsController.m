#import "DownloadsController.h"
#import "DownloadsVideoController.h"
#import "DownloadsAudioController.h"

@interface DownloadsController ()
- (void)coloursView;
@end

@implementation DownloadsController

- (void)loadView {
	[super loadView];
    [self coloursView];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    self.tabBar = [[UITabBarController alloc] init];

    DownloadsVideoController *videoViewController = [[DownloadsVideoController alloc] init];
    videoViewController.title = @"Video";
    videoViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Video" image:[UIImage systemImageNamed:@"video.circle.fill"] tag:0];
    UINavigationController *videoNavViewController = [[UINavigationController alloc] initWithRootViewController:videoViewController];

    DownloadsAudioController *audioViewController = [[DownloadsAudioController alloc] init];
    audioViewController.title = @"Audio";
    audioViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Audio" image:[UIImage systemImageNamed:@"music.note"] tag:1];
    UINavigationController *audioNavViewController = [[UINavigationController alloc] initWithRootViewController:audioViewController];

    self.tabBar.viewControllers = [NSArray arrayWithObjects:videoNavViewController, audioNavViewController, nil];

    [self.view addSubview:self.tabBar.view];
}

- (void)coloursView {
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    else {
        self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self coloursView];
}

@end

@implementation DownloadsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
