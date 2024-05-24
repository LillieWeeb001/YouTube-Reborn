#import "OverlayOptionsController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface OverlayOptionsController ()
- (void)coloursView;
@end

static BOOL hasDeviceNotch() {
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
		return NO;
	} else {
		LAContext* context = [[LAContext alloc] init];
		[context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
		return [context biometryType] == LABiometryTypeFaceID;
	}
}

@implementation OverlayOptionsController

- (void)loadView {
	[super loadView];
    [self coloursView];

    self.title = @"Overlay Options";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    [self.tableView setSectionHeaderTopPadding:0.0f];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OverlayTableViewCell"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }
        else {
            cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.textColor = [UIColor whiteColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Show Status Bar In Overlay (Portrait Only)";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"] == YES || hasDeviceNotch() == YES) {
                cell.accessoryType = UITableViewCellAccessoryDetailButton;
            }
            else {
                UISwitch *showStatusBarInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
                [showStatusBarInOverlay addTarget:self action:@selector(toggleShowStatusBarInOverlay:) forControlEvents:UIControlEventValueChanged];
                showStatusBarInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kShowStatusBarInOverlay"];
                cell.accessoryView = showStatusBarInOverlay;
            }
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"Hide Previous Button";
            UISwitch *hidePreviousButtonInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hidePreviousButtonInOverlay addTarget:self action:@selector(toggleHidePreviousButtonInOverlay:) forControlEvents:UIControlEventValueChanged];
            hidePreviousButtonInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHidePreviousButtonInOverlay"];
            cell.accessoryView = hidePreviousButtonInOverlay;
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"Hide Next Button";
            UISwitch *hideNextButtonInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideNextButtonInOverlay addTarget:self action:@selector(toggleHideNextButtonInOverlay:) forControlEvents:UIControlEventValueChanged];
            hideNextButtonInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideNextButtonInOverlay"];
            cell.accessoryView = hideNextButtonInOverlay;
        }
        if (indexPath.row == 3) {
            cell.textLabel.text = @"Hide AutoPlay Switch";
            UISwitch *hideAutoPlaySwitchInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideAutoPlaySwitchInOverlay addTarget:self action:@selector(toggleHideAutoPlaySwitchInOverlay:) forControlEvents:UIControlEventValueChanged];
            hideAutoPlaySwitchInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideAutoPlaySwitchInOverlay"];
            cell.accessoryView = hideAutoPlaySwitchInOverlay;
        }
        if (indexPath.row == 4) {
            cell.textLabel.text = @"Hide Captions/Subtitles Button";
            UISwitch *hideCaptionsSubtitlesButtonInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideCaptionsSubtitlesButtonInOverlay addTarget:self action:@selector(toggleHideCaptionsSubtitlesButtonInOverlay:) forControlEvents:UIControlEventValueChanged];
            hideCaptionsSubtitlesButtonInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
            cell.accessoryView = hideCaptionsSubtitlesButtonInOverlay;
        }
        if (indexPath.row == 5) {
            cell.textLabel.text = @"Disable Related Videos";
            UISwitch *disableRelatedVideosInOverlay = [[UISwitch alloc] initWithFrame:CGRectZero];
            [disableRelatedVideosInOverlay addTarget:self action:@selector(toggleDisableRelatedVideosInOverlay:) forControlEvents:UIControlEventValueChanged];
            disableRelatedVideosInOverlay.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableRelatedVideosInOverlay"];
            cell.accessoryView = disableRelatedVideosInOverlay;
        }
        if (indexPath.row == 6) {
            cell.textLabel.text = @"Hide Dark Background";
            UISwitch *hideOverlayDarkBackground = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideOverlayDarkBackground addTarget:self action:@selector(toggleHideOverlayDarkBackground:) forControlEvents:UIControlEventValueChanged];
            hideOverlayDarkBackground.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayDarkBackground"];
            cell.accessoryView = hideOverlayDarkBackground;
        }
        if (indexPath.row == 7) {
            cell.textLabel.text = @"Hide Quick Actions";
            UISwitch *hideOverlayQuickActions = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideOverlayQuickActions addTarget:self action:@selector(toggleHideOverlayQuickActions:) forControlEvents:UIControlEventValueChanged];
            hideOverlayQuickActions.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideOverlayQuickActions"];
            cell.accessoryView = hideOverlayQuickActions;
        }
        if (indexPath.row == 8) {
            cell.textLabel.text = @"Hide Current Time";
            UISwitch *hideCurrentTime = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideCurrentTime addTarget:self action:@selector(toggleHideCurrentTime:) forControlEvents:UIControlEventValueChanged];
            hideCurrentTime.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideCurrentTime"];
            cell.accessoryView = hideCurrentTime;
        }
        if (indexPath.row == 9) {
            cell.textLabel.text = @"Hide Duration";
            UISwitch *hideDuration = [[UISwitch alloc] initWithFrame:CGRectZero];
            [hideDuration addTarget:self action:@selector(toggleHideDuration:) forControlEvents:UIControlEventValueChanged];
            hideDuration.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideDuration"];
            cell.accessoryView = hideDuration;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (hasDeviceNotch()) {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This option can't be enabled on notched idevices" preferredStyle:UIAlertControllerStyleAlert];

        [alertError addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];

        [self presentViewController:alertError animated:YES completion:nil];
    } else {
        UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"Notice" message:@"This option can't be enabled with 'Enable iPad Style On iPhone' enabled" preferredStyle:UIAlertControllerStyleAlert];

        [alertError addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }]];

        [self presentViewController:alertError animated:YES completion:nil];
    }
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
    [self.tableView reloadData];
}

@end

@implementation OverlayOptionsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleShowStatusBarInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kShowStatusBarInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kShowStatusBarInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHidePreviousButtonInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHidePreviousButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHidePreviousButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideNextButtonInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideNextButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideNextButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideAutoPlaySwitchInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideAutoPlaySwitchInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideAutoPlaySwitchInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideCaptionsSubtitlesButtonInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableRelatedVideosInOverlay:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableRelatedVideosInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableRelatedVideosInOverlay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideOverlayDarkBackground:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideOverlayDarkBackground"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideOverlayDarkBackground"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideOverlayQuickActions:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideOverlayQuickActions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideOverlayQuickActions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideCurrentTime:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideCurrentTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideCurrentTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideDuration:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideDuration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end