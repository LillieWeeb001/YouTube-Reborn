#import "RootOptionsController.h"
#import "VideoOptionsController.h"
#import "OverlayOptionsController.h"
#import "TabBarOptionsController.h"
#import "CreditsController.h"
#import "ShortsOptionsController.h"
#import "RebornSettingsController.h"
#import "DownloadsController.h"
#import "SponsorBlockOptionsController.h"
#import "ChangelogsController.h"
#import "../JailbreakDetection/JailbreakDetection.h"
#import "../TheosLinuxFix.h"
#import "../iOS15Fix.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface RootOptionsController ()
- (void)setupRootOptionsControllerView;
@end

@implementation RootOptionsController

- (void)loadView {
	[super loadView];
    [self setupRootOptionsControllerView];

    self.title = @"Options";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    self.navigationItem.leftBarButtonItem = doneButton;

    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(apply)];
    self.navigationItem.rightBarButtonItem = applyButton;

	if (@available(iOS 15.0, *)) {
    	[self.tableView setSectionHeaderTopPadding:0.0f];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        if ([JailbreakDetection isJailbroken]) {
            return 2;
        } else {
            return 1;
        }
    }
    if (section == 2) {
        return 6;
    }
    if (section == 3) {
        return 7;
    }
    if (section == 4) {
        return 3;
    }
    if (section == 5) {
        return 0;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RootTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.adjustsFontSizeToFitWidth = true;
        if (@available(iOS 13.0, *)) {
            if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
                cell.textLabel.textColor = [UIColor blackColor];
            } else {
                cell.backgroundColor = [UIColor colorWithRed:0.110 green:0.110 blue:0.118 alpha:1.0];
                cell.textLabel.textColor = [UIColor whiteColor];
            }
        } else {
            cell.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Donate";
            }
        }
        if (indexPath.section == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"View Downloads";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"View Downloads In Filza";
            }
        }
        if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Video Options";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Overlay Options";
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Tab Bar Options";
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"Colour Options";
            }
            if (indexPath.row == 4) {
                cell.textLabel.text = @"Shorts Options";
            }
            if (indexPath.row == 5) {
                cell.textLabel.text = @"SponsorBlock Options (Beta)";
            }
        }
        if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Enable iPad Style On iPhone";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *enableiPadStyleOniPhone = [[UISwitch alloc] initWithFrame:CGRectZero];
                [enableiPadStyleOniPhone addTarget:self action:@selector(toggleEnableiPadStyleOniPhone:) forControlEvents:UIControlEventValueChanged];
                enableiPadStyleOniPhone.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kEnableiPadStyleOniPhone"];
                cell.accessoryView = enableiPadStyleOniPhone;
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"No Cast Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noCastButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [noCastButton addTarget:self action:@selector(toggleNoCastButton:) forControlEvents:UIControlEventValueChanged];
                noCastButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoCastButton"];
                cell.accessoryView = noCastButton;
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"No Notification Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noNotificationButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [noNotificationButton addTarget:self action:@selector(toggleNoNotificationButton:) forControlEvents:UIControlEventValueChanged];
                noNotificationButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoNotificationButton"];
                cell.accessoryView = noNotificationButton;
            }
            if (indexPath.row == 3) {
                cell.textLabel.text = @"No Search Button";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *noSearchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
                [noSearchButton addTarget:self action:@selector(toggleNoSearchButton:) forControlEvents:UIControlEventValueChanged];
                noSearchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kNoSearchButton"];
                cell.accessoryView = noSearchButton;
            }
            if (indexPath.row == 4) {
                cell.textLabel.text = @"Disable YouTube Kids";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableYouTubeKidsPopup = [[UISwitch alloc] initWithFrame:CGRectZero];
                [disableYouTubeKidsPopup addTarget:self action:@selector(toggleDisableYouTubeKidsPopup:) forControlEvents:UIControlEventValueChanged];
                disableYouTubeKidsPopup.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableYouTubeKidsPopup"];
                cell.accessoryView = disableYouTubeKidsPopup;
            }
            if (indexPath.row == 5) {
                cell.textLabel.text = @"Disable Hints";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *disableHints = [[UISwitch alloc] initWithFrame:CGRectZero];
                [disableHints addTarget:self action:@selector(toggleDisableHints:) forControlEvents:UIControlEventValueChanged];
                disableHints.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kDisableHints"];
                cell.accessoryView = disableHints;
            }
            if (indexPath.row == 6) {
                cell.textLabel.text = @"Hide YouTube Logo";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UISwitch *hideYouTubeLogo = [[UISwitch alloc] initWithFrame:CGRectZero];
                [hideYouTubeLogo addTarget:self action:@selector(toggleHideYouTubeLogo:) forControlEvents:UIControlEventValueChanged];
                hideYouTubeLogo.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"kHideYouTubeLogo"];
                cell.accessoryView = hideYouTubeLogo;
            }
        }
        if (indexPath.section == 4) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Reborn Settings";
            }
            if (indexPath.row == 1) {
                cell.textLabel.text = @"Changelogs";
            }
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Credits";
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.patreon.com/lillieweeb"] options:@{} completionHandler:nil];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {    
            DownloadsController *downloadsController = [[DownloadsController alloc] init];
            UINavigationController *downloadsControllerView = [[UINavigationController alloc] initWithRootViewController:downloadsController];
            downloadsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:downloadsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            NSFileManager *fm = [[NSFileManager alloc] init];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *content = @"Filza Check";
            NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
            NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"FilzaCheck.txt"];
            [fm createFileAtPath:filePath contents:fileContents attributes:nil];
            NSString *path = [NSString stringWithFormat:@"filza://view%@/FilzaCheck.txt", documentsDirectory];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path] options:@{} completionHandler:nil];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {    
            VideoOptionsController *videoOptionsController = [[VideoOptionsController alloc] init];
            UINavigationController *videoOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:videoOptionsController];
            videoOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:videoOptionsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            OverlayOptionsController *overlayOptionsController = [[OverlayOptionsController alloc] init];
            UINavigationController *overlayOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:overlayOptionsController];
            overlayOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:overlayOptionsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 2) {
            TabBarOptionsController *tabBarOptionsController = [[TabBarOptionsController alloc] init];
            UINavigationController *tabBarOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:tabBarOptionsController];
            tabBarOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:tabBarOptionsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 3) {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"13.0")) {
                HBColorPickerViewController *alderisViewController = [[HBColorPickerViewController alloc] init];
                alderisViewController.delegate = self;
                alderisViewController.popoverPresentationController.sourceView = self.view;
                alderisViewController.popoverPresentationController.sourceRect = self.view.bounds;
                alderisViewController.popoverPresentationController.permittedArrowDirections = 0;

                NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"kYTRebornColourOptionsVThree"];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:colorData error:nil];
                [unarchiver setRequiresSecureCoding:NO];
                UIColor *colour = [unarchiver decodeObjectForKey:NSKeyedArchiveRootObjectKey];
                HBColorPickerConfiguration *configuration = [[HBColorPickerConfiguration alloc] initWithColor:colour];
                configuration.supportsAlpha = NO;

                alderisViewController.configuration = configuration;
                [self presentViewController:alderisViewController animated:YES completion:nil];
            } else {
                UIAlertController *alertError = [UIAlertController alertControllerWithTitle:@"Notice" message:@"Colour Options is not available on iOS 12 currently, it is only available for iOS 13+ right now" preferredStyle:UIAlertControllerStyleAlert];

                [alertError addAction:[UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];

                [self presentViewController:alertError animated:YES completion:nil];
            }
        }
        if (indexPath.row == 4) {
            ShortsOptionsController *shortsOptionsController = [[ShortsOptionsController alloc] init];
            UINavigationController *shortsOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:shortsOptionsController];
            shortsOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:shortsOptionsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 5) {
            SponsorBlockOptionsController *sponsorBlockOptionsController = [[SponsorBlockOptionsController alloc] init];
            UINavigationController *sponsorBlockOptionsControllerView = [[UINavigationController alloc] initWithRootViewController:sponsorBlockOptionsController];
            sponsorBlockOptionsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:sponsorBlockOptionsControllerView animated:YES completion:nil];
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            RebornSettingsController *rebornSettingsController = [[RebornSettingsController alloc] init];
            UINavigationController *rebornSettingsControllerView = [[UINavigationController alloc] initWithRootViewController:rebornSettingsController];
            rebornSettingsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:rebornSettingsControllerView animated:YES completion:nil];
        }
        if (indexPath.row == 1) {
            ChangelogsController *changelogsController = [[ChangelogsController alloc] init];

            [self presentViewController:changelogsController animated:YES completion:nil];
        }
        if (indexPath.row == 2) {
            CreditsController *creditsController = [[CreditsController alloc] init];
            UINavigationController *creditsControllerView = [[UINavigationController alloc] initWithRootViewController:creditsController];
            creditsControllerView.modalPresentationStyle = UIModalPresentationFullScreen;

            [self presentViewController:creditsControllerView animated:YES completion:nil];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return @"Version: 3.1.0 (Beta)";
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1 || section == 2 || section == 4 || section == 5) {
        return 60;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            view.tintColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        } else {
            view.tintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        }
    } else {
        view.tintColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
    }
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tableSection"]]];
    [footer.textLabel setFont:[UIFont systemFontOfSize:14]];
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 5) {
        return 60;
    }
    return 0;
}

- (void)colorPicker:self didAcceptColor:(UIColor *)colour {
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:colour requiringSecureCoding:nil error:nil];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"kYTRebornColourOptionsVThree"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self setupRootOptionsControllerView];
    [self.tableView reloadData];
}

@end

@implementation RootOptionsController (Privates)

- (void)done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)apply {
    exit(0); 
}

- (void)setupRootOptionsControllerView {
    if (@available(iOS 13.0, *)) {
        if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        } else {
            self.view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
            [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        }
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.969 alpha:1.0];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
}

- (void)toggleEnableiPadStyleOniPhone:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kEnableiPadStyleOniPhone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoCastButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoCastButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoNotificationButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoNotificationButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleNoSearchButton:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kNoSearchButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableYouTubeKidsPopup:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableYouTubeKidsPopup"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleDisableHints:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kDisableHints"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)toggleHideYouTubeLogo:(UISwitch *)sender {
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kHideYouTubeLogo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kHideYouTubeLogo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
