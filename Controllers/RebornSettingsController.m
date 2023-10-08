#import "RebornSettingsController.h"

@interface RebornSettingsController ()
- (void)coloursView;
@end

@implementation RebornSettingsController

- (void)loadView {
	[super loadView];
    [self coloursView];

    self.title = @"Reborn Options";

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = doneButton;

    if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 2;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RebornSettingsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

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
        if (indexPath.section == 0) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"I Have YouTube Premium";
                UISwitch *rebornIHaveYouTubePremiumButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [rebornIHaveYouTubePremiumButton addTarget:self action:@selector(toggleRebornIHaveYouTubePremiumButton:) forControlEvents:UIControlEventValueChanged];
                rebornIHaveYouTubePremiumButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kRebornIHaveYouTubePremium"];
                cell.accessoryView = rebornIHaveYouTubePremiumButton;
            }
        }
        if (indexPath.section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Hide Video Overlay 'OP' Button";
                UISwitch *hideRebornOPButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideRebornOPButton addTarget:self action:@selector(toggleHideRebornOPButton:) forControlEvents:UIControlEventValueChanged];
                hideRebornOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornOPButtonVTwo"];
                cell.accessoryView = hideRebornOPButton;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Hide Shorts Overlay 'OP' Button";
                UISwitch *hideRebornShortsOPButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideRebornShortsOPButton addTarget:self action:@selector(toggleHideRebornShortsOPButton:) forControlEvents:UIControlEventValueChanged];
                hideRebornShortsOPButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideRebornShortsOPButton"];
                cell.accessoryView = hideRebornShortsOPButton;
            }
        }
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Reset Colour Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Reset All YouTube Reborn Options";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [theTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Are you sure you want to reset your set colour?" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kYTRebornColourOptionsVFour"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                exit(0);
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Are you sure you want to reset all your options?" preferredStyle:UIAlertControllerStyleAlert];

            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }]];

            [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableNoVideoAds"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableBackgroundPlayback"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kNoCastButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kNoNotificationButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAllowHDOnCellularData"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableVideoEndscreenPopups"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableYouTubeKidsPopup"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableExtraSpeedOptions"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableHints"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideTabBarLabels"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideExploreTab"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsTab"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideUploadTab"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideSubscriptionsTab"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideLibraryTab"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableDoubleTapToSkip"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideOverlayDarkBackground"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePreviousButtonInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideNextButtonInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableVideoAutoPlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideAutoPlaySwitchInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideCaptionsSubtitlesButtonInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableVideoInfoCards"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kNoSearchButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideChannelWatermark"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsMoreActionsButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsLikeButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsDislikeButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsCommentsButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsRemixButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsShareButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideShortsSubscriptionsButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAutoFullScreen"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideYouTubeLogo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kDisableRelatedVideosInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideOverlayQuickActions"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableiPadStyleOniPhone"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePlayerBarHeatwave"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePictureInPictureAdsBadge"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePictureInPictureSponsorBadge"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePreviousButtonShadowInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideNextButtonShadowInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHidePlayPauseButtonShadowInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableCustomDoubleTapToSkipDuration"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kAlwaysShowPlayerBarVTwo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kShowStatusBarInOverlay"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kYTRebornColourOptionsVFour"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnablePictureInPictureVTwo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kEnableCustomDoubleTapToSkipDuration"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kCustomDoubleTapToSkipDuration"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kRebornIHaveYouTubePremium"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kSourceSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kSponsorSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kSelfPromoSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kInteractionSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kIntroSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kOutroSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kPreviewSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kMusicOffTopicSegmentedInt"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kStartupPageIntVTwo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideRebornOPButtonVTwo"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideRebornShortsOPButton"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideCurrentTime"];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"kHideDuration"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                exit(0);
            }]];

            [self presentViewController:alert animated:YES completion:nil];
        }
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

@implementation RebornSettingsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)toggleRebornIHaveYouTubePremiumButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kRebornIHaveYouTubePremium"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kRebornIHaveYouTubePremium"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornOPButtonVTwo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideRebornShortsOPButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideRebornShortsOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideRebornShortsOPButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
